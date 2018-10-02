## =========================================================================================
## Setting environment variables
## =========================================================================================
DEPTH   := ../../..
-include ${DEPTH}/tree.make
-include ${DEPTH}/tools/make/common.make
-include $(TOT)/$(OUTDIR)/$(PROJECT)/spec/defs/project.mk

# Collect setting from tree.make and export as env variable
export VERDI_HOME        := ${VERDI_HOME}
export VCS_HOME			 := ${VCS_HOME}
export MTI_HOME			 := ${MTI_HOME}
export IUS_HOME			 := ${IUS_HOME}
export NOVAS_HOME		 := ${NOVAS_HOME}
ifeq ($(SIM_PLATFORM),vcs)
export PATH              := ${VERDI_HOME}/bin:${VCS_HOME}/bin:${PATH}
endif
ifeq ($(SIM_PLATFORM),mti)
export PATH              := ${VERDI_HOME}/bin:${MTI_HOME}/bin:${PATH}
endif
ifeq ($(SIM_PLATFORM),cds)
export PATH              := ${VERDI_HOME}/bin:${IUS_HOME}/bin:${PATH}
endif
export VCS_ARCH_OVERRIDE := linux

## =========================================================================================
## Setting command
## =========================================================================================

MKDIRP = /bin/mkdir -p
CP     = cp -f
RM     = rm -rf
MV     = mv -f 

# USE_DESIGNWARE shall be defined in tree.make
USE_DESIGNWARE ?= 1
# Three work modes: RTL_ONLY/CMOD_ONLY/CROSS_CHECK
WORK_MODE := CROSS_CHECK

# Set NVDLA_SAIF_ENABLE to 1 to compile SAIF testbench code
NVDLA_SAIF_ENABLE ?= 0

## =========================================================================================
## Setting testbench / rtl / reference model dir variables
## =========================================================================================

OUT_DIR := ${DEPTH}/${OUTDIR}/${PROJECT}/${REL_PATH_FROM_TOT}/
UVMCONNECT_HOME      := ${TOT}/third_party_tools/uvmc-2.3.0

VMOD_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/vmod
VMOD_LIB_DIR         := ${TOT}/${OUTDIR}/${PROJECT}/vmod/vlibs
VMOD_INC_DIR         := ${TOT}/${OUTDIR}/${PROJECT}/vmod/include
VMOD_SRC_DIRS        := ${VMOD_DIR}/nvdla
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cdma
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cbuf
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/csc
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cmac
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cacc
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/sdp
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/car
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/glb
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cfgrom
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/csb_master
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/nocif
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/top
ifdef NVDLA_PDP_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/pdp
endif
ifdef NVDLA_CDP_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cdp
endif
ifdef NVDLA_BDMA_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/bdma
endif
ifdef NVDLA_RUBIK_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/rubik
endif
ifdef NVDLA_RETIMING_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/retiming
endif
VMOD_SRC_DIRS_ALL    := ${VMOD_SRC_DIRS:%=+incdir+%}

VMOD_RAM_DIRS        := ${VMOD_DIR}/rams
VMOD_RAM_DIRS        += ${VMOD_DIR}/rams/model
VMOD_RAM_DIRS        += ${VMOD_DIR}/rams/synth
VMOD_RAM_DIRS_ALL    := ${VMOD_RAM_DIRS:%=+incdir+%}
VLIBS                := ${VMOD_DIR}/nvdla/nocif/NV_NVDLA_XXIF_libs.v
VLIBS                += ${VMOD_LIB_DIR}/RANDFUNC.vlib
VLIBS                += ${VMOD_LIB_DIR}/nv_assert_no_x.vlib
ifeq (${USE_DESIGNWARE},0)
DWDIR                := ${TOT}/${OUTDIR}/${PROJECT}/vmod/vlibs
DWFILES              := ${DWDIR}/NV_DW02_tree.v \
                        ${DWDIR}/NV_DW_lsd.v \
						${DWDIR}/NV_DW_minmax.v
else                           
DWDIR                =  ${DESIGNWARE_DIR}
endif                          
VLIBS                += ${DWFILES}
VCS_LIBS_ALL         := ${VLIBS:%=-v %}
MTI_LIBS_ALL         := ${VLIBS:%=-v %}

TRACE_PLAYER_DIR     := ${TOT}/verif/testbench/trace_player
MANUAL_DIR           := ${TOT}/${OUTDIR}/${PROJECT}/spec/manual
DEFS_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/spec/defs
RAL_DIR              := ${TOT}/verif/ral
CSB_VIP_DIR          := ${TOT}/verif/vip/csb_agent
DBB_VIP_DIR          := ${TOT}/verif/vip/dbb_agent
MEM_MODEL_DIR        := ${TOT}/verif/vip/mem_model
CMOD_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/verif/vip/reference_model/nvdla_cmod_wrap/release
UVMC_DIR             := ${UVMCONNECT_HOME}/src/connect/sv
SCSV_COMMON_DIR      := ${TOT}/verif/vip/reference_model/nvdla_scsv
TOP_SCSV_ADAPTER_DIR := ${TOT}/verif/vip/reference_model/nvdla_top_scsv_adapter
DMA_VIP_DIR          := ${TOT}/verif/vip/dma_agent
DP_VIP_DIR           := ${TOT}/verif/vip/dp_agent
CC_VIP_DIR           := ${TOT}/verif/vip/cc_agent
RM_VIP_DIR           := ${TOT}/verif/vip/reference_model/rm_nvdla_top
COVERAGE_DIR		 := ${TOT}/verif/coverage

## =========================================================================================
## Setting log file name variables
## =========================================================================================

COMPILELOG  := simv.build.log
SIMLOG      := run.log
SYSCLOG     := sysc.log
VCS_EXE     := simv

## =========================================================================================
## Generating file lists
## =========================================================================================

DEFS_FILE := ${TOT}/${OUTDIR}/${PROJECT}/spec/defs/project.vh

VERIF_SRC_FILES := ${shell find ${TOT}/verif/testbench/trace_player -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${TOT}/verif/ral -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${TOT}/verif/vip -name "*.sv" -o -name "*.cpp" -o -name "*.h" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${COVERAGE_DIR} -name "*.sv" -o -name "*.svh"}
VERIF_DST_FILES := ${subst ${TOT},${DEPTH}/${OUTDIR}/${PROJECT},${VERIF_SRC_FILES}}

UVMC_FILES  := ${UVMC_DIR}/uvmc_pkg.sv \

#ifeq ($(SIM_PLATFORM),vcs)
#VERIF_FILES := ${TRACE_PLAYER_DIR}/nvdla_tb_common.svh \
			   ${DBB_VIP_DIR}/dbb_pkg.sv \
			   ${MEM_MODEL_DIR}/mem_pkg.sv \
			   ${RAL_DIR}/nvdla_ral_pkg.sv \
			   ${CSB_VIP_DIR}/csb_pkg.sv \
			   ${RAL_DIR}/nvdla_reg_adapter.sv \
			   ${SCSV_COMMON_DIR}/sv/nvdla_scsv_pkg.sv \
			   ${TOP_SCSV_ADAPTER_DIR}/sv/nvdla_top_scsv_pkg.sv \
			   ${DMA_VIP_DIR}/dma_pkg.sv \
			   ${DP_VIP_DIR}/dp_pkg.sv \
			   ${CC_VIP_DIR}/cc_pkg.sv \
			   ${RM_VIP_DIR}/rm_nvdla_top_pkg.sv \
			   ${COVERAGE_DIR}/nvdla_coverage_pkg.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_scoreboard.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_override.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_txn.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_sequence.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_intr_handler.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_result_checker.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_env.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_trace_parser.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_base_test.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_top.sv \

#endif

#ifeq ($(SIM_PLATFORM),mti)
VERIF_FILES := ${TRACE_PLAYER_DIR}/nvdla_tb_common_pkg.sv \
                           ${TOT}/spec/manual/ordt_uvm_reg_pkg.sv \
			   ${DBB_VIP_DIR}/dbb_pkg.sv \
			   ${MEM_MODEL_DIR}/mem_pkg.sv \
			   ${RAL_DIR}/nvdla_ral_pkg.sv \
			   ${CSB_VIP_DIR}/csb_pkg.sv \
			   ${RAL_DIR}/nvdla_reg_adapter.sv \
			   ${SCSV_COMMON_DIR}/sv/nvdla_scsv_pkg.sv \
			   ${TOP_SCSV_ADAPTER_DIR}/sv/nvdla_top_scsv_pkg.sv \
			   ${DMA_VIP_DIR}/dma_pkg.sv \
			   ${DP_VIP_DIR}/dp_pkg.sv \
			   ${CC_VIP_DIR}/cc_pkg.sv \
			   ${RM_VIP_DIR}/rm_nvdla_top_pkg.sv \
			   ${COVERAGE_DIR}/nvdla_coverage_pkg.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_top.sv
# now included instead     ${TRACE_PLAYER_DIR}/nvdla_tb_override.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_txn.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_sequence.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_intr_handler.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_result_checker.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_env.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_trace_parser.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_base_test.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_top.sv \

#endif


TB_FILES    := ${UVMC_FILES} ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_FILES}}

DPI_FILES_TB := ${RM_VIP_DIR}/rm_convertor_dpi.cpp
DPI_FILES    := ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${DPI_FILES_TB}}

DUT_FILES := ${VMOD_DIR}/nvdla/top/NV_nvdla.v

VERIF_DIRS  := +incdir+${CSB_VIP_DIR} \
               +incdir+${DBB_VIP_DIR} \
               +incdir+${MEM_MODEL_DIR} \
               +incdir+${RAL_DIR} \
               +incdir+${SCSV_COMMON_DIR}/sv \
               +incdir+${DMA_VIP_DIR} \
               +incdir+${DP_VIP_DIR} \
               +incdir+${CC_VIP_DIR} \
               +incdir+${TOP_SCSV_ADAPTER_DIR}/sv \
               +incdir+${RM_VIP_DIR} \
               +incdir+${TRACE_PLAYER_DIR} \
               +incdir+${COVERAGE_DIR} \

COMMON_DIRS  := +incdir+${VMOD_INC_DIR} \
                ${VMOD_SRC_DIRS_ALL} \
                ${VMOD_RAM_DIRS_ALL} \
		+incdir+${VMOD_LIB_DIR} \
		        +incdir+${MANUAL_DIR} \
                +incdir+${DEFS_DIR} \
		        +incdir+${UVMC_DIR} \
                ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_DIRS}} \

## =========================================================================================
## Setting Compiler options
## =========================================================================================

ifeq (${USE_DESIGNWARE},1)
VCS_LIBS_ALL += ${DWDIR:%=-y %}
endif

VCS_LIBS_ALL += ${VMOD_SRC_DIRS:%=-y %}
VCS_LIBS_ALL += ${VMOD_RAM_DIRS:%=-y %}
VCS_LIBS_ALL += ${VMOD_LIB_DIR:%=-y %}

MTI_LIBS_ALL += ${VMOD_SRC_DIRS:%=-y %}
MTI_LIBS_ALL += ${VMOD_RAM_DIRS:%=-y %}
MTI_LIBS_ALL += ${VMOD_LIB_DIR:%=-y %}

VCS_LDFLAGS_PATH += ${CMOD_DIR}/lib
VCS_LDFLAGS_PATH += ${VCS_HOME}/linux64/lib
VCS_LDFLAGS_PATH_ALL = $(VCS_LDFLAGS_PATH:%=-L%)

MTI_LDFLAGS_PATH += ${CMOD_DIR}/lib
MTI_LDFLAGS_PATH += ${MTI_HOME}/linux_x86_64
MTI_LDFLAGS_PATH += /usr/lib/x86_64-linux-gnu
MTI_LDFLAGS_PATH += ${MTI_HOME}/gcc-4.7.4-linux_x86_64/lib64
MTI_LDFLAGS_PATH_ALL = $(MTI_LDFLAGS_PATH:%=-L%)

EMPTY :=
SPACE := ${EMPTY} ${EMPTY}
ifeq ($(SIM_PLATFORM),vcs)
export LD_LIBRARY_PATH := ${subst ${SPACE},:,${VCS_LDFLAGS_PATH}}:${LD_LIBRARY_PATH}
endif
ifeq ($(SIM_PLATFORM),mti)
export LD_LIBRARY_PATH := ${subst ${SPACE},:,${MTI_LDFLAGS_PATH}}:${LD_LIBRARY_PATH}
endif
VCS_LDFLAGS_LIB += nvdla_cmod
VCS_LDFLAGS_LIB_ALL := $(VCS_LDFLAGS_LIB:%=-l%)

VCS_LDFLAGS := -LDFLAGS "${VCS_LDFLAGS_PATH_ALL} ${VCS_LDFLAGS_LIB_ALL}"


VCS_CFLAGS_PATH     += ${TOT}/cmod/include
VCS_CFLAGS_PATH     += ${TOT}/cmod/include/nvdla_ness_header
VCS_CFLAGS_PATH     += ${TOT}/${OUTDIR}/${PROJECT}/spec/defs
VCS_CFLAGS_PATH_ALL := $(VCS_CFLAGS_PATH:%=-I%)
VCS_CFLAGS          := -CFLAGS "${VCS_CFLAGS_PATH_ALL}"

MTI_CFLAGS_PATH     += ${TOT}/cmod/include
MTI_CFLAGS_PATH     += ${TOT}/cmod/include/nvdla_ness_header
MTI_CFLAGS_PATH     += ${TOT}/${OUTDIR}/${PROJECT}/spec/defs
MTI_CFLAGS_PATH_ALL := $(MTI_CFLAGS_PATH:%=-I%)

ifeq ($(SIM_PLATFORM),vcs)
VCS_OK_WARNINGS     := +warn=noTFIPC +warn=noTMR

VCS_ARGS    := ${COMMON_DIRS} \
               -sverilog \
               -ntb_opts uvm-1.2 \
               -timescale=1ns/1ns \
               -assert enable_diag \
               -line \
               -cc ${GCC} -cpp ${CXX} -ld ${CXX} -Xcombo=0x11 \
               -full64 \
               +v2k \
               +libext+.vlib+.v+.sv+.svh \
               +define+NVTOOLS_SYNC2D_GENERIC_CELL \
               +define+PRAND_OFF \
               ${VCS_OK_WARNINGS} \
               ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a \
               +vcsd \
			   -parallel+sva+tgl \
               -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab 
endif

ifeq ($(SIM_PLATFORM),mti)
MTI_OK_WARNINGS := +nowarn2240

MTI_ARGS    := ${COMMON_DIRS} \
               -sv \
               -timescale=1ns/1ns \
               -64 \
	       +libext+.vlib+.v+.sv+.svh \
               +define+NVTOOLS_SYNC2D_GENERIC_CELL \
               +define+PRAND_OFF \
               ${MTI_OK_WARNINGS} \
               -modelsimini ${TOT}/modelsim.ini
endif

# add 'COVERAGE := 1' in tree.make
ifeq (${COVERAGE},1)
VCS_ARGS += -cm line+tgl+cond+fsm+branch+assert
VCS_ARGS += -cm_tgl portsonly -cm_cond allops -cm_line contassign
VCS_ARGS += -cm_libs yv
VCS_ARGS += -cm_hier ${COVERAGE_DIR}/nvdla.hier
#VCS_ARGS += -cm_dir simv.cm
endif

SIMV_ARGS   := +wave \
               +UVM_OBJECTION_TRACE \
               +WORK_MODE=${WORK_MODE} \

VERDI_ARGS  := ${COMMON_DIRS} \
               -ssv -ssy -nologo \
               +define+NVTOOLS_SYNC2D_GENERIC_CELL \
               +define+PRAND_OFF \
               +libext+.vlib+.v+.vh+.sv+.svh \
               ${DEFS_FILE} \
               -sv ${TB_FILES} \

ifeq (${NVDLA_SAIF_ENABLE},1)
	VCS_ARGS  += +vcs+saif_libcell +define+NVDLA_SAIF_ENABLE
endif


## =========================================================================================
## SYSTEMC Compiler/Linker setup                                                                                   
## =========================================================================================
# Variables:
#   SYSC_SRC = This should have all the cpp files
#   SYSC_CINCDIRS = This should have all the include directories (without -I)
#   SYSC_CDEFINES = This should have all the C defines you need (without -D) 
#   SYSCAN_CFLAGS = Any cflags you want to pass (without -cflags) to syscan
#   SYSCAN_EXTRA_ARGS = Any misc args the user wants to supply to syscan
#   SCCOM_CFLAGS = Any cflags you want to pass (without -cflags) to sccom
#   SCCOM_EXTRA_ARGS = Any misc args the user wants to supply to sccom
#   SYSC_VER = Specify the SystemC version that Syscan should use (For example 230,220)

SYSCAN_EXE   := syscan
SYSC_VER     ?= 230
_SYSC_VER    ?= -sysc=$(SYSC_VER)


SYSC_SRC_UVMC += ${UVMCONNECT_HOME}/src/connect/sc/uvmc.cpp
SYSC_SRC_TB   += ${SCSV_COMMON_DIR}/sc/nvdla_dbb_scsv_extension_packer.cpp
SYSC_SRC_TB   += ${SCSV_COMMON_DIR}/sc/nvdla_scsv_converter.cpp
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/nvdla_top_sc_layer.cpp
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/log.cpp
ifeq ($(SIM_PLATFORM),vcs)
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/nvdla_top_sc_adapter.cpp:nvdla_top_sc_adapter
endif
ifeq ($(SIM_PLATFORM),mti)
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/nvdla_top_sc_adapter.cpp
endif
SYSC_SRC      := ${SYSC_SRC_UVMC} ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${SYSC_SRC_TB}}

SYSC_CINCDIRS    := ${UVMCONNECT_HOME}/src/connect/sc
ifeq ($(SIM_PLATFORM),vcs)
SYSC_CINCDIRS    += $(VCS_HOME)/include/systemc23
endif
ifeq ($(SIM_PLATFORM),mti)
#To use SystemC 2.3.0 in Questa 10.4b
SYSC_CINCDIRS    += $(MTI_HOME)/include/systemc
endif
SYSC_CINCDIRS    += ${CMOD_DIR}/include
SYSC_CINCDIRS_TB += ${SCSV_COMMON_DIR}/sc
SYSC_CINCDIRS_TB += ${TOP_SCSV_ADAPTER_DIR}/sc
SYSC_CINCDIRS    += ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${SYSC_CINCDIRS_TB}}

ifeq ($(SIM_PLATFORM),vcs)
SYSCAN_CINCDIRS_ALL = $(SYSC_CINCDIRS:%=-I%)

SYSC_CDEFINES += VCS
SYSCAN_CDEFINES_ALL = $(SYSC_CDEFINES:%=-D%)

# Add debug options to syscan
SYSCAN_FLAGS  += $(if $(filter 1,$(VCS_DEBUG_ALL)),-debug_all )
SYSCAN_CFLAGS += $(if $(filter 1,$(VCS_DEBUG_ALL)),-g )

SYSCAN_CFLAGS += -D__STDC_FORMAT_MACROS
SYSCAN_CFLAGS += -DNVDLA_REFERENCE_MODEL_ENABLE 
SYSCAN_CFLAGS += -DUVMC_MAX_WORDS=2048

# Add -full64 if doing a 64bit compile
SYSCAN_FLAGS += -full64
SYSCAN_FLAGS += -cc ${GCC} -cpp ${CXX}

# Add TLM-2.0 libs to the compile
SYSCAN_FLAGS += -tlm2 -sysc=opt_if


SYSCAN_FLAGS_ALL  += $(SYSCAN_FLAGS) $(SYSCAN_EXTRA_ARGS)
SYSCAN_CFLAGS_ALL += -cflags "$(SYSCAN_CFLAGS) $(SYSCAN_CDEFINES_ALL) $(SYSCAN_CINCDIRS_ALL)"
endif

ifeq ($(SIM_PLATFORM),mti)
SCCOM_CINCDIRS_ALL = $(SYSC_CINCDIRS:%=-I%)

SYSC_CDEFINES += MTI_SYSTEMC
SCCOM_CDEFINES_ALL = $(SYSC_CDEFINES:%=-D%)

# Add debug options to syscan
SCCOM_CFLAGS += $(if $(filter 1,$(VCS_DEBUG_ALL)),-g )

SCCOM_CFLAGS += -D__STDC_FORMAT_MACROS
SCCOM_CFLAGS += -DNVDLA_REFERENCE_MODEL_ENABLE 
SCCOM_CFLAGS += -DUVMC_MAX_WORDS=2048
#http://forums.accellera.org/topic/1547-getting-error/?tab=comments#comment-5927
SCCOM_CFLAGS += -DSC_INCLUDE_DYNAMIC_PROCESSES

# Add -full64 if doing a 64bit compile
SCCOM_FLAGS += -64 -vv -verbose -warning 94

SCCOM_FLAGS_ALL  += $(SCCOM_FLAGS) $(SCCOM_EXTRA_ARGS)
SCCOM_CFLAGS_ALL += $(SCCOM_CFLAGS) $(SCCOM_CDEFINES_ALL) $(SCCOM_CINCDIRS_ALL)
endif

## =========================================================================================
## make target
## =========================================================================================

default: build

ifeq ($(SIM_PLATFORM),vcs)
build: vcs_build gen_verdi_cmd
endif

ifeq ($(SIM_PLATFORM),mti)
build: mti_build
endif

ifeq ($(SIM_PLATFORM),vcs)
sysc_build: ${VERIF_DST_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	${SYSCAN_EXE} ${_SYSC_VER} -V -work DEFAULT -l ${SYSCLOG} \
	${SYSCAN_FLAGS_ALL} ${SYSCAN_CFLAGS_ALL} ${SYSC_SRC} -Mdir=csrc
endif

ifeq ($(SIM_PLATFORM),mti)
sysc_build: ${VERIF_DST_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	sccom -modelsimini ${TOT}/modelsim.ini -log ${SYSCLOG} -warning 6172 \
	${MTI_LDFLAGS_PATH_ALL} ${SCCOM_FLAGS_ALL} ${SCCOM_CFLAGS_ALL} ${SYSC_SRC} && \
	sccom -warning 6172 -modelsimini ${TOT}/modelsim.ini /usr/lib/x86_64-linux-gnu/libstdc++.so.6 ${CMOD_DIR}/lib/libnvdla_cmod.so -link -Wl,-rpath,/usr/lib/x86_64-linux-gnu ${MTI_LDFLAGS_PATH_ALL} ${SCCOM_FLAGS_ALL} ${SCCOM_CFLAGS_ALL}
endif

vcs_build: sysc_build ${DEFS_FILE} ${DUT_FILES} ${DPI_FILES} ${UVMC_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	$(VCS_HOME)/bin/vcs -sysc=230 ${VCS_ARGS} ${VCS_LIBS_ALL} ${VCS_LDFLAGS} ${VCS_CFLAGS} ${DEFS_FILE} ${DUT_FILES} ${TB_FILES} ${DPI_FILES} -l ${COMPILELOG} -o ${VCS_EXE} -Mdir=csrc

mti_build: sysc_build ${DEFS_FILE} ${DUT_FILES} ${DPI_FILES} ${UVMC_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	$(MTI_HOME)/bin/vlog -ccflags "$(SCCOM_CINCDIRS_ALL) $(MTI_CFLAGS_PATH_ALL)" ${MTI_ARGS} ${MTI_LIBS_ALL} ${DEFS_FILE} ${DUT_FILES} ${TB_FILES} ${DPI_FILES} -l ${COMPILELOG}

gen_verdi_cmd:
	@echo "#!/bin/sh"                        > ${OUT_DIR}/run_verdi.sh
	@echo ""                                >> ${OUT_DIR}/run_verdi.sh
	@echo "export VERDI_HOME=${VERDI_HOME}" >> ${OUT_DIR}/run_verdi.sh
	@echo "export NOVAS_HOME=${VERDI_HOME}" >> ${OUT_DIR}/run_verdi.sh
	@echo ""                                >> ${OUT_DIR}/run_verdi.sh
	@echo "\$$VERDI_HOME/bin/verdi ${VERDI_ARGS} ${VCS_LIBS_ALL} -ntb_opts uvm-1.2 -top nvdla_tb_top -ssf nvdla.fsdb &" >> ${OUT_DIR}/run_verdi.sh
	@chmod 754 ${OUT_DIR}/run_verdi.sh

run_vcs:
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/cc_8x8x32_32x1x1x32_pack_all_zero_int8/cc_8x8x32_32x1x1x32_pack_all_zero_int8.cfg
	${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/sdp_passthrough_8x8x32_pack_inc_int8/sdp_passthrough_8x8x32_pack_inc_int8.cfg
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/pdp_passthrough_8x8x32_pack_inc_int8/pdp_passthrough_8x8x32_pack_inc_int8.cfg
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/cdp_passthrough_8x8x32_pack_inc_int8/cdp_passthrough_8x8x32_pack_inc_int8.cfg

ln_gcc:
	cd $(TOT)/$(OUTDIR)/${PROJECT}/verif/testbench/trace_player/work/_sc ; \
	ln -s -f linux_x86_64_gcc-4.7.4 linux_x86_64_gcc-4.9.2

run_mti:	ln_gcc
		cd ${OUT_DIR} ; \
		export LIBRARY_PATH='/tools/model/qs10.4b/questasim/linux_x86_64:/usr/lib/x86_64-linux-gnu' && \
		vsim -64 nvdla_tb_top -ldflags "-L/usr/lib/x86_64-linux-gnu" -cpppath /usr/bin/g++ \
		-novopt -modelsimini ${TOT}/modelsim.ini +nowarn3691 +nowarn3764 -c +UVM_VERBOSITY=UVM_HIGH +UVM_CONFIG_DB_TRACE -permit_unmatched_virtual_intf \
		+uvm_set_config_int=*,auto_dump_surface,1 \
		+uvm_set_config_string=*,trace_file_path,${TOT}/verif/tests/trace_tests/${PROJECT}/cdp_1x1x1_lrn3_int8_0/cdp_1x1x1_lrn3_int8_0.cfg \
		+uvm_set_config_string=*,parser_core_path,${TOT}/verif/tools/nvdla_trace_parser.py

ifeq ($(SIM_PLATFORM),vcs)
run:	run_vcs
endif

ifeq ($(SIM_PLATFORM),mti)
run:	run_mti
endif

ifeq ($(SIM_PLATFORM),vcs)
run_gui:
	${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_TESTNAME=${TEST} -gui
endif

ifeq ($(SIM_PLATFORM),mti)
run_gui:
	@echo "Target" $@ "not implemented for" $(SIM_PLATFORM)
endif

ifeq ($(SIM_PLATFORM),vcs)
verdi:
	${VERDI_HOME}/bin/verdi ${VERDI_ARGS} ${VCS_LIBS_ALL}  -ntb_opts uvm-1.2  -top nvdla_tb_top &
endif

ifeq ($(SIM_PLATFORM),mti)
verdi:
	@echo "Target" $@ "not implemented for" $(SIM_PLATFORM)
endif

${VERIF_DST_FILES}: ${DEPTH}/${OUTDIR}/${PROJECT}/% : ${TOT}/%
	@${MKDIRP} ${dir $@}
	@${CP} $< $@
	${PYTHON} ${EPYTHON} -p ${PROJECT} -u $@ 

.PHONY : clean

.PHONY : run

clean: clear
	${RM} ${OUT_DIR}

clear:
	${RM}  *.log *.dat DVEfiles simv* urgReport *.prof vc_hdrs.h ucli.key *.fsdb novas* verdiLog AN.DB .vlogan*

