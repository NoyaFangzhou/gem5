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
GEM5_DIR=/localdisk/schakr11/CSC573/gem5/gem5                         # Install location of gem5
SPEC_DIR=/localdisk/schakr11/CSC573/cpu2017                 # Install location of your SPEC2006 benchmarks
##################################################################
 
ARGC=$# # Get number of arguments excluding arg0 (the script itself). Check for help message condition.
if [[ "$ARGC" != 2 ]]; then # Bad number of arguments.
    echo "run_gem5_x86_spec17_benchmark.sh  Copyright (C) 2014 Mark Gottscho"
   echo "This program comes with ABSOLUTELY NO WARRANTY; for details see <http://www.gnu.org/licenses/>."
   echo "This is free software, and you are welcome to redistribute it under certain conditions; see <http://www.gnu.org/licenses/> for details."
   echo ""
    echo "Author: Mark Gottscho"
    echo "mgottscho@ucla.edu"
    echo ""
    echo "This script runs a single gem5 simulation of a single SPEC CPU2006 benchmark for Alpha ISA."
    echo ""
    echo "USAGE: run_gem5_x86_spec17_benchmark.sh <BENCHMARK> <OUTPUT_DIR>"
    echo "EXAMPLE: ./run_gem5_x86_spec17_benchmark.sh bzip2 /FULL/PATH/TO/output_dir"
    echo ""
    echo "A single --help help or -h argument will bring this message back."
    exit
fi
 
# Get command line input. We will need to check these.
BENCHMARK=$1                    # Benchmark name, e.g. bzip2
OUTPUT_DIR=$2                   # Directory to place run output. Make sure this exists!
 
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

#PERLBENCH_CODE=400.perlbench
#BZIP2_CODE=401.bzip2
#GCC_CODE=403.gcc
#BWAVES_CODE=410.bwaves
#GAMESS_CODE=416.gamess
#MCF_CODE=429.mcf
#MILC_CODE=433.milc
#ZEUSMP_CODE=434.zeusmp
#GROMACS_CODE=435.gromacs
#CACTUSADM_CODE=436.cactusADM
#LESLIE3D_CODE=437.leslie3d
#NAMD_CODE=444.namd
#GOBMK_CODE=445.gobmk
#DEALII_CODE=447.dealII
#SOPLEX_CODE=450.soplex
#POVRAY_CODE=453.povray
#CALCULIX_CODE=454.calculix
#HMMER_CODE=456.hmmer
#SJENG_CODE=458.sjeng
#GEMSFDTD_CODE=459.GemsFDTD
#LIBQUANTUM_CODE=462.libquantum
#H264REF_CODE=464.h264ref
#TONTO_CODE=465.tonto
#LBM_CODE=470.lbm
#MNETPP_CODE=471.omnetpp
#ASTAR_CODE=473.astar
#WRF_CODE=481.wrf
#SPHINX3_CODE=482.sphinx3
#XALANCBMK_CODE=483.xalancbmk
#SPECRAND_INT_CODE=998.specrand
#sSPECRAND_FLOAT_CODE=999.specrand
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
 
# Sanity check
if [[ "$BENCHMARK_CODE" == "none" ]]; then
    echo "Input benchmark selection $BENCHMARK did not match any known SPEC CPU2006 benchmarks! Exiting."
    exit 1
fi
##################################################################
 
# Check OUTPUT_DIR existence
if [[ !(-d "$OUTPUT_DIR") ]]; then
    echo "Output directory $OUTPUT_DIR does not exist! Exiting."
    exit 1
fi
 
RUN_DIR=$SPEC_DIR/benchspec/CPU/$BENCHMARK_CODE/run/run_base_refrate_removeVector-m64.0000    # Run directory for the selected SPEC benchmark
SCRIPT_OUT=$OUTPUT_DIR/runscript.log                                                                    # File log for this script's stdout henceforth
 
################## REPORT SCRIPT CONFIGURATION ###################
 
echo "Command line:"                                | tee $SCRIPT_OUT
echo "$0 $*"                                        | tee -a $SCRIPT_OUT
echo "================= Hardcoded directories ==================" | tee -a $SCRIPT_OUT
echo "GEM5_DIR:                                     $GEM5_DIR" | tee -a $SCRIPT_OUT
echo "SPEC_DIR:                                     $SPEC_DIR" | tee -a $SCRIPT_OUT
echo "==================== Script inputs =======================" | tee -a $SCRIPT_OUT
echo "BENCHMARK:                                    $BENCHMARK" | tee -a $SCRIPT_OUT
echo "OUTPUT_DIR:                                   $OUTPUT_DIR" | tee -a $SCRIPT_OUT
echo "==========================================================" | tee -a $SCRIPT_OUT
##################################################################
 
 
#################### LAUNCH GEM5 SIMULATION ######################
echo ""
echo "Changing to SPEC benchmark runtime directory: $RUN_DIR" | tee -a $SCRIPT_OUT
cd $RUN_DIR
 
echo "" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
echo "--------- Here goes nothing! Starting gem5! ------------" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
echo "" | tee -a $SCRIPT_OUT
 
# Actually launch gem5!
#$GEM5_DIR/build/X86/gem5.opt --outdir=$OUTPUT_DIR $GEM5_DIR/configs/example/spec2017_config.py --benchmark=$BENCHMARK --benchmark_stdout=$OUTPUT_DIR/$BENCHMARK.out --benchmark_stderr=$OUTPUT_DIR/$BENCHMARK.err | tee -a $SCRIPT_OUT

$GEM5_DIR/build/X86/gem5.opt --outdir=$OUTPUT_DIR $GEM5_DIR/configs/example/spec2017_config.py  --cpu-clock='1 GHz' --l1d_size=32kB --l1i_size=32kB --caches --l2_size=256kB --l2cache --cpu-type=TimingSimpleCPU --mem-type=DDR_NVM_4GB_8x2x128 --mem-size=4GB --mem-channels=1 -I 10000000 --benchmark=$BENCHMARK --benchmark_stdout=$OUTPUT_DIR/$BENCHMARK.out --benchmark_stderr=$OUTPUT_DIR/$BENCHMARK.err | tee -a $SCRIPT_OUT
