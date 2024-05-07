TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/library.sv $(shell pwd)/add_8cycle.sv $(shell pwd)/mult.sv $(shell pwd)/main.sv
TOPLEVEL = Matrix_Calculator
MODULE = cal_testbench

# VERILOG_SOURCES = $(shell pwd)/library.sv $(shell pwd)/mult.sv
# TOPLEVEL = Multiply_Path
# MODULE = mult_testbench

# VERILOG_SOURCES = $(shell pwd)/library.sv $(shell pwd)/add_2cycle.sv
# TOPLEVEL = Add_Path
# MODULE = add_testbench

SIM = verilator
EXTRA_ARGS += --trace --trace-structs -Wno-fatal
include $(shell cocotb-config --makefiles)/Makefile.sim
