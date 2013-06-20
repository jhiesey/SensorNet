#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
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
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ${OBJECTDIR}/_ext/1557056461/tankSensor.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/busSlave.o ${OBJECTDIR}/_ext/1208648223/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/381897321/croutine.o.d ${OBJECTDIR}/_ext/381897321/list.o.d ${OBJECTDIR}/_ext/381897321/queue.o.d ${OBJECTDIR}/_ext/381897321/tasks.o.d ${OBJECTDIR}/_ext/381897321/timers.o.d ${OBJECTDIR}/_ext/1841791051/port.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/167578668/heap_2.o.d ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d ${OBJECTDIR}/_ext/1557056461/tankSensor.o.d ${OBJECTDIR}/_ext/812168374/buffer.o.d ${OBJECTDIR}/_ext/812168374/busIO.o.d ${OBJECTDIR}/_ext/812168374/network.o.d ${OBJECTDIR}/_ext/812168374/rpc.o.d ${OBJECTDIR}/_ext/812168374/busSlave.o.d ${OBJECTDIR}/_ext/1208648223/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1557056461/lightOutput.o ${OBJECTDIR}/_ext/1557056461/lightSensor.o ${OBJECTDIR}/_ext/1557056461/tankSensor.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/busSlave.o ${OBJECTDIR}/_ext/1208648223/main.o


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
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/croutine.c  -o ${OBJECTDIR}/_ext/381897321/croutine.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/list.c  -o ${OBJECTDIR}/_ext/381897321/list.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/queue.c  -o ${OBJECTDIR}/_ext/381897321/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/tasks.c  -o ${OBJECTDIR}/_ext/381897321/tasks.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/timers.c  -o ${OBJECTDIR}/_ext/381897321/timers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  -o ${OBJECTDIR}/_ext/1841791051/port.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MemMang/heap_2.c  -o ${OBJECTDIR}/_ext/167578668/heap_2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/lightOutput.o: ../source/sensorDefs/lightOutput.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/lightOutput.c  -o ${OBJECTDIR}/_ext/1557056461/lightOutput.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/lightSensor.o: ../source/sensorDefs/lightSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/lightSensor.c  -o ${OBJECTDIR}/_ext/1557056461/lightSensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/tankSensor.o: ../source/sensorDefs/tankSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/tankSensor.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/tankSensor.c  -o ${OBJECTDIR}/_ext/1557056461/tankSensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/tankSensor.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/tankSensor.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/buffer.c  -o ${OBJECTDIR}/_ext/812168374/buffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busIO.c  -o ${OBJECTDIR}/_ext/812168374/busIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/network.c  -o ${OBJECTDIR}/_ext/812168374/network.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/rpc.c  -o ${OBJECTDIR}/_ext/812168374/rpc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busSlave.o: ../source/busSlave.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busSlave.c  -o ${OBJECTDIR}/_ext/812168374/busSlave.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busSlave.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busSlave.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1208648223/main.o: ../source/sensor/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1208648223 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensor/main.c  -o ${OBJECTDIR}/_ext/1208648223/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1208648223/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1208648223/main.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
else
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/croutine.c  -o ${OBJECTDIR}/_ext/381897321/croutine.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/list.c  -o ${OBJECTDIR}/_ext/381897321/list.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/queue.c  -o ${OBJECTDIR}/_ext/381897321/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/tasks.c  -o ${OBJECTDIR}/_ext/381897321/tasks.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/timers.c  -o ${OBJECTDIR}/_ext/381897321/timers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  -o ${OBJECTDIR}/_ext/1841791051/port.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MemMang/heap_2.c  -o ${OBJECTDIR}/_ext/167578668/heap_2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/lightOutput.o: ../source/sensorDefs/lightOutput.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightOutput.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/lightOutput.c  -o ${OBJECTDIR}/_ext/1557056461/lightOutput.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightOutput.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/lightSensor.o: ../source/sensorDefs/lightSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/lightSensor.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/lightSensor.c  -o ${OBJECTDIR}/_ext/1557056461/lightSensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/lightSensor.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1557056461/tankSensor.o: ../source/sensorDefs/tankSensor.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1557056461 
	@${RM} ${OBJECTDIR}/_ext/1557056461/tankSensor.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensorDefs/tankSensor.c  -o ${OBJECTDIR}/_ext/1557056461/tankSensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1557056461/tankSensor.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1557056461/tankSensor.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/buffer.c  -o ${OBJECTDIR}/_ext/812168374/buffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busIO.c  -o ${OBJECTDIR}/_ext/812168374/busIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/network.c  -o ${OBJECTDIR}/_ext/812168374/network.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/rpc.c  -o ${OBJECTDIR}/_ext/812168374/rpc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busSlave.o: ../source/busSlave.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busSlave.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busSlave.c  -o ${OBJECTDIR}/_ext/812168374/busSlave.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busSlave.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busSlave.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1208648223/main.o: ../source/sensor/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1208648223 
	@${RM} ${OBJECTDIR}/_ext/1208648223/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/sensor/main.c  -o ${OBJECTDIR}/_ext/1208648223/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1208648223/main.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/sensor/include" -I"../source/sensorDefs" -DMPLAB_PIC24_PORT -msmart-io=1 -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1208648223/main.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -Wa,-MD,"${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d"  -t $(SILENT)  -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -omf=elf -Wa,-MD,"${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d"  -t $(SILENT)  -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    ../p24FJ64GB002.gld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -Wl,--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,$(MP_LINKER_FILE_OPTION),--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,--report-mem$(MP_EXTRA_LD_POST) 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   ../p24FJ64GB002.gld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -Wl,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,--report-mem$(MP_EXTRA_LD_POST) 
	${MP_CC_DIR}/xc16-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/WellSensor.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf 
	
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
