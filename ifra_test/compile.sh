#!/bin/bash


#VLOG_OPT="-vmake"
VLOG_OPT=""

## check Argument ##############

if [ $# -eq 0 ]; then
    arg1="rebuild"
else
    arg1=$1
fi

if [ $arg1 != "rebuild" -a $arg1 != "clean" ]; then
    
    echo "Param Error"
    echo "Param must \"rebuild\" or \"clean\""
    exit
fi

#echo "\$arg1 = $arg1"

## "clean" Action #####
if [ $arg1 = "clean" ]; then
    if [ -e ./work ]; then
	echo "delete working directory"
	rm -rf work
    fi

    if [ -e transcript ]; then
	rm -rf transcript
    fi

    if [ -e vsim.wlf ]; then
	rm -rf vsim.wlf
    fi
    exit
fi


# create workig directory
if [ -e ./work ]; then
    echo "delete working directory"
    rm -rf work
fi 

if [ ! -e ./work ]; then
    echo "create working directory"
    vlib ./work
fi



## source file compile ###########
vlog -sv ifra_mst.sv
vlog -sv ifra_slv.sv


## compile test_bench ############
vlog -sv ./tb_top.sv



##### Create Makefile ##################################
if [ -e ./Makefile ]; then
    rm Makefile
fi

echo "create Makefile"
vmake > Makefile

