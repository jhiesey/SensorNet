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
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../FreeRTOS/Source/croutine.c ../FreeRTOS/Source/list.c ../FreeRTOS/Source/queue.c ../FreeRTOS/Source/tasks.c ../FreeRTOS/Source/timers.c ../FreeRTOS/Source/portable/MemMang/heap_2.c ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S ../source/controls.c ../source/lcd.c ../source/buffer.c ../source/busIO.c ../source/network.c ../source/wirelessProtocol.c ../source/rpc.c ../source/serialIO.c ../source/hub/main.c ../source/busMaster.c ../source/endpoint.c ../source/hub/endpointDefs.c ../source/hub/menus.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/812168374/controls.o ${OBJECTDIR}/_ext/812168374/lcd.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/serialIO.o ${OBJECTDIR}/_ext/1361283248/main.o ${OBJECTDIR}/_ext/812168374/busMaster.o ${OBJECTDIR}/_ext/812168374/endpoint.o ${OBJECTDIR}/_ext/1361283248/endpointDefs.o ${OBJECTDIR}/_ext/1361283248/menus.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/381897321/croutine.o.d ${OBJECTDIR}/_ext/381897321/list.o.d ${OBJECTDIR}/_ext/381897321/queue.o.d ${OBJECTDIR}/_ext/381897321/tasks.o.d ${OBJECTDIR}/_ext/381897321/timers.o.d ${OBJECTDIR}/_ext/167578668/heap_2.o.d ${OBJECTDIR}/_ext/1841791051/port.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/812168374/controls.o.d ${OBJECTDIR}/_ext/812168374/lcd.o.d ${OBJECTDIR}/_ext/812168374/buffer.o.d ${OBJECTDIR}/_ext/812168374/busIO.o.d ${OBJECTDIR}/_ext/812168374/network.o.d ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d ${OBJECTDIR}/_ext/812168374/rpc.o.d ${OBJECTDIR}/_ext/812168374/serialIO.o.d ${OBJECTDIR}/_ext/1361283248/main.o.d ${OBJECTDIR}/_ext/812168374/busMaster.o.d ${OBJECTDIR}/_ext/812168374/endpoint.o.d ${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d ${OBJECTDIR}/_ext/1361283248/menus.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/812168374/controls.o ${OBJECTDIR}/_ext/812168374/lcd.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/network.o ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o ${OBJECTDIR}/_ext/812168374/rpc.o ${OBJECTDIR}/_ext/812168374/serialIO.o ${OBJECTDIR}/_ext/1361283248/main.o ${OBJECTDIR}/_ext/812168374/busMaster.o ${OBJECTDIR}/_ext/812168374/endpoint.o ${OBJECTDIR}/_ext/1361283248/endpointDefs.o ${OBJECTDIR}/_ext/1361283248/menus.o

# Source Files
SOURCEFILES=../FreeRTOS/Source/croutine.c ../FreeRTOS/Source/list.c ../FreeRTOS/Source/queue.c ../FreeRTOS/Source/tasks.c ../FreeRTOS/Source/timers.c ../FreeRTOS/Source/portable/MemMang/heap_2.c ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S ../source/controls.c ../source/lcd.c ../source/buffer.c ../source/busIO.c ../source/network.c ../source/wirelessProtocol.c ../source/rpc.c ../source/serialIO.c ../source/hub/main.c ../source/busMaster.c ../source/endpoint.c ../source/hub/endpointDefs.c ../source/hub/menus.c


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

# The following macros may be used in the pre and post step lines
Device=PIC24FJ256GB206
ProjectDir=/Users/jhiesey/Desktop/SensorNet/embedded/WellMain.X
ConfName=default
ImagePath=dist/default/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
ImageDir=dist/default/${IMAGE_TYPE}
ImageName=WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

.build-conf:  .pre ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: []"
	@
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=24FJ256GB206
MP_LINKER_FILE_OPTION=,--script="../p24FJ256GB206.gld"
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/croutine.c  -o ${OBJECTDIR}/_ext/381897321/croutine.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/list.c  -o ${OBJECTDIR}/_ext/381897321/list.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/queue.c  -o ${OBJECTDIR}/_ext/381897321/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/tasks.c  -o ${OBJECTDIR}/_ext/381897321/tasks.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/timers.c  -o ${OBJECTDIR}/_ext/381897321/timers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MemMang/heap_2.c  -o ${OBJECTDIR}/_ext/167578668/heap_2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  -o ${OBJECTDIR}/_ext/1841791051/port.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/controls.o: ../source/controls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/controls.c  -o ${OBJECTDIR}/_ext/812168374/controls.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/controls.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/controls.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/lcd.o: ../source/lcd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/lcd.c  -o ${OBJECTDIR}/_ext/812168374/lcd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/lcd.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/lcd.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/buffer.c  -o ${OBJECTDIR}/_ext/812168374/buffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busIO.c  -o ${OBJECTDIR}/_ext/812168374/busIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/network.c  -o ${OBJECTDIR}/_ext/812168374/network.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/wirelessProtocol.o: ../source/wirelessProtocol.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/wirelessProtocol.c  -o ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/rpc.c  -o ${OBJECTDIR}/_ext/812168374/rpc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/serialIO.o: ../source/serialIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/serialIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/serialIO.c  -o ${OBJECTDIR}/_ext/812168374/serialIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/serialIO.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/serialIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/main.o: ../source/hub/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/main.c  -o ${OBJECTDIR}/_ext/1361283248/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/main.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busMaster.o: ../source/busMaster.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busMaster.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busMaster.c  -o ${OBJECTDIR}/_ext/812168374/busMaster.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busMaster.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busMaster.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/endpoint.o: ../source/endpoint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/endpoint.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/endpoint.c  -o ${OBJECTDIR}/_ext/812168374/endpoint.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/endpoint.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/endpoint.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/endpointDefs.o: ../source/hub/endpointDefs.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/endpointDefs.c  -o ${OBJECTDIR}/_ext/1361283248/endpointDefs.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/menus.o: ../source/hub/menus.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/menus.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/menus.c  -o ${OBJECTDIR}/_ext/1361283248/menus.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/menus.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/menus.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
else
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/croutine.c  -o ${OBJECTDIR}/_ext/381897321/croutine.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/list.c  -o ${OBJECTDIR}/_ext/381897321/list.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/queue.c  -o ${OBJECTDIR}/_ext/381897321/queue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/tasks.c  -o ${OBJECTDIR}/_ext/381897321/tasks.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/timers.c  -o ${OBJECTDIR}/_ext/381897321/timers.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MemMang/heap_2.c  -o ${OBJECTDIR}/_ext/167578668/heap_2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  -o ${OBJECTDIR}/_ext/1841791051/port.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/controls.o: ../source/controls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/controls.c  -o ${OBJECTDIR}/_ext/812168374/controls.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/controls.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/controls.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/lcd.o: ../source/lcd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/lcd.c  -o ${OBJECTDIR}/_ext/812168374/lcd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/lcd.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/lcd.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/buffer.c  -o ${OBJECTDIR}/_ext/812168374/buffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busIO.c  -o ${OBJECTDIR}/_ext/812168374/busIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/network.c  -o ${OBJECTDIR}/_ext/812168374/network.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/wirelessProtocol.o: ../source/wirelessProtocol.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/wirelessProtocol.c  -o ${OBJECTDIR}/_ext/812168374/wirelessProtocol.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/wirelessProtocol.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/rpc.o: ../source/rpc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/rpc.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/rpc.c  -o ${OBJECTDIR}/_ext/812168374/rpc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/rpc.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/rpc.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/serialIO.o: ../source/serialIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/serialIO.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/serialIO.c  -o ${OBJECTDIR}/_ext/812168374/serialIO.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/serialIO.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/serialIO.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/main.o: ../source/hub/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/main.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/main.c  -o ${OBJECTDIR}/_ext/1361283248/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/main.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/main.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/busMaster.o: ../source/busMaster.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busMaster.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/busMaster.c  -o ${OBJECTDIR}/_ext/812168374/busMaster.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/busMaster.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busMaster.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/812168374/endpoint.o: ../source/endpoint.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/endpoint.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/endpoint.c  -o ${OBJECTDIR}/_ext/812168374/endpoint.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/812168374/endpoint.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/endpoint.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/endpointDefs.o: ../source/hub/endpointDefs.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/endpointDefs.c  -o ${OBJECTDIR}/_ext/1361283248/endpointDefs.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/endpointDefs.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
${OBJECTDIR}/_ext/1361283248/menus.o: ../source/hub/menus.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1361283248 
	@${RM} ${OBJECTDIR}/_ext/1361283248/menus.o.d 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../source/hub/menus.c  -o ${OBJECTDIR}/_ext/1361283248/menus.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1361283248/menus.o.d"      -g -omf=elf -mlarge-data -O0 -I"../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I"../source/hub/include" -DMPLAB_PIC24_PORT -msmart-io=1 -Wall -msfr-warn=off
	@${FIXDEPS} "${OBJECTDIR}/_ext/1361283248/menus.o.d" $(SILENT)  -rsi ${MP_CC_DIR}../ 
	
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
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I".." -Wa,-MD,"${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g,--no-relax,-g $(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d"  -t $(SILENT)  -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -omf=elf -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -I".." -Wa,-MD,"${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax,-g $(MP_EXTRA_AS_POST)
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d"  -t $(SILENT)  -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    ../p24FJ256GB206.gld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1  -omf=elf -Wl,--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,$(MP_LINKER_FILE_OPTION),--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--defsym,__ICD2RAM=1,--library-path="..",--no-force-link,--smart-io,-Map="${DISTDIR}/WellMain.X.${IMAGE_TYPE}.map",--report-mem$(MP_EXTRA_LD_POST) 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   ../p24FJ256GB206.gld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -Wl,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--defsym,__ICD2RAM=1,--library-path="..",--no-force-link,--smart-io,-Map="${DISTDIR}/WellMain.X.${IMAGE_TYPE}.map",--report-mem$(MP_EXTRA_LD_POST) 
	${MP_CC_DIR}/xc16-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf 
	
endif

.pre:
	@echo "--------------------------------------"
	@echo "User defined pre-build step: []"
	@
	@echo "--------------------------------------"

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
