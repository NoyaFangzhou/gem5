#!/bin/bash
#
# run_gem5_alpha_spec06_benchmark.sh
# Author: Mark Gottscho Email: mgottscho@ucla.edu
# Copyright (C) 2014 Mark Gottscho
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 
############ DIRECTORY VARIABLES: MODIFY ACCORDINGLY #############
GEM5_DIR="/localdisk/fliu14/gem5-nvmain/gem5"                            # Install location of gem5
SPEC_DIR="/localdisk/fliu14/cpu2017"           # Install location of your SPEC2017 benchmarks
##################################################################
 
echo "$0 $*"                                        | tee -a $SCRIPT_OUT
ARGC=$# # Get number of arguments excluding arg0 (the script itself). Check for help message condition.
if [[ "$ARGC" < 2 ]]; then # Bad number of arguments.
    echo "run_gem5_x86_spec06_benchmark.sh  Copyright (C) 2014 Mark Gottscho"
    echo "This program comes with ABSOLUTELY NO WARRANTY; for details see <http://www.gnu.org/licenses/>."
    echo "This is free software, and you are welcome to redistribute it under certain conditions; see <http://www.gnu.org/licenses/> for details."
    echo ""
    echo "Author: Mark Gottscho"
    echo "mgottscho@ucla.edu"
    echo ""
    echo "Modified by Fangzhou Liu"
    echo ""
    echo "This script runs a single gem5 simulation of a single SPEC CPU2006 benchmark for Alpha ISA."
    echo ""
    echo "USAGE: run_gem5_x86_spec17_benchmark.sh <BENCHMARK> <OUTPUT_DIR> <OPTION>"
    echo "EXAMPLE: ./run_gem5_x86_spec17_benchmark.sh bzip2 /FULL/PATH/TO/output_dir"
    echo ""
    echo "OPTION:"
    echo "  -- INSTR_NUM:   Number of instrutions to simulate. Run to the end by
    default"
    echo "  -- MEM_TYPE:    Type to memory to be embedded."
    echo "A single --help help or -h argument will bring this message back."
    exit
fi
 
# Get command line input. We will need to check these.
BENCHMARK=$1                    # Benchmark name, e.g. bzip2
OUTPUT_DIR=$2                   # Directory to place run output. Make sure this exists!
INSTR_NUM="none"                # Number of instruction to simulate
MEM_TYPE="none"                 # Memory Type to simulate
if [[ "$ARGC" == 3 ]]; then
    MEM_TYPE=$3
elif [[ "$ARGC" == 4 ]]; then
    INSTR_NUM=$3
    MEM_TYPE=$4
fi
######################### BENCHMARK CODENAMES ####################
ROMS_CODE_R=554.roms_r
FOTONIK3D_CODE_R=549.fotonik3d_r
NAB_CODE_R=544.nab_r
IMAGICK_CODE_R=538.imagick_r
CAM4_CODE_R=527.cam4_r
WRF_CODE_R=521.wrf_r
LBM_CODE_R=519.lbm_r
POVRAY_CODE_R=511.povray_r
NAMD_CODE_R=508.namd_r
CACTUBSSN_CODE_R=507.cactuBSSN_r
BWAVES_CODE_R=503.bwaves_r
BLENDER_CODE_R=526.blender_r
PAREST_CODE_R=510.parest_r
XZ_CODE_R=557.xz_r
EXCHANGE2_CODE_R=548.exchange2_r
LEELA_CODE_R=541.leela_r
DEEPSJENG_CODE_R=531.deepsjeng_r
X264_CODE_R=525.x264_r
XALANCBMK_CODE_R=523.xalancbmk_r
OMNETPP_CODE_R=520.omnetpp_r
MCF_CODE_R=505.mcf_r
GCC_CODE_R=502.gcc_r
PERLBENCH_CODE_R=500.perlbench_r

DEEPSJENG_CODE_S=631.deepsjeng_s
OMNETPP_CODE_S=620.omnetpp_s
LBM_CODE_S=619.lbm_s
ROMS_CODE_S=654.roms_s
PERLBENCH_CODE_S=600.perlbench_s
CAM4_CODE_S=627.cam4_s
NAB_CODE_S=644.nab_s
POP2_CODE_S=628.pop2_s
X264_CODE_S=625.x264_s
FOTONIK3D_CODE_S=649.fotonik3d_s
GCC_CODE_S=602.gcc_s
XALANCBMK_CODE_S=623.xalancbmk_s
XZ_CODE_S=657.xz_s
MCF_CODE_S=605.mcf_s
LEELA_CODE_S=641.leela_s
CACTUBSSN_CODE_S=607.cactuBSSN_s
IMAGICK_CODE_S=638.imagick_s
WRF_CODE_S=621.wrf_s
EXCHANGE2_CODE_S=648.exchange2_s
BWAVES_CODE_S=603.bwaves_s
SPECRAND_INT_CODE=998.specrand_ir
SPECRAND_FLOAT_CODE=999.specrand_fr
##################################################################
 
# Check BENCHMARK input
#################### BENCHMARK CODE MAPPING ######################
BENCHMARK_CODE="none"
 
if [[ "$BENCHMARK" == "roms_r" ]]; then
  BENCHMARK_CODE=$ROMS_CODE_R
fi  
if [[ "$BENCHMARK" == "fotonik3d_r" ]]; then
  BENCHMARK_CODE=$FOTONIK3D_CODE_R
fi  
if [[ "$BENCHMARK" == "nab_r" ]]; then
  BENCHMARK_CODE=$NAB_CODE_R
fi  
if [[ "$BENCHMARK" == "imagick_r" ]]; then
  BENCHMARK_CODE=$IMAGICK_CODE_R
fi  
if [[ "$BENCHMARK" == "cam4_r"  ]]; then
  BENCHMARK_CODE=$CAM4_CODE_R
fi
if [[ "$BENCHMARK" == "wrf_r"  ]]; then
  BENCHMARK_CODE=$WRF_CODE_R
fi
if [[ "$BENCHMARK" == "lbm_r"  ]]; then
  BENCHMARK_CODE=$LBM_CODE_R
fi
if [[ "$BENCHMARK" == "povray_r"  ]]; then
  BENCHMARK_CODE=$POVRAY_CODE_R
fi
if [[ "$BENCHMARK" == "namd_r"  ]]; then
  BENCHMARK_CODE=$NAMD_CODE_R
fi
if [[ "$BENCHMARK" == "cactuBSSN_r"  ]]; then
  BENCHMARK_CODE=$CACTUBSSN_CODE_R
fi
if [[ "$BENCHMARK" == "bwaves_r"  ]]; then
  BENCHMARK_CODE=$BWAVES_CODE_R
fi
if [[ "$BENCHMARK" == "blender_r"  ]]; then
  BENCHMARK_CODE=$BLENDER_CODE_R
fi
if [[ "$BENCHMARK" == "parest_r"  ]]; then
  BENCHMARK_CODE=$PAREST_CODE_R
fi
if [[ "$BENCHMARK" == "xz_r"  ]]; then
  BENCHMARK_CODE=$XZ_CODE_R
fi
if [[ "$BENCHMARK" == "exchange2_r"  ]]; then
  BENCHMARK_CODE=$EXCHANGE2_CODE_R
fi
if [[ "$BENCHMARK" == "leela_r"  ]]; then
  BENCHMARK_CODE=$LEELA_CODE_R
fi
if [[ "$BENCHMARK" == "deepsjeng_r"  ]]; then
  BENCHMARK_CODE=$DEEPSJENG_CODE_R
fi
if [[ "$BENCHMARK" == "x264_r"  ]]; then
  BENCHMARK_CODE=$X264_CODE_R
fi
if [[ "$BENCHMARK" == "xalancbmk_r"  ]]; then
  BENCHMARK_CODE=$XALANCBMK_CODE_R
fi
if [[ "$BENCHMARK" == "omnetpp_r"  ]]; then
  BENCHMARK_CODE=$OMNETPP_CODE_R
fi
if [[ "$BENCHMARK" == "mcf_r"  ]]; then
  BENCHMARK_CODE=$MCF_CODE_R
fi
if [[ "$BENCHMARK" == "gcc_r"  ]]; then
  BENCHMARK_CODE=$GCC_CODE_R
fi
if [[ "$BENCHMARK" == "perlbench_r"  ]]; then
  BENCHMARK_CODE=$PERLBENCH_CODE_R
fi
if [[ "$BENCHMARK" == "deepsjeng_s"  ]]; then
  BENCHMARK_CODE=$DEEPSJENG_CODE_S
fi
if [[ "$BENCHMARK" == "omnetpp_s"  ]]; then
  BENCHMARK_CODE=$OMNETPP_CODE_S
fi
if [[ "$BENCHMARK" == "lbm_s"  ]]; then
  BENCHMARK_CODE=$LBM_CODE_S
fi
if [[ "$BENCHMARK" == "roms_s"  ]]; then
  BENCHMARK_CODE=$ROMS_CODE_S
fi
if [[ "$BENCHMARK" == "perlbench_s"  ]]; then
  BENCHMARK_CODE=$PERLBENCH_CODE_S
fi
if [[ "$BENCHMARK" == "cam4_s"  ]]; then
  BENCHMARK_CODE=$CAM4_CODE_S
fi
if [[ "$BENCHMARK" == "nab_s"  ]]; then
  BENCHMARK_CODE=$NAB_CODE_S
fi
if [[ "$BENCHMARK" == "pop2_s"  ]]; then
  BENCHMARK_CODE=$POP2_CODE_S
fi
if [[ "$BENCHMARK" == "x264_s"  ]]; then
  BENCHMARK_CODE=$X264_CODE_S
fi
if [[ "$BENCHMARK" == "fotonik3d_s"  ]]; then
  BENCHMARK_CODE=$FOTONIK3D_CODE_S
fi
if [[ "$BENCHMARK" == "gcc_s"  ]]; then
  BENCHMARK_CODE=$GCC_CODE_S
fi
if [[ "$BENCHMARK" == "xalancbmk_s"  ]]; then
  BENCHMARK_CODE=$XALANCBMK_CODE_S
fi
if [[ "$BENCHMARK" == "xz_s"  ]]; then
  BENCHMARK_CODE=$XZ_CODE_S
fi
if [[ "$BENCHMARK" == "mcf_s"  ]]; then
  BENCHMARK_CODE=$MCF_CODE_S
fi
if [[ "$BENCHMARK" == "leela_s"  ]]; then
  BENCHMARK_CODE=$LEELA_CODE_S
fi
if [[ "$BENCHMARK" == "cactuBSSN_s"  ]]; then
  BENCHMARK_CODE=$CACTUBSSN_CODE_S
fi
if [[ "$BENCHMARK" == "imagick_s"  ]]; then
  BENCHMARK_CODE=$IMAGICK_CODE_S
fi
if [[ "$BENCHMARK" == "wrf_s"  ]]; then
  BENCHMARK_CODE=$WRF_CODE_S
fi
if [[ "$BENCHMARK" == "exchange2_s"  ]]; then
  BENCHMARK_CODE=$EXCHANGE2_CODE_S
fi
if [[ "$BENCHMARK" == "bwaves_s"  ]]; then
  BENCHMARK_CODE=$BWAVES_CODE_S
fi
if [[ "$BENCHMARK" == "specrand_i" ]]; then
    BENCHMARK_CODE=$SPECRAND_INT_CODE
fi
if [[ "$BENCHMARK" == "specrand_f" ]]; then
    BENCHMARK_CODE=$SPECRAND_FLOAT_CODE
fi
 
# Sanity check
if [[ "$BENCHMARK_CODE" == "none" ]]; then
    echo "Input benchmark selection $BENCHMARK did not match any known SPEC
    CPU2017 benchmarks! Exiting."
    exit 1
fi

MEM_SIZE="4GB"
MEM_CHANNEL=4
if [[ "$MEM_TYPE" == "NVM_32GB_8x2x1024" ]]; then
    MEM_SIZE="32GB"
    MEM_CHANNEL=2
fi  
if [[ "$MEM_TYPE" == "NVM_4GB_8x2x128" ]]; then
    MEM_CHANNEL=2
fi  
if [[ "$MEM_TYPE" == "DDR_4GB_8x1x128" ]]; then
    MEM_CHANNEL=4
fi  
if [[ "$MEM_TYPE" == "none" ]]; then
    MEM_TYPE="DDR_4GB_8x1x128"
    echo "Input memory setting not specified. Use default settings."
    echo "Memory Type: $MEM_TYPE."
    echo "Memory Channels: 4."
    echo "Memory Size: 4GB."
fi
##################################################################
 
# Check OUTPUT_DIR existence
if [[ !(-d "$OUTPUT_DIR") ]]; then
    echo "Output directory $OUTPUT_DIR does not exist! Exiting."
    exit 1
fi
RUN_RATE_DIR=$SPEC_DIR/benchspec/CPU/$BENCHMARK_CODE/run/run_base_refrate_csc573-proj-m64.0000     # Run directory for the selected SPEC benchmark
RUN_SPEED_DIR=$SPEC_DIR/benchspec/CPU/$BENCHMARK_CODE/run/run_base_refspeed_csc573-proj-m64.0000     # Run directory for the selected SPEC benchmark

RUN_DIR=$RUN_RATE_DIR
SCRIPT_OUT=$OUTPUT_DIR/runscript.log                                                                    # File log for this script's stdout henceforth
 
################## REPORT SCRIPT CONFIGURATION ###################
 
echo "Command line:"                                | tee $SCRIPT_OUT
echo "$0 $*"                                        | tee -a $SCRIPT_OUT
echo "================= Hardcoded directories ==================" | tee -a $SCRIPT_OUT
echo "GEM5_DIR:                                     $GEM5_DIR" | tee -a $SCRIPT_OUT
echo "SPEC_DIR:                                     $SPEC_DIR" | tee -a $SCRIPT_OUT
echo "==================== Script inputs =======================" | tee -a $SCRIPT_OUT
echo "BENCHMARK:                                    $BENCHMARK" | tee -a $SCRIPT_OUT
echo "INSTRUCTIONS:                                 $INSTR_NUM" | tee -a $SCRIPT_OUT
echo "MEMORY_TYPE:                                  $MEM_TYPE" | tee -a $SCRIPT_OUT
echo "OUTPUT_DIR:                                   $OUTPUT_DIR" | tee -a $SCRIPT_OUT
echo "==========================================================" | tee -a $SCRIPT_OUT
##################################################################
 
 
#################### LAUNCH GEM5 SIMULATION ######################
echo ""
echo "Changing to SPEC benchmark refrate runtime directory: $RUN_DIR" | tee -a $SCRIPT_OUT
# check if this is a _r benchmark
if [[ !(-d "$RUN_DIR") ]]; then
    echo "Changing to SPEC benchmark refspeed runtime directory: $RUN_DIR" | tee -a $SCRIPT_OUT
    RUN_DIR=$RUN_SPEED_DIR
    if [[ !(-d "$RUN_DIR") ]]; then
        echo "$RUN_DIR does not exists. Creat first"
        exit 1
    fi
fi
cd $RUN_DIR
 
echo "" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
echo "--------- Here goes nothing! Starting gem5! ------------" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
 

# Memory Configuration
# Actually launch gem5!
# $GEM5_DIR/build/X86/gem5.opt --outdir=$OUTPUT_DIR $GEM5_DIR/configs/example/spec17_config.py --benchmark=$BENCHMARK --benchmark_stdout=$OUTPUT_DIR/$BENCHMARK.out --benchmark_stderr=$OUTPUT_DIR/$BENCHMARK.err | tee -a $SCRIPT_OUT
if [[ "$INSTR_NUM" == "none" ]]; then
    $GEM5_DIR/build/X86/gem5.opt --outdir=$OUTPUT_DIR $GEM5_DIR/configs/example/spec17_config.py --l1d_size=32kB --l1i_size=32kB \
    --caches --l2_size=256kB --l2cache --mem-type=$MEM_TYPE \
    --mem-channels=$MEM_CHANNEL --mem-size=$MEM_SIZE --cpu-type=TimingSimpleCPU --cpu-clock='1 GHz' \
    --benchmark=$BENCHMARK --benchmark_stdout=$OUTPUT_DIR/$BENCHMARK.out --benchmark_stderr=$OUTPUT_DIR/$BENCHMARK.err | tee -a $SCRIPT_OUT
else
    $GEM5_DIR/build/X86/gem5.opt --outdir=$OUTPUT_DIR $GEM5_DIR/configs/example/spec17_config.py --l1d_size=32kB --l1i_size=32kB \
    --caches --l2_size=256kB --l2cache --mem-type=$MEM_TYPE \
    --mem-channels=$MEM_CHANNEL --mem-size=$MEM_SIZE --cpu-type=TimingSimpleCPU --cpu-clock='1 GHz' -I $INSTR_NUM \
    --benchmark=$BENCHMARK --benchmark_stdout=$OUTPUT_DIR/$BENCHMARK.out --benchmark_stderr=$OUTPUT_DIR/$BENCHMARK.err | tee -a $SCRIPT_OUT
fi
cd $OUTPUT_DIR
if [[ !(-f "$OUTPUT_DIR/stats.txt") ]]; then
    echo "$OUTPUT_DIR/stats.txt does not exists"
    exit 1
fi
mv $OUTPUT_DIR/stats.txt $OUTPUT_DIR/$MEM_TYPE-stats.txt
