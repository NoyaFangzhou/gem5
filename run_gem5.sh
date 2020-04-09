#!/bin/bash
ARGC=$#
if [[ "$ARGC" != 3 ]]; then
    echo "No instruction number given. Run to the end"
    ./run_gem5_x86_spec17_benchmark.sh $1 /localdisk/fliu14/gem5-nvmain/gem5/gem5-results $2
else
    echo "Run $3 instructions."
    ./run_gem5_x86_spec17_benchmark.sh $1 /localdisk/fliu14/gem5-nvmain/gem5/gem5-results $2 $3
fi
