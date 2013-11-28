#include "endpoint.h"

#include "rpc.h"
#include "semphr.h"
#include "timers.h"

#include <limits.h>
#include <stddef.h>
#include <string.h>

#define RPC_GET_ENDPOINT_PARAMS 0x20
#define RPC_READ_ENDPOINT 0x21
#define RPC_WRITE_ENDPOINT 0x22
#define RPC_RESET_ENDPOINT 0x23
#define RPC_READ_MENU 0x24

#define RPC_MASTER_ANNOUNCE 0x30
#define RPC_ENDPOINT_SYNC 0x31
#define RPC_ENDPOINT_SERVER_ERROR 0x32
#define RPC_NOTIFY_ENDPOINT 0x33

static int numBytesForType(enum endpointType type) {
    switch(type) {
        case ENDPOINT_UNKNOWN: return 0;
        case ENDPOINT_INT16: return 2;
        case ENDPOINT_INT32: return 4;
        case ENDPOINT_ENUM: return 2;
        case ENDPOINT_TIME: return 0; // NOT IMPLEMENTED YET
        case ENDPOINT_MENU: return 0; // NOT IMPLEMENTED YET
        default: return 0;
    }
}

static struct ReadWriteEndpoint *findEndpoint(int id) {
    int i;
    for(i = 0; i < numEndpoints; i++) {
        if(endpoints[i].id == id)
            return endpoints + i;
    }
    return NULL;
}

// Number of entries in update state arrays
#define MAX_CLIENT_CALLBACK_ENTRIES 10
#define MAX_SERVER_CALLBACK_ENTRIES 10

// Maximum time from last unicast contact with master before error (seconds)
#define MAX_NO_CONTACT_TIME 3600 // One hour
xTimerHandle masterContactTimer;

struct clientCallbackEntry {
    int id;
    int serverAddr;
    updateCallback callback; // NULL indicates not used
};

struct serverCallbackEntry {
    int id;
    int clientAddr;
//    bool handled; // Keeps track if the data was handled when the array is updated during transmit
};

// Note that releasing the lock while iterating over these is safe, since additions
// happen at the end (will get done eventually) and removals happen in the middle
// (at worst a handler would get called twice)
static struct clientCallbackEntry clientCallbacks[MAX_CLIENT_CALLBACK_ENTRIES];
static int clientCallbacksUsed;
static xSemaphoreHandle clientCallbacksLock;

// Releasing the lock while iterating over these requires using the iteratingServerCallbacks flag
static struct serverCallbackEntry serverCallbacks[MAX_SERVER_CALLBACK_ENTRIES];
static int serverCallbacksUsed;
static bool iteratingServerCallbacks; // Set while iterating without the lock, cleared on write
static xSemaphoreHandle serverCallbacksLock;

static bool syncWithMaster(void);

// Must not insert twice!
bool addUpdateNotification(int address, int id, updateCallback callback, bool syncNow) {
    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    if(clientCallbacksUsed == MAX_CLIENT_CALLBACK_ENTRIES) { // Already full
        xSemaphoreGive(clientCallbacksLock);
        return false;
    }
    struct clientCallbackEntry *dest = clientCallbacks + clientCallbacksUsed++;
    dest->id = id;
    dest->serverAddr = address;
    dest->callback = callback;
    xSemaphoreGive(clientCallbacksLock);

    if(syncNow)
        return syncWithMaster();
    return true;
}

// Returns true even if missing
bool removeUpdateNotification(int address, int id, updateCallback callback, bool syncNow) {
    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    int i;
    for(i = 0; i < clientCallbacksUsed; i++) {
        struct clientCallbackEntry *curr = clientCallbacks + i;
        if(curr->id == id && curr->serverAddr == address && curr->callback == callback) {
            memmove(curr, curr + 1, (clientCallbacksUsed - 1 - i) * sizeof(*curr));
            clientCallbacksUsed--;
        }
    }
    xSemaphoreGive(clientCallbacksLock);

    if(syncNow)
        return syncWithMaster();
    return true;
}

// Timer expired, indicating faulty communications
static void noContactExpired(xTimerHandle timer) {
    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    int i;
    for(i = 0; i < clientCallbacksUsed; i++) {
        struct clientCallbackEntry *curr = clientCallbacks + i;
        int id = curr->id;
        int addr = curr->serverAddr;
        updateCallback callback = curr->callback;
        // This is safe since insertions are at the end (will be gotten eventually)
        // and removals are in the middle (may call twice, but no worse)
        xSemaphoreGive(clientCallbacksLock);

        callback(addr, id, ENDPOINT_UNKNOWN, NULL);

        xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    }
    xSemaphoreGive(clientCallbacksLock);
}

// Buffer must always be large enough! (ensure manually)
static void fillWithClientCallbacks(void *buffer, unsigned short *dataLen) {
    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    char *curr = buffer;
    int i;
    for(i = 0; i < clientCallbacksUsed; i++) {
        struct clientCallbackEntry *source = clientCallbacks + i;
        memcpy(curr, &source->serverAddr, 2);
        curr += 2;
        memcpy(curr, &source->id, 2);
        curr += 2;
    }
    *dataLen = curr - (char *) buffer;
    xSemaphoreGive(clientCallbacksLock);
}

// Return value indicates if data is sensible
static bool fillServerCallbacksWith(void *data, unsigned short dataLen) {
    if((dataLen & 3) != 0 || dataLen > MAX_SERVER_CALLBACK_ENTRIES * 6)
        return false; // Check that the amount of data makes sense

    xSemaphoreTake(serverCallbacksLock, portMAX_DELAY);
    char *curr = data;
    int i;
    for(i = 0; curr < ((char *) data) + dataLen; i++) {
        struct serverCallbackEntry *dest = serverCallbacks + i;
        memcpy(&dest->clientAddr, curr, 2);
        curr += 2;
        memcpy(&dest->id, curr, 2);
        curr += 2;
    }
    serverCallbacksUsed = i;
    iteratingServerCallbacks = false; // Cause the iteration to restart
    xSemaphoreGive(serverCallbacksLock);
    return true;
}

// Synchronizes both kinds of data
static bool syncWithMaster(void) {
    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    fillWithClientCallbacks(request.data, &request.len);

    if(!doRPCCall(&request, &response, 0, RPC_ENDPOINT_SYNC, 4, 5000))
        return false;

    bool success = fillServerCallbacksWith(response.data, response.len);

    if(success)
        xTimerReset(masterContactTimer, portMAX_DELAY);
    return success;
}

// Handles sync requests
static bool handleSyncWithMaster(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(from != 0) // Only respond to the master
        return false;

    bool success = fillServerCallbacksWith(inData, inLen);
    if(!success)
        return false;
    
    fillWithClientCallbacks(outData, outLen);
    xTimerReset(masterContactTimer, portMAX_DELAY);
    return true;
}

// Handles global master device announcement (no response)
static bool handleMasterAnnounce(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(from != 0) // Only respond to the master
        return false;

    // Ignore data, at least for now
    // TODO: Add random delay?
    syncWithMaster();
    return true;
}

// Handles master's indication that a server failed
static bool handleServerError(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(from != 0) // Only respond to the master
        return false;

    if(inLen != 2)
        return false;

    int server;
    memcpy(&server, inData, 2);
    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    int i;
    for(i = 0; i < clientCallbacksUsed; i++) {
        struct clientCallbackEntry *curr = clientCallbacks + i;
        if(curr->serverAddr == server) {
            int id = curr->id;
            updateCallback callback = curr->callback;
            // This is safe since insertions are at the end (will be gotten eventually)
            // and removals are in the middle (may call twice, but no worse)
            xSemaphoreGive(clientCallbacksLock);

            callback(server, id, ENDPOINT_UNKNOWN, NULL);

            xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
        }
    }
    xSemaphoreGive(clientCallbacksLock);
    *outLen = 0;
    return true;
}

bool dataUpdated(int id) {
    struct ReadWriteEndpoint *endpoint = findEndpoint(id);
    if(endpoint == NULL || endpoint->read == NULL)
        return false;

    union endpointVal value;
    if(!endpoint->read(id, &value))
        return false;

    int intType = endpoint->params->type;
    int dataBytes = numBytesForType(endpoint->params->type);

    xSemaphoreTake(serverCallbacksLock, portMAX_DELAY);
    bool success = true;
    int i;
    iteratingServerCallbacks = true;
    for(i = 0; i < serverCallbacksUsed; i++) {
        struct serverCallbackEntry *curr = serverCallbacks + i;
        if(curr->id == id) {
            // Send data
            int addr = curr->clientAddr;
            // This is safe since we always re-check the iteratingServerCallbacks flag
            xSemaphoreGive(serverCallbacksLock);

            struct rpcDataBuffer request, response;
            if(!allocRPCBuffer(&request)) {
                return false;
            }

            bool currSuccess = true;
            request.len = dataBytes + 4;
            memcpy(request.data, &id, 2);
            memcpy((char *) request.data + 2, &intType, 2);
            memcpy((char *) request.data + 4, &value, dataBytes);

            if(!doRPCCall(&request, &response, addr, RPC_NOTIFY_ENDPOINT, 4, 5000)) {
                currSuccess = false;
            }

            if(currSuccess) {
                char code;
                memcpy(&code, response.data, 1);
                freeRPCBuffer(&response);
                if(code != 0) {
                    currSuccess = false;
                }
            }

            // Route all code paths through here to re-acquire lock
            if(!currSuccess)
                success = false;
            xSemaphoreTake(serverCallbacksLock, portMAX_DELAY);
            if(!iteratingServerCallbacks) {
                i = 0; // Restart
                iteratingServerCallbacks = true;
            }
        }
    }
    xSemaphoreGive(serverCallbacksLock);
    return success;
}

// Handles data from server
static bool handleDataUpdated(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen < 4)
        return false;

    int id;
    int intType;
    memcpy(&id, inData, 2);
    memcpy(&intType, (char *) inData + 2, 2);
    enum endpointType type = intType;
    int dataLen = numBytesForType(type);
    if(inLen != dataLen + 4)
        return false;

    union endpointVal value;
    memcpy(&value, (char *) inData + 4, dataLen);

    xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
    int i;
    for(i = 0; i < clientCallbacksUsed; i++) {
        struct clientCallbackEntry *curr = clientCallbacks + i;
        if(curr->id == id && curr->serverAddr == from) {
            updateCallback callback = curr->callback;
            // This is safe since insertions are at the end (will be gotten eventually)
            // and removals are in the middle (may call twice, but no worse)
            xSemaphoreGive(clientCallbacksLock);

            callback(from, id, type, &value);

            xSemaphoreTake(clientCallbacksLock, portMAX_DELAY);
        }
    }
    xSemaphoreGive(clientCallbacksLock);
    *outLen = 0;
    return true;
}

// Type is checked if not zero (on the remote end)
// Callback is set if changeCallback is not NULL
bool readFromEndpoint(int address, int id, enum endpointType *type, union endpointVal *value) {
    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    int intType = *type;
    request.len = 4; // Int is 2 bytes
    memcpy(request.data, &id, 2);
    memcpy((char *) request.data + 2, &intType, 2);;
    if(!doRPCCall(&request, &response, address, RPC_READ_ENDPOINT, 4, 5000))
        return false;

    // Check that there is enough length for the type
    if(response.len < 2) {
        freeRPCBuffer(&response);
        return false;
    }

    // Check the type is not unknown (indicates a faulty request) and that the length is sane
    int receivedType;
    memcpy(&receivedType, response.data, 2);
    if(receivedType == ENDPOINT_UNKNOWN && response.len - 2 != numBytesForType(receivedType)) {
        freeRPCBuffer(&response);
        return false;
    }

    // Populate the data
    *type = (enum endpointType) receivedType;
    memcpy(value, (char *) response.data + 2, response.len - 2);
    freeRPCBuffer(&response);
    return true;
}

// Handles read RPCs
bool readEndpointHandler(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen != 4)
        return false;

    int id;
    int intType;
    memcpy(&id, inData, 2);
    memcpy(&intType, (char *) inData + 2, 2);

    struct ReadWriteEndpoint *endpoint = findEndpoint(id);
    char status = 0; // 0 indicates success
    if(endpoint == NULL)
        status = 1;

    // Check if the type is wrong
    if(intType != ENDPOINT_UNKNOWN && intType != endpoint->params->type)
        status = 1;

    // Check it's readable
    if(status == 0 && endpoint->read == NULL)
        status = 1;

    union endpointVal value;
    if(status == 0 && !endpoint->read(id, &value))
        status = 1;

    if(status != 0) { // Reply with error
        intType = ENDPOINT_UNKNOWN;
        memcpy(outData, &intType, 2);
        *outLen = 2;
        return true;
    }

    int dataBytes = numBytesForType(endpoint->params->type);

    // Reply with data
    memcpy(outData, &endpoint->params->type, 2);
    memcpy((char *) outData + 2, &value, dataBytes);
    *outLen = dataBytes + 2;
    return true;
}

// Type is always checked (on the remote end)
bool writeToEndpoint(int address, int id, enum endpointType type, union endpointVal *value) {
    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    int intType = type;
    int dataBytes = numBytesForType(type);

    request.len = dataBytes + 4;
    memcpy(request.data, &id, 2);
    memcpy((char *) request.data + 2, &intType, 2);
    memcpy((char *) request.data + 4, value, dataBytes);

    if(!doRPCCall(&request, &response, address, RPC_WRITE_ENDPOINT, 4, 5000))
        return false;

    // Check that we got one byte of status back
    if(response.len != 1) {
        freeRPCBuffer(&response);
        return false;
    }

    char code;
    memcpy(&code, response.data, 1);
    freeRPCBuffer(&response);
    return code == 0;
}

// Handles write RPCs
bool writeEndpointHandler(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen < 4)
        return false;

    int id;
    int intType;
    memcpy(&id, inData, 2);
    memcpy(&intType, (char *) inData + 2, 2);

    struct ReadWriteEndpoint *endpoint = findEndpoint(id);
    char status = 0; // 0 indicates success
    if(endpoint == NULL)
        status = 1;

    // Check if the type is wrong
    if(intType != endpoint->params->type)
        status = 1;

    // Check it's writeable
    if(status == 0 && endpoint->write == NULL)
        status = 1;

    int dataBytes;
    if(status == 0) {
        dataBytes = numBytesForType(endpoint->params->type);
        if(inLen != dataBytes + 4)
            status = 1;
    }

    union endpointVal value;
    if(status == 0) {
        memcpy(&value, (char *) inData + 4, dataBytes);
        if(!endpoint->write(id, &value))
            status = 1;

    }

    if(status == 0) {
        // Data was updated, so call the function!
        dataUpdated(id);
    }

    // Reply with status
    memcpy(outData, &status, 1);
    *outLen = 1;
    return true;
}

// Doesn't care about type
bool resetEndpoint(int address, int id) {
    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    request.len = 2;
    memcpy(request.data, &id, 2);

    if(!doRPCCall(&request, &response, address, RPC_RESET_ENDPOINT, 4, 5000))
        return false;

    // Check that we got one byte of status back
    if(response.len != 1) {
        freeRPCBuffer(&response);
        return false;
    }

    char code;
    memcpy(&code, response.data, 1);
    freeRPCBuffer(&response);
    return code == 0;
}

// Handles reset RPCs
bool resetEndpointHandler(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen != 2)
        return false;

    int id;
    memcpy(&id, inData, 2);

    struct ReadWriteEndpoint *endpoint = findEndpoint(id);
    char status = 0; // 0 indicates success
    if(endpoint == NULL)
        status = 1;

    // Check it's resettable
    if(status == 0 && endpoint->reset == NULL)
        status = 1;

    if(status == 0) {
        if(!endpoint->reset(id))
            status = 1;

    }

    // Reply with status
    memcpy(outData, &status, 1);
    *outLen = 1;
    return true;
}

static int getParamsDataLen(enum endpointType type) {
    switch(type) {
        case ENDPOINT_INT16:
        case ENDPOINT_INT32:
            return sizeof(struct intParams) + offsetof(struct endpointParams, typeParams);
        case ENDPOINT_ENUM:
            return sizeof(struct enumParams) + offsetof(struct endpointParams, typeParams);
        default:
            return -1;
    }
}

bool getEndpointParams(int address, int id, struct endpointParams *params, char *enumBuffer, int enumBufferLen) {
    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    request.len = 4; // Send id and enum buffer len
    memcpy(request.data, &id, 2);
    memcpy((char *) request.data + 2, &enumBufferLen, 2);

    if(!doRPCCall(&request, &response, address, RPC_GET_ENDPOINT_PARAMS, 4, 5000))
        return false;

    // Not even a status byte
    if(response.len < 1) {
        freeRPCBuffer(&response);
        return false;
    }

    // Check the status
    char status;
    memcpy(&status, response.data, 1);
    if(status != 0) {
        freeRPCBuffer(&response);
        return false;
    }

    // Get the data type
    if(response.len < 3) {
        freeRPCBuffer(&response);
        return false;
    }
    enum endpointType type;
    memcpy(&type, (char *) response.data + 1, 2);
    int correctLen = getParamsDataLen(type);

    // Check that there is enough data
    if(correctLen < 0 || response.len < correctLen + 1) {
        freeRPCBuffer(&response);
        return false;
    }

    // Get the data
    memcpy(params, (char *) response.data + 1, correctLen);
    if(type != ENDPOINT_ENUM || enumBufferLen == 0) {
        freeRPCBuffer(&response);
        return true;
    }

    // If here, we need to handle the enum stuff
    int enumLen = response.len - 1 - correctLen;

    memcpy(enumBuffer, (char *) response.data + correctLen + 1, enumLen);
    freeRPCBuffer(&response);

    // Check for proper termination
    if(enumBuffer[enumLen - 1] != 0)
        return false;

    // Location to store pointers
    if(enumLen & 1) // Use even locations to store integers
        enumLen++;
    int *outPointer = (int *) (enumBuffer + enumLen);
    params->typeParams.enumParams.valStringOffsetsOffset = enumLen;

    int curr = 0;
    int maxVal = params->typeParams.enumParams.maxVal;
    int i;
    for(i = 0; i < maxVal; i++) {
        if((outPointer + 1) > (int *) (enumBuffer + enumBufferLen))
            return false; // Ran out of buffer space
        if(curr >= enumLen)
            return false; // Ran out of data
        *outPointer = curr;
        curr += strlen(enumBuffer + curr) + 1;
    }
    return true;
}

// Handles requests for parameters
bool getEndpointParamsHandler(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen != 4)
        return false;

    int id;
    int bufferLen;
    memcpy(&id, inData, 2);
    memcpy(&bufferLen, (char *) inData + 2, 2);

    struct ReadWriteEndpoint *endpoint = findEndpoint(id);
    char status = 0; // 0 indicates success
    if(endpoint == NULL)
        status = 1;

//    // Check for consistent options
//    if(bufferLen != 0 && endpoint->params->type != ENDPOINT_ENUM)
//        status = 1; TODO: fix this!

    if(status == 0) {
        int correctLen = getParamsDataLen(endpoint->params->type);
        memcpy((char *) outData + 1, endpoint->params, correctLen);

        // Set flags
        int flags = 0;
        if(endpoint->read)
            flags |= ENDPOINT_FLAG_READABLE;
        if(endpoint->write)
            flags |= ENDPOINT_FLAG_WRITEABLE;
        if(endpoint->reset)
            flags |= ENDPOINT_FLAG_RESETTABLE;
        memcpy(&(((struct endpointParams *) ((char *) outData + 1))->flags), &flags, sizeof(flags));

        if(bufferLen != 0) {
            char *curr = outData + correctLen;
            int maxVal = endpoint->params->typeParams.enumParams.maxVal;
            int i;
            for(i = 0; i < maxVal; i++) {
                char *str = endpoint->params->typeParams.enumParams.valStrings[i];
                int len = strlen(str);
                if(curr + len + 1 > (char *) outData + bufferLen) {
                    status = 1;
                    break;
                }
                strcpy(curr, str);
                curr += len + 1;
            }
            *outLen = curr - (char *) outData;
        }
    }

    memcpy(outData, &status, 1);
    if(status != 0) { // Reply with error
        *outLen = 1;
    }

    return true;
}

// Reads starting at begin, up to end (subject to menu size)
bool readMenu(int address, int id, int begin, int end, struct menuValue *menu) {
    if(end - begin > MAX_MENU_ENTRIES_PER_CALL)
        return false; // Or should it truncate?

    struct rpcDataBuffer request, response;
    if(!allocRPCBuffer(&request))
        return false;

    request.len = 6; // Int is 2 bytes
    memcpy(request.data, &id, 2);
    memcpy((char *) request.data + 2, &begin, 2);
    memcpy((char *) request.data + 4, &end, 2);
    if(!doRPCCall(&request, &response, address, RPC_READ_MENU, 4, 5000))
        return false;

    // Check that there is enough length for the header, but not too much
    if(response.len < 6 || response.len > sizeof (*menu)) {
        freeRPCBuffer(&response);
        return false;
    }

    // Populate the data
    memcpy(menu, response.data, response.len);
    freeRPCBuffer(&response);
    return true;
}

void startEndpoints(void) {
    clientCallbacksLock = xSemaphoreCreateMutex();
    serverCallbacksLock = xSemaphoreCreateMutex();
    masterContactTimer = xTimerCreate((signed char *) "contact", (unsigned) (MAX_NO_CONTACT_TIME * 1000UL / portTICK_RATE_MS), false, NULL, noContactExpired);

    registerRPCHandler(readEndpointHandler, true, RPC_READ_ENDPOINT);
    registerRPCHandler(writeEndpointHandler, true, RPC_WRITE_ENDPOINT);
    registerRPCHandler(resetEndpointHandler, true, RPC_RESET_ENDPOINT);
    registerRPCHandler(getEndpointParamsHandler, true, RPC_GET_ENDPOINT_PARAMS);

    registerRPCHandler(handleMasterAnnounce, false, RPC_MASTER_ANNOUNCE);
    registerRPCHandler(handleSyncWithMaster, true, RPC_ENDPOINT_SYNC);
    registerRPCHandler(handleServerError, true, RPC_ENDPOINT_SERVER_ERROR);
    registerRPCHandler(handleDataUpdated, true, RPC_NOTIFY_ENDPOINT);
}
