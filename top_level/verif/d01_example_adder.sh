#!/bin/sh
DES_NAME=d01_example_adder
TESTBENCH=tb.v

`dirname "$0"`/run-icarus-tb.sh $DES_NAME $TESTBENCH $TB_MODE
