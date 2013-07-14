/* 
 * File:   endpoint.h
 * Author: jhiesey
 *
 * Created on July 8, 2013, 3:43 AM
 */

#ifndef ENDPOINT_H
#define	ENDPOINT_H

#include <stdbool.h>

enum endpointType {
    ENDPOINT_UNKNOWN,
    ENDPOINT_INT16, // 16-bit signed
    ENDPOINT_INT32, // 32-bit signed
    ENDPOINT_ENUM, // 16-bit unsigned
    ENDPOINT_TIME,
    ENDPOINT_MENU // Used only in menus
};

#define MAX_MENU_ENTRIES_PER_CALL 4

struct menuValue {
    int numItems; // Total number of items in menu
    int begin;
    int end;
    struct menuEntry {
        char name[16];
        int address;
        int endpoint;
        enum endpointType type;
    } entries[MAX_MENU_ENTRIES_PER_CALL];
};

#define ENDPOINT_FLAG_READABLE 1
#define ENDPOINT_FLAG_WRITEABLE 2
#define ENDPOINT_FLAG_RESETTABLE 4

/* This struct is used to declare endpoints, and as a container
   to receive endpoint information. Not all fields are needed in
   both places. */
struct endpointParams {
    enum endpointType type;
    int flags; // Set automatically when params are read
    union typeParams {
        struct intParams {
            long minVal;
            long maxVal;
            int dpPos;
        } intParams;
        struct enumParams {
            int maxVal;
            char **valStrings;
            int valStringOffsetsOffset; // Set automatically when params are read
        } enumParams;
    } typeParams;
};

union endpointVal {
    int int16Val;
    long int32Val;
    int enumVal;
};

// Handler types
typedef bool (*endpointReadHandler)(int id, union endpointVal *value);
typedef bool (*endpointWriteHandler)(int id, union endpointVal *value);
typedef bool (*endpointResetHandler)(int id);

struct ReadWriteEndpoint {
    int id;
    struct endpointParams *params;
    endpointReadHandler read; // This function is called to read the value
    endpointWriteHandler write; // Called to write the value
    endpointResetHandler reset; // Called to reset the value
};

extern struct ReadWriteEndpoint endpoints[]; // Array of handler entries
extern int numEndpoints;

// Callback that is executed when the value changes. When value is NULL, it
// was evicted.
typedef void (*updateCallback)(int address, int id, enum endpointType type, union endpointVal *value);

// Operations on remote (or local) endpoints
// Set enumBufferLen > 0 to retrieve enum values
bool getEndpointParams(int address, int id, struct endpointParams *params, char *enumBuffer, int enumBufferLen);

// Functions for the client to request updates
bool addUpdateNotification(int address, int id, updateCallback callback, bool syncNow);
bool removeUpdateNotification(int address, int id, updateCallback callback, bool syncNow);

// Type is checked if not zero
bool readFromEndpoint(int address, int id, enum endpointType *type, union endpointVal *value);
// Type is always checked
bool writeToEndpoint(int address, int id, enum endpointType type, union endpointVal *value);
bool resetEndpoint(int address, int id);

bool readMenu(int address, int id, int begin, int end, struct menuValue *menu);

// Notifies the system that the data changed. Returns true if all updates successful
bool dataUpdated(int id);

// Initialize the endpoint system
void startEndpoints(void);

#endif	/* ENDPOINT_H */

