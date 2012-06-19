#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/busSlave.o ${OBJECTDIR}/_ext/1208648223/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/381897321/croutine.o.d ${OBJECTDIR}/_ext/381897321/list.o.d ${OBJECTDIR}/_ext/381897321/queue.o.d ${OBJECTDIR}/_ext/381897321/tasks.o.d ${OBJECTDIR}/_ext/381897321/timers.o.d ${OBJECTDIR}/_ext/1841791051/port.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/167578668/heap_2.o.d ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d ${OBJECTDIR}/_ext/812168374/buffer.o.d ${OBJECTDIR}/_ext/812168374/busIO.o.d ${OBJECTDIR}/_ext/812168374/network.o.d ${OBJECTDIR}/_ext/812168374/rpc.o.d ${OBJECTDIR}/_ext/812168374/busSlave.o.d ${OBJECTDIR}/_ext/1208648223/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/busSlave.o ${OBJECTDIR}/_ext/1208648223/main.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=24FJ64GB002
MP_LINKER_FILE_OPTION=,--script="../p24FJ64GB002.gld"
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.ok ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d" -t $(SILENT) -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -c -mcpu=$(MP_PROCESSOR_OPTION)   -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g
	
else
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.ok ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d" -t $(SILENT) -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -omf=elf -c -mcpu=$(MP_PROCESSOR_OPTION)   -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",-g
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.ok ${OBJECTDIR}/_ext/381897321/croutine.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d" -o ${OBJECTDIR}/_ext/381897321/croutine.o ../FreeRTOS/Source/croutine.c  
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.ok ${OBJECTDIR}/_ext/381897321/list.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d" -o ${OBJECTDIR}/_ext/381897321/list.o ../FreeRTOS/Source/list.c  
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.ok ${OBJECTDIR}/_ext/381897321/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d" -o ${OBJECTDIR}/_ext/381897321/queue.o ../FreeRTOS/Source/queue.c  
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.ok ${OBJECTDIR}/_ext/381897321/tasks.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d" -o ${OBJECTDIR}/_ext/381897321/tasks.o ../FreeRTOS/Source/tasks.c  
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.ok ${OBJECTDIR}/_ext/381897321/timers.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d" -o ${OBJECTDIR}/_ext/381897321/timers.o ../FreeRTOS/Source/timers.c  
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.ok ${OBJECTDIR}/_ext/1841791051/port.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d" -o ${OBJECTDIR}/_ext/1841791051/port.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.ok ${OBJECTDIR}/_ext/167578668/heap_2.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d" -o ${OBJECTDIR}/_ext/167578668/heap_2.o ../FreeRTOS/Source/portable/MemMang/heap_2.c  
	
${OBJECTDIR}/_ext/1557056461/lightOutput.o: ../source/sensorDefs/lightOutput.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.ok ${OBJECTDIR}/_ext/1557056461/lightOutput.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" -o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ../source/sensorDefs/lightOutput.c  
	
${OBJECTDIR}/_ext/1557056461/lightSensor.o: ../source/sensorDefs/lightSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.ok ${OBJECTDIR}/_ext/1557056461/lightSensor.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" -o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ../source/sensorDefs/lightSensor.c  
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.ok ${OBJECTDIR}/_ext/812168374/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d" -o ${OBJECTDIR}/_ext/812168374/buffer.o ../source/buffer.c  
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.ok ${OBJECTDIR}/_ext/812168374/busIO.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d" -o ${OBJECTDIR}/_ext/812168374/busIO.o ../source/busIO.c  
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.ok ${OBJECTDIR}/_ext/812168374/network.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d" -o ${OBJECTDIR}/_ext/812168374/network.o ../source/network.c  
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.ok ${OBJECTDIR}/_ext/812168374/rpc.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d" -o ${OBJECTDIR}/_ext/812168374/rpc.o ../source/rpc.c  
	
${OBJECTDIR}/_ext/812168374/busSlave.o: ../source/busSlave.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.ok ${OBJECTDIR}/_ext/812168374/busSlave.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busSlave.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busSlave.o.d" -o ${OBJECTDIR}/_ext/812168374/busSlave.o ../source/busSlave.c  
	
${OBJECTDIR}/_ext/1208648223/main.o: ../source/sensor/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1208648223 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.ok ${OBJECTDIR}/_ext/1208648223/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1208648223/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1208648223/main.o.d" -o ${OBJECTDIR}/_ext/1208648223/main.o ../source/sensor/main.c  
	
else
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.ok ${OBJECTDIR}/_ext/381897321/croutine.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d" -o ${OBJECTDIR}/_ext/381897321/croutine.o ../FreeRTOS/Source/croutine.c  
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.ok ${OBJECTDIR}/_ext/381897321/list.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d" -o ${OBJECTDIR}/_ext/381897321/list.o ../FreeRTOS/Source/list.c  
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.ok ${OBJECTDIR}/_ext/381897321/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d" -o ${OBJECTDIR}/_ext/381897321/queue.o ../FreeRTOS/Source/queue.c  
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.ok ${OBJECTDIR}/_ext/381897321/tasks.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d" -o ${OBJECTDIR}/_ext/381897321/tasks.o ../FreeRTOS/Source/tasks.c  
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.ok ${OBJECTDIR}/_ext/381897321/timers.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d" -o ${OBJECTDIR}/_ext/381897321/timers.o ../FreeRTOS/Source/timers.c  
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.ok ${OBJECTDIR}/_ext/1841791051/port.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d" -o ${OBJECTDIR}/_ext/1841791051/port.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.ok ${OBJECTDIR}/_ext/167578668/heap_2.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d" -o ${OBJECTDIR}/_ext/167578668/heap_2.o ../FreeRTOS/Source/portable/MemMang/heap_2.c  
	
${OBJECTDIR}/_ext/1557056461/lightOutput.o: ../source/sensorDefs/lightOutput.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.ok ${OBJECTDIR}/_ext/1557056461/lightOutput.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" -o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ../source/sensorDefs/lightOutput.c  
	
${OBJECTDIR}/_ext/1557056461/lightSensor.o: ../source/sensorDefs/lightSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.ok ${OBJECTDIR}/_ext/1557056461/lightSensor.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" -o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ../source/sensorDefs/lightSensor.c  
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.ok ${OBJECTDIR}/_ext/812168374/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d" -o ${OBJECTDIR}/_ext/812168374/buffer.o ../source/buffer.c  
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.ok ${OBJECTDIR}/_ext/812168374/busIO.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d" -o ${OBJECTDIR}/_ext/812168374/busIO.o ../source/busIO.c  
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.ok ${OBJECTDIR}/_ext/812168374/network.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d" -o ${OBJECTDIR}/_ext/812168374/network.o ../source/network.c  
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.ok ${OBJECTDIR}/_ext/812168374/rpc.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d" -o ${OBJECTDIR}/_ext/812168374/rpc.o ../source/rpc.c  
	
${OBJECTDIR}/_ext/812168374/busSlave.o: ../source/busSlave.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.ok ${OBJECTDIR}/_ext/812168374/busSlave.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busSlave.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busSlave.o.d" -o ${OBJECTDIR}/_ext/812168374/busSlave.o ../source/busSlave.c  
	
${OBJECTDIR}/_ext/1208648223/main.o: ../source/sensor/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1208648223 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.ok ${OBJECTDIR}/_ext/1208648223/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1208648223/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -DMPLAB_PIC24_PORT -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1208648223/main.o.d" -o ${OBJECTDIR}/_ext/1208648223/main.o ../source/sensor/main.c  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -o dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1
else
dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION)
	${MP_CC_DIR}/pic30-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -omf=elf
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
