TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/verilogNoVGA.v
TOPLEVEL = Top
MODULE = Connect4_TB
SIM = verilator
EXTRA_ARGS += --trace --trace-structs -Wno-fatal
include $(shell cocotb-config --makefiles)/Makefile.sim