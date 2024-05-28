`default_nettype none

module design_instantiations (
	input logic [11:0] io_in,
	output logic [11:0] io_out,

	input logic [5:0] des_sel,
	input logic hold_if_not_sel,
	input logic sync_inputs,

	input logic clock, reset
);

	logic [11:0] des_io_in[0:63];
	logic [11:0] des_io_out[0:63];
	logic des_reset[0:63];

    multiplexer mux (.*);

// Design #0
// Unpopulated design slot
assign des_io_out[0] = 12'h000;


// Design #1
// Design name d01_example_adder
d01_example_adder inst1 (
    .io_in({des_reset[1], clock, des_io_in[1]}),
    .io_out(des_io_out[1])
);


// Design #2
// Design name d02_example_counter
d02_example_counter inst2 (
    .io_in({des_reset[2], clock, des_io_in[2]}),
    .io_out(des_io_out[2])
);


// Design #3
// Design name d03_example_iotest
d03_example_iotest inst3 (
    .io_in({des_reset[3], clock, des_io_in[3]}),
    .io_out(des_io_out[3])
);


// Design #4
// Unpopulated design slot
assign des_io_out[4] = 12'h000;


// Design #5
// Design name d05_meta_info
d05_meta_info inst5 (
    .io_in({des_reset[5], clock, des_io_in[5]}),
    .io_out(des_io_out[5])
);


// Design #6
// Design name d06_demo_vgapong
d06_demo_vgapong inst6 (
    .io_in({des_reset[6], clock, des_io_in[6]}),
    .io_out(des_io_out[6])
);


// Design #7
// Design name d07_demo_vgarunner
d07_demo_vgarunner inst7 (
    .io_in({des_reset[7], clock, des_io_in[7]}),
    .io_out(des_io_out[7])
);


// Design #8
// Unpopulated design slot
assign des_io_out[8] = 12'h000;


// Design #9
// Unpopulated design slot
assign des_io_out[9] = 12'h000;


// Design #10
// Design name d10_jjalacce_connect4
d10_jjalacce_connect4 inst10 (
    .io_in({des_reset[10], clock, des_io_in[10]}),
    .io_out(des_io_out[10])
);


// Design #11
// Design name d11_zhexic_i2cdriver
d11_zhexic_i2cdriver inst11 (
    .io_in({des_reset[11], clock, des_io_in[11]}),
    .io_out(des_io_out[11])
);


// Design #12
// Design name d12_sjg2_tiny_game_of_life
d12_sjg2_tiny_game_of_life inst12 (
    .io_in({des_reset[12], clock, des_io_in[12]}),
    .io_out(des_io_out[12])
);


// Design #13
// Design name d13_thomaska_cordic
d13_thomaska_cordic inst13 (
    .io_in({des_reset[13], clock, des_io_in[13]}),
    .io_out(des_io_out[13])
);


// Design #14
// Design name d14_siyuanl4_matrixcalc
d14_siyuanl4_matrixcalc inst14 (
    .io_in({des_reset[14], clock, des_io_in[14]}),
    .io_out(des_io_out[14])
);


// Design #15
// Design name d15_spencer2_pianotiles
d15_spencer2_pianotiles inst15 (
    .io_in({des_reset[15], clock, des_io_in[15]}),
    .io_out(des_io_out[15])
);


// Design #16
// Design name d16_jaehyun3_bobatc
d16_jaehyun3_bobatc inst16 (
    .io_in({des_reset[16], clock, des_io_in[16]}),
    .io_out(des_io_out[16])
);


// Design #17
// Design name d17_cporco_clockbox
d17_cporco_clockbox inst17 (
    .io_in({des_reset[17], clock, des_io_in[17]}),
    .io_out(des_io_out[17])
);


// Design #18
// Design name d18_vrajesh_motorcontroller
d18_vrajesh_motorcontroller inst18 (
    .io_in({des_reset[18], clock, des_io_in[18]}),
    .io_out(des_io_out[18])
);


// Design #19
// Design name d19_gsavant_16bit_serial_cpu
d19_gsavant_16bit_serial_cpu inst19 (
    .io_in({des_reset[19], clock, des_io_in[19]}),
    .io_out(des_io_out[19])
);


// Design #20
// Design name d20_zhehuax_16bit_fpu
d20_zhehuax_16bit_fpu inst20 (
    .io_in({des_reset[20], clock, des_io_in[20]}),
    .io_out(des_io_out[20])
);


// Design #21
// Unpopulated design slot
assign des_io_out[21] = 12'h000;


// Design #22
// Unpopulated design slot
assign des_io_out[22] = 12'h000;


// Design #23
// Unpopulated design slot
assign des_io_out[23] = 12'h000;


// Design #24
// Unpopulated design slot
assign des_io_out[24] = 12'h000;


// Design #25
// Unpopulated design slot
assign des_io_out[25] = 12'h000;


// Design #26
// Unpopulated design slot
assign des_io_out[26] = 12'h000;


// Design #27
// Unpopulated design slot
assign des_io_out[27] = 12'h000;


// Design #28
// Unpopulated design slot
assign des_io_out[28] = 12'h000;


// Design #29
// Unpopulated design slot
assign des_io_out[29] = 12'h000;


// Design #30
// Unpopulated design slot
assign des_io_out[30] = 12'h000;


// Design #31
// Unpopulated design slot
assign des_io_out[31] = 12'h000;


// Design #32
// Unpopulated design slot
assign des_io_out[32] = 12'h000;


// Design #33
// Unpopulated design slot
assign des_io_out[33] = 12'h000;


// Design #34
// Unpopulated design slot
assign des_io_out[34] = 12'h000;


// Design #35
// Unpopulated design slot
assign des_io_out[35] = 12'h000;


// Design #36
// Unpopulated design slot
assign des_io_out[36] = 12'h000;


// Design #37
// Unpopulated design slot
assign des_io_out[37] = 12'h000;


// Design #38
// Unpopulated design slot
assign des_io_out[38] = 12'h000;


// Design #39
// Unpopulated design slot
assign des_io_out[39] = 12'h000;


// Design #40
// Unpopulated design slot
assign des_io_out[40] = 12'h000;


// Design #41
// Unpopulated design slot
assign des_io_out[41] = 12'h000;


// Design #42
// Unpopulated design slot
assign des_io_out[42] = 12'h000;


// Design #43
// Unpopulated design slot
assign des_io_out[43] = 12'h000;


// Design #44
// Unpopulated design slot
assign des_io_out[44] = 12'h000;


// Design #45
// Unpopulated design slot
assign des_io_out[45] = 12'h000;


// Design #46
// Unpopulated design slot
assign des_io_out[46] = 12'h000;


// Design #47
// Unpopulated design slot
assign des_io_out[47] = 12'h000;


// Design #48
// Unpopulated design slot
assign des_io_out[48] = 12'h000;


// Design #49
// Unpopulated design slot
assign des_io_out[49] = 12'h000;


// Design #50
// Unpopulated design slot
assign des_io_out[50] = 12'h000;


// Design #51
// Unpopulated design slot
assign des_io_out[51] = 12'h000;


// Design #52
// Unpopulated design slot
assign des_io_out[52] = 12'h000;


// Design #53
// Unpopulated design slot
assign des_io_out[53] = 12'h000;


// Design #54
// Unpopulated design slot
assign des_io_out[54] = 12'h000;


// Design #55
// Unpopulated design slot
assign des_io_out[55] = 12'h000;


// Design #56
// Unpopulated design slot
assign des_io_out[56] = 12'h000;


// Design #57
// Unpopulated design slot
assign des_io_out[57] = 12'h000;


// Design #58
// Unpopulated design slot
assign des_io_out[58] = 12'h000;


// Design #59
// Unpopulated design slot
assign des_io_out[59] = 12'h000;


// Design #60
// Unpopulated design slot
assign des_io_out[60] = 12'h000;


// Design #61
// Unpopulated design slot
assign des_io_out[61] = 12'h000;


// Design #62
// Unpopulated design slot
assign des_io_out[62] = 12'h000;


// Design #63
// Unpopulated design slot
assign des_io_out[63] = 12'h000;


endmodule
