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

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/812168374/main.o ${OBJECTDIR}/_ext/812168374/controls.o ${OBJECTDIR}/_ext/812168374/lcd.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/busProtocol.o ${OBJECTDIR}/_ext/812168374/network.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/381897321/croutine.o.d ${OBJECTDIR}/_ext/381897321/list.o.d ${OBJECTDIR}/_ext/381897321/queue.o.d ${OBJECTDIR}/_ext/381897321/tasks.o.d ${OBJECTDIR}/_ext/381897321/timers.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/167578668/heap_2.o.d ${OBJECTDIR}/_ext/1841791051/port.o.d ${OBJECTDIR}/_ext/812168374/main.o.d ${OBJECTDIR}/_ext/812168374/controls.o.d ${OBJECTDIR}/_ext/812168374/lcd.o.d ${OBJECTDIR}/_ext/812168374/buffer.o.d ${OBJECTDIR}/_ext/812168374/busIO.o.d ${OBJECTDIR}/_ext/812168374/busProtocol.o.d ${OBJECTDIR}/_ext/812168374/network.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/381897321/croutine.o ${OBJECTDIR}/_ext/381897321/list.o ${OBJECTDIR}/_ext/381897321/queue.o ${OBJECTDIR}/_ext/381897321/tasks.o ${OBJECTDIR}/_ext/381897321/timers.o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ${OBJECTDIR}/_ext/167578668/heap_2.o ${OBJECTDIR}/_ext/1841791051/port.o ${OBJECTDIR}/_ext/812168374/main.o ${OBJECTDIR}/_ext/812168374/controls.o ${OBJECTDIR}/_ext/812168374/lcd.o ${OBJECTDIR}/_ext/812168374/buffer.o ${OBJECTDIR}/_ext/812168374/busIO.o ${OBJECTDIR}/_ext/812168374/busProtocol.o ${OBJECTDIR}/_ext/812168374/network.o


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
ProjectDir=/Users/jhiesey/Desktop/SensorNet/WellMain/WellMain.X
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
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d" -t $(SILENT) -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -c -mcpu=$(MP_PROCESSOR_OPTION)  -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-g,-I"..",-g 
	
else
${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.ok ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d" "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d" -t $(SILENT) -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -omf=elf -c -mcpu=$(MP_PROCESSOR_OPTION)  -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -MMD -MF "${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.d"  -o ${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/portasm_PIC24.S  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/_ext/1841791051/portasm_PIC24.o.asm.d",-g,-I"..",-g 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.ok ${OBJECTDIR}/_ext/381897321/croutine.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d" -o ${OBJECTDIR}/_ext/381897321/croutine.o ../FreeRTOS/Source/croutine.c  
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.ok ${OBJECTDIR}/_ext/381897321/list.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d" -o ${OBJECTDIR}/_ext/381897321/list.o ../FreeRTOS/Source/list.c  
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.ok ${OBJECTDIR}/_ext/381897321/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d" -o ${OBJECTDIR}/_ext/381897321/queue.o ../FreeRTOS/Source/queue.c  
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.ok ${OBJECTDIR}/_ext/381897321/tasks.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d" -o ${OBJECTDIR}/_ext/381897321/tasks.o ../FreeRTOS/Source/tasks.c  
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.ok ${OBJECTDIR}/_ext/381897321/timers.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d" -o ${OBJECTDIR}/_ext/381897321/timers.o ../FreeRTOS/Source/timers.c  
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.ok ${OBJECTDIR}/_ext/167578668/heap_2.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d" -o ${OBJECTDIR}/_ext/167578668/heap_2.o ../FreeRTOS/Source/portable/MemMang/heap_2.c  
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.ok ${OBJECTDIR}/_ext/1841791051/port.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d" -o ${OBJECTDIR}/_ext/1841791051/port.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  
	
${OBJECTDIR}/_ext/812168374/main.o: ../source/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.ok ${OBJECTDIR}/_ext/812168374/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/main.o.d" -o ${OBJECTDIR}/_ext/812168374/main.o ../source/main.c  
	
${OBJECTDIR}/_ext/812168374/controls.o: ../source/controls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.ok ${OBJECTDIR}/_ext/812168374/controls.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/controls.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/controls.o.d" -o ${OBJECTDIR}/_ext/812168374/controls.o ../source/controls.c  
	
${OBJECTDIR}/_ext/812168374/lcd.o: ../source/lcd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.ok ${OBJECTDIR}/_ext/812168374/lcd.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/lcd.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/lcd.o.d" -o ${OBJECTDIR}/_ext/812168374/lcd.o ../source/lcd.c  
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.ok ${OBJECTDIR}/_ext/812168374/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d" -o ${OBJECTDIR}/_ext/812168374/buffer.o ../source/buffer.c  
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.ok ${OBJECTDIR}/_ext/812168374/busIO.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d" -o ${OBJECTDIR}/_ext/812168374/busIO.o ../source/busIO.c  
	
${OBJECTDIR}/_ext/812168374/busProtocol.o: ../source/busProtocol.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busProtocol.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busProtocol.o.ok ${OBJECTDIR}/_ext/812168374/busProtocol.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busProtocol.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busProtocol.o.d" -o ${OBJECTDIR}/_ext/812168374/busProtocol.o ../source/busProtocol.c  
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.ok ${OBJECTDIR}/_ext/812168374/network.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d" -o ${OBJECTDIR}/_ext/812168374/network.o ../source/network.c  
	
else
${OBJECTDIR}/_ext/381897321/croutine.o: ../FreeRTOS/Source/croutine.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/croutine.o.ok ${OBJECTDIR}/_ext/381897321/croutine.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/croutine.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/croutine.o.d" -o ${OBJECTDIR}/_ext/381897321/croutine.o ../FreeRTOS/Source/croutine.c  
	
${OBJECTDIR}/_ext/381897321/list.o: ../FreeRTOS/Source/list.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/list.o.ok ${OBJECTDIR}/_ext/381897321/list.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/list.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/list.o.d" -o ${OBJECTDIR}/_ext/381897321/list.o ../FreeRTOS/Source/list.c  
	
${OBJECTDIR}/_ext/381897321/queue.o: ../FreeRTOS/Source/queue.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/queue.o.ok ${OBJECTDIR}/_ext/381897321/queue.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/queue.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/queue.o.d" -o ${OBJECTDIR}/_ext/381897321/queue.o ../FreeRTOS/Source/queue.c  
	
${OBJECTDIR}/_ext/381897321/tasks.o: ../FreeRTOS/Source/tasks.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/tasks.o.ok ${OBJECTDIR}/_ext/381897321/tasks.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/tasks.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/tasks.o.d" -o ${OBJECTDIR}/_ext/381897321/tasks.o ../FreeRTOS/Source/tasks.c  
	
${OBJECTDIR}/_ext/381897321/timers.o: ../FreeRTOS/Source/timers.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/381897321 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/381897321/timers.o.ok ${OBJECTDIR}/_ext/381897321/timers.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/381897321/timers.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/381897321/timers.o.d" -o ${OBJECTDIR}/_ext/381897321/timers.o ../FreeRTOS/Source/timers.c  
	
${OBJECTDIR}/_ext/167578668/heap_2.o: ../FreeRTOS/Source/portable/MemMang/heap_2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/167578668 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/167578668/heap_2.o.ok ${OBJECTDIR}/_ext/167578668/heap_2.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/167578668/heap_2.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/167578668/heap_2.o.d" -o ${OBJECTDIR}/_ext/167578668/heap_2.o ../FreeRTOS/Source/portable/MemMang/heap_2.c  
	
${OBJECTDIR}/_ext/1841791051/port.o: ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1841791051 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1841791051/port.o.ok ${OBJECTDIR}/_ext/1841791051/port.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1841791051/port.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/1841791051/port.o.d" -o ${OBJECTDIR}/_ext/1841791051/port.o ../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC/port.c  
	
${OBJECTDIR}/_ext/812168374/main.o: ../source/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.ok ${OBJECTDIR}/_ext/812168374/main.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/main.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/main.o.d" -o ${OBJECTDIR}/_ext/812168374/main.o ../source/main.c  
	
${OBJECTDIR}/_ext/812168374/controls.o: ../source/controls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/controls.o.ok ${OBJECTDIR}/_ext/812168374/controls.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/controls.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/controls.o.d" -o ${OBJECTDIR}/_ext/812168374/controls.o ../source/controls.c  
	
${OBJECTDIR}/_ext/812168374/lcd.o: ../source/lcd.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/lcd.o.ok ${OBJECTDIR}/_ext/812168374/lcd.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/lcd.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/lcd.o.d" -o ${OBJECTDIR}/_ext/812168374/lcd.o ../source/lcd.c  
	
${OBJECTDIR}/_ext/812168374/buffer.o: ../source/buffer.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/buffer.o.ok ${OBJECTDIR}/_ext/812168374/buffer.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/buffer.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/buffer.o.d" -o ${OBJECTDIR}/_ext/812168374/buffer.o ../source/buffer.c  
	
${OBJECTDIR}/_ext/812168374/busIO.o: ../source/busIO.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busIO.o.ok ${OBJECTDIR}/_ext/812168374/busIO.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busIO.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busIO.o.d" -o ${OBJECTDIR}/_ext/812168374/busIO.o ../source/busIO.c  
	
${OBJECTDIR}/_ext/812168374/busProtocol.o: ../source/busProtocol.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/busProtocol.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/busProtocol.o.ok ${OBJECTDIR}/_ext/812168374/busProtocol.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/busProtocol.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/busProtocol.o.d" -o ${OBJECTDIR}/_ext/812168374/busProtocol.o ../source/busProtocol.c  
	
${OBJECTDIR}/_ext/812168374/network.o: ../source/network.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/network.o.ok ${OBJECTDIR}/_ext/812168374/network.o.err 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/network.o.d" $(SILENT) -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -omf=elf -x c -c -mcpu=$(MP_PROCESSOR_OPTION) -Wall -DMPLAB_PIC24_PORT -I"../include" -I"../../../source/include" -I"../../../../../source/include" -I"../../../../../../source/include" -I"../../../include" -I"../../FreeRTOS/Source/include" -I".." -I"../../MPLAB/PIC24_dsPIC" -I"../portable/MPLAB/PIC24_dsPIC" -I"../../FreeRTOS/Source/portable/MPLAB/PIC24_dsPIC" -I"../FreeRTOS/Source/include" -I"../source/include" -mlarge-data -MMD -MF "${OBJECTDIR}/_ext/812168374/network.o.d" -o ${OBJECTDIR}/_ext/812168374/network.o ../source/network.c  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -o dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,-L"..",-Map="${DISTDIR}/WellMain.X.${IMAGE_TYPE}.map",--report-mem,--defsym=__ICD2RAM=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__ICD2RAM=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1
else
dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -omf=elf -mcpu=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}        -Wl,--defsym=__MPLAB_BUILD=1,-L"..",-Map="${DISTDIR}/WellMain.X.${IMAGE_TYPE}.map",--report-mem,--defsym=__ICD2RAM=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION)
	${MP_CC_DIR}/pic30-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/WellMain.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -omf=elf
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
