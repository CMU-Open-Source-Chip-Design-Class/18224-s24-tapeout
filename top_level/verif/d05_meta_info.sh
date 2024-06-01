#!/bin/sh
DES_NAME=d05_meta_info
TESTBENCH=tb.v

`dirname "$0"`/run-icarus-gl-tb.sh $DES_NAME $TESTBENCH $TB_MODE
