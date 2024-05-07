`default_nettype none
module Board (
	row,
	col,
	is_board
);
	input wire [8:0] row;
	input wire [9:0] col;
	output wire is_board;
	wire level_0_H_Between;
	wire level_1_H_Between;
	wire level_2_H_Between;
	wire level_3_H_Between;
	wire level_4_H_Between;
	wire level_5_H_Between;
	wire level_6_H_Between;
	wire is_board_H;
	assign is_board_H = (((((level_0_H_Between | level_1_H_Between) | level_2_H_Between) | level_3_H_Between) | level_4_H_Between) | level_5_H_Between) | level_6_H_Between;
	RangeCheck #(.w(9)) level_0_H(
		.val(row),
		.high(9'd29),
		.low(9'd0),
		.is_between(level_0_H_Between)
	);
	RangeCheck #(.w(9)) level_1_H(
		.val(row),
		.high(9'd104),
		.low(9'd75),
		.is_between(level_1_H_Between)
	);
	RangeCheck #(.w(9)) level_2_H(
		.val(row),
		.high(9'd179),
		.low(9'd150),
		.is_between(level_2_H_Between)
	);
	RangeCheck #(.w(9)) level_3_H(
		.val(row),
		.high(9'd254),
		.low(9'd225),
		.is_between(level_3_H_Between)
	);
	RangeCheck #(.w(9)) level_4_H(
		.val(row),
		.high(9'd329),
		.low(9'd300),
		.is_between(level_4_H_Between)
	);
	RangeCheck #(.w(9)) level_5_H(
		.val(row),
		.high(9'd404),
		.low(9'd375),
		.is_between(level_5_H_Between)
	);
	RangeCheck #(.w(9)) level_6_H(
		.val(row),
		.high(9'd479),
		.low(9'd450),
		.is_between(level_6_H_Between)
	);
	wire level_0_V_Between;
	wire level_1_V_Between;
	wire level_2_V_Between;
	wire level_3_V_Between;
	wire level_4_V_Between;
	wire level_5_V_Between;
	wire level_6_V_Between;
	wire level_7_V_Between;
	wire is_board_V;
	assign is_board_V = ((((((level_0_V_Between | level_1_V_Between) | level_2_V_Between) | level_3_V_Between) | level_4_V_Between) | level_5_V_Between) | level_6_V_Between) | level_7_V_Between;
	RangeCheck #(.w(10)) level_0_V(
		.val(col),
		.high(10'd44),
		.low(10'd0),
		.is_between(level_0_V_Between)
	);
	RangeCheck #(.w(10)) level_1_V(
		.val(col),
		.high(10'd129),
		.low(10'd85),
		.is_between(level_1_V_Between)
	);
	RangeCheck #(.w(10)) level_2_V(
		.val(col),
		.high(10'd214),
		.low(10'd170),
		.is_between(level_2_V_Between)
	);
	RangeCheck #(.w(10)) level_3_V(
		.val(col),
		.high(10'd299),
		.low(10'd255),
		.is_between(level_3_V_Between)
	);
	RangeCheck #(.w(10)) level_4_V(
		.val(col),
		.high(10'd384),
		.low(10'd340),
		.is_between(level_4_V_Between)
	);
	RangeCheck #(.w(10)) level_5_V(
		.val(col),
		.high(10'd469),
		.low(10'd425),
		.is_between(level_5_V_Between)
	);
	RangeCheck #(.w(10)) level_6_V(
		.val(col),
		.high(10'd554),
		.low(10'd510),
		.is_between(level_6_V_Between)
	);
	RangeCheck #(.w(10)) level_7_V(
		.val(col),
		.high(10'd639),
		.low(10'd595),
		.is_between(level_7_V_Between)
	);
	assign is_board = is_board_H | is_board_V;
endmodule
`default_nettype none
module Ownership (
	player_1_input,
	player_2_input,
	player_1_confirm,
	player_2_confirm,
	switchTurn,
	clock,
	reset,
	tokens,
	newGame
);
	input wire [6:0] player_1_input;
	input wire [6:0] player_2_input;
	input wire player_1_confirm;
	input wire player_2_confirm;
	input wire switchTurn;
	input wire clock;
	input wire reset;
	output reg [83:0] tokens;
	input wire newGame;
	reg [6:0] move;
	reg confirm;
	wire [1:0] set;
	wire currentPlayer;
	wire [1:0] tokensIn [0:5][0:6];
	currentPlayerFSM fsm(
		.switchTurn(switchTurn),
		.currentPlayer(currentPlayer),
		.clock(clock),
		.reset(reset)
	);
	assign set = (~currentPlayer & confirm ? 2'b01 : (currentPlayer & confirm ? 2'b10 : 2'b00));
	always @(posedge clock)
		if (reset)
			tokens <= 84'd0;
		else if (newGame)
			tokens <= 84'd0;
		else if (~confirm)
			tokens <= tokens;
		else if (tokens[(0 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(0 + (6 - move)) * 2+:2] <= set;
		else if (tokens[(7 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(7 + (6 - move)) * 2+:2] <= set;
		else if (tokens[(14 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(14 + (6 - move)) * 2+:2] <= set;
		else if (tokens[(21 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(21 + (6 - move)) * 2+:2] <= set;
		else if (tokens[(28 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(28 + (6 - move)) * 2+:2] <= set;
		else if (tokens[(35 + (6 - move)) * 2+:2] == 2'b00)
			tokens[(35 + (6 - move)) * 2+:2] <= set;
	always @(*)
		if (~currentPlayer) begin
			case (player_1_input)
				7'd1: move = 7'd0;
				7'd2: move = 7'd1;
				7'd4: move = 7'd2;
				7'd8: move = 7'd3;
				7'd16: move = 7'd4;
				7'd32: move = 7'd5;
				7'd64: move = 7'd6;
				default: move = 7'd9;
			endcase
			confirm = player_1_confirm;
		end
		else begin
			case (player_2_input)
				7'd1: move = 7'd0;
				7'd2: move = 7'd1;
				7'd4: move = 7'd2;
				7'd8: move = 7'd3;
				7'd16: move = 7'd4;
				7'd32: move = 7'd5;
				7'd64: move = 7'd6;
				default: move = 7'd9;
			endcase
			confirm = player_2_confirm;
		end
endmodule
module currentPlayerFSM (
	switchTurn,
	currentPlayer,
	clock,
	reset
);
	input wire switchTurn;
	output reg currentPlayer;
	input wire clock;
	input wire reset;
	reg currState;
	reg nextState;
	always @(posedge clock)
		if (reset)
			currState = 1'd0;
		else
			currState = nextState;
	always @(*)
		case (currState)
			1'd0:
				if (switchTurn)
					nextState = 1'd1;
				else
					nextState = 1'd0;
			1'd1:
				if (~switchTurn)
					nextState = 1'd0;
				else
					nextState = 1'd1;
		endcase
	always @(*)
		case (currState)
			1'd0: currentPlayer = 0;
			1'd1: currentPlayer = 1;
		endcase
endmodule
`default_nettype none
module PvE (
	clock,
	reset,
	tokens,
	bot_turn,
	bot_move,
	bot_confirm
);
	input wire clock;
	input wire reset;
	input wire [83:0] tokens;
	input wire bot_turn;
	output wire [6:0] bot_move;
	output wire bot_confirm;
	wire [6:0] random;
	reg col0Full;
	reg col1Full;
	reg col2Full;
	reg col3Full;
	reg col4Full;
	reg col5Full;
	reg col6Full;
	reg [6:0] wantToMove;
	wire bot_confirm_FSM;
	LSFR0 rand0(
		.reset(reset),
		.clock(clock),
		.randomOut(random[0])
	);
	LSFR1 rand1(
		.reset(reset),
		.clock(clock),
		.randomOut(random[1])
	);
	LSFR2 rand2(
		.reset(reset),
		.clock(clock),
		.randomOut(random[2])
	);
	LSFR3 rand3(
		.reset(reset),
		.clock(clock),
		.randomOut(random[3])
	);
	LSFR4 rand4(
		.reset(reset),
		.clock(clock),
		.randomOut(random[4])
	);
	LSFR5 rand5(
		.reset(reset),
		.clock(clock),
		.randomOut(random[5])
	);
	LSFR6 rand6(
		.reset(reset),
		.clock(clock),
		.randomOut(random[6])
	);
	always @(*) begin
		col6Full = (tokens[70+:2] == 2'b00 ? 0 : 1);
		col5Full = (tokens[72+:2] == 2'b00 ? 0 : 1);
		col4Full = (tokens[74+:2] == 2'b00 ? 0 : 1);
		col3Full = (tokens[76+:2] == 2'b00 ? 0 : 1);
		col2Full = (tokens[78+:2] == 2'b00 ? 0 : 1);
		col1Full = (tokens[80+:2] == 2'b00 ? 0 : 1);
		col0Full = (tokens[82+:2] == 2'b00 ? 0 : 1);
	end
	always @(*) begin
		wantToMove[0] = (random[0] & ~col0Full) & bot_turn;
		wantToMove[1] = (random[1] & ~col1Full) & bot_turn;
		wantToMove[2] = (random[2] & ~col2Full) & bot_turn;
		wantToMove[3] = (random[3] & ~col3Full) & bot_turn;
		wantToMove[4] = (random[4] & ~col4Full) & bot_turn;
		wantToMove[5] = (random[5] & ~col5Full) & bot_turn;
		wantToMove[6] = (random[6] & ~col6Full) & bot_turn;
	end
	PvEFSM fsm(
		.clock(clock),
		.reset(reset),
		.wantToMove(wantToMove),
		.bot_move(bot_move),
		.bot_confirm(bot_confirm),
		.bot_turn(bot_turn)
	);
endmodule
module PvEFSM (
	clock,
	reset,
	wantToMove,
	bot_turn,
	bot_move,
	bot_confirm
);
	input wire clock;
	input wire reset;
	input wire [6:0] wantToMove;
	input wire bot_turn;
	output reg [6:0] bot_move;
	output reg bot_confirm;
	reg [6:0] selectedMove;
	reg [22:0] timeOut;
	reg timeOutEn;
	reg timeOutClear;
	reg [22:0] timeOutDelay = 23'd6250000;
	reg [4:0] currState;
	reg [4:0] nextState;
	always @(posedge clock)
		if (reset) begin
			currState <= 5'd0;
			timeOut <= 23'd0;
		end
		else begin
			currState <= nextState;
			if (timeOutClear)
				timeOut <= 23'd0;
			else if (timeOutEn)
				timeOut <= timeOut + 23'd1;
		end
	always @(*)
		if (wantToMove[3])
			selectedMove = 7'd3;
		else if (wantToMove[4])
			selectedMove = 7'd4;
		else if (wantToMove[2])
			selectedMove = 7'd2;
		else if (wantToMove[5])
			selectedMove = 7'd5;
		else if (wantToMove[1])
			selectedMove = 7'd1;
		else if (wantToMove[6])
			selectedMove = 7'd6;
		else if (wantToMove[0])
			selectedMove = 7'd0;
		else
			selectedMove = 7'd10;
	always @(*) begin
		bot_move = 7'd0;
		bot_confirm = 0;
		timeOutClear = 1;
		timeOutEn = 0;
		case (currState)
			5'd0: begin
				bot_confirm = 0;
				bot_move = 7'd9;
				timeOutClear = 1;
				timeOutEn = 0;
				if (~bot_turn)
					nextState = 5'd0;
				else if (selectedMove < 7'd7)
					nextState = 5'd1;
				else
					nextState = 5'd0;
			end
			5'd1: begin
				bot_move[selectedMove] = 1;
				bot_confirm = 1;
				timeOutClear = 1;
				timeOutEn = 0;
				nextState = 5'd2;
			end
			5'd2: begin
				bot_move = 7'd9;
				bot_confirm = 0;
				timeOutEn = 1;
				timeOutClear = 0;
				if (~bot_turn && (timeOut >= timeOutDelay))
					nextState = 5'd0;
				else
					nextState = 5'd2;
			end
			default: begin
				bot_move = 7'd9;
				bot_confirm = 0;
				nextState = 5'd0;
			end
		endcase
	end
endmodule
module LSFR0 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b1111;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR1 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b0011;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR2 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b1101;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR3 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b1100;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR4 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b1001;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR5 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b0011;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
module LSFR6 (
	reset,
	clock,
	randomOut
);
	input wire reset;
	input wire clock;
	output wire randomOut;
	reg [3:0] inputFF;
	reg [3:0] outputFF;
	assign randomOut = outputFF[3];
	always @(posedge clock)
		if (reset)
			outputFF <= 4'b0101;
		else
			outputFF <= inputFF;
	always @(*) begin
		inputFF[0] = outputFF[3] ^ outputFF[2];
		inputFF[1] = outputFF[0];
		inputFF[2] = outputFF[1];
		inputFF[3] = outputFF[2];
	end
endmodule
`default_nettype none
module Token (
	row,
	col,
	is_token,
	tokenRow,
	tokenCol
);
	input wire [8:0] row;
	input wire [9:0] col;
	output wire is_token;
	output wire [5:0] tokenRow;
	output wire [6:0] tokenCol;
	wire is_token_0;
	wire is_token_1;
	wire is_token_2;
	wire is_token_3;
	wire is_token_4;
	wire is_token_5;
	wire is_token_6;
	wire is_token_0_row;
	wire is_token_1_row;
	wire is_token_2_row;
	wire is_token_3_row;
	wire is_token_4_row;
	wire is_token_5_row;
	wire is_token_6_row;
	wire is_token_0_col;
	wire is_token_1_col;
	wire is_token_2_col;
	wire is_token_3_col;
	wire is_token_4_col;
	wire is_token_5_col;
	wire is_token_6_col;
	wire is_token_row_0;
	assign is_token_row_0 = (((((is_token_0 | is_token_1) | is_token_2) | is_token_3) | is_token_4) | is_token_5) | is_token_6;
	wire is_token_7;
	wire is_token_8;
	wire is_token_9;
	wire is_token_10;
	wire is_token_11;
	wire is_token_12;
	wire is_token_13;
	wire is_token_7_row;
	wire is_token_8_row;
	wire is_token_9_row;
	wire is_token_10_row;
	wire is_token_11_row;
	wire is_token_12_row;
	wire is_token_13_row;
	wire is_token_7_col;
	wire is_token_8_col;
	wire is_token_9_col;
	wire is_token_10_col;
	wire is_token_11_col;
	wire is_token_12_col;
	wire is_token_13_col;
	wire is_token_row_1;
	assign is_token_row_1 = (((((is_token_7 | is_token_8) | is_token_9) | is_token_10) | is_token_11) | is_token_12) | is_token_13;
	wire is_token_14;
	wire is_token_15;
	wire is_token_16;
	wire is_token_17;
	wire is_token_18;
	wire is_token_19;
	wire is_token_20;
	wire is_token_14_row;
	wire is_token_15_row;
	wire is_token_16_row;
	wire is_token_17_row;
	wire is_token_18_row;
	wire is_token_19_row;
	wire is_token_20_row;
	wire is_token_14_col;
	wire is_token_15_col;
	wire is_token_16_col;
	wire is_token_17_col;
	wire is_token_18_col;
	wire is_token_19_col;
	wire is_token_20_col;
	wire is_token_row_2;
	assign is_token_row_2 = (((((is_token_14 | is_token_15) | is_token_16) | is_token_17) | is_token_18) | is_token_19) | is_token_20;
	wire is_token_21;
	wire is_token_22;
	wire is_token_23;
	wire is_token_24;
	wire is_token_25;
	wire is_token_26;
	wire is_token_27;
	wire is_token_21_row;
	wire is_token_22_row;
	wire is_token_23_row;
	wire is_token_24_row;
	wire is_token_25_row;
	wire is_token_26_row;
	wire is_token_27_row;
	wire is_token_21_col;
	wire is_token_22_col;
	wire is_token_23_col;
	wire is_token_24_col;
	wire is_token_25_col;
	wire is_token_26_col;
	wire is_token_27_col;
	wire is_token_row_3;
	assign is_token_row_3 = (((((is_token_21 | is_token_22) | is_token_23) | is_token_24) | is_token_25) | is_token_26) | is_token_27;
	wire is_token_28;
	wire is_token_29;
	wire is_token_30;
	wire is_token_31;
	wire is_token_32;
	wire is_token_33;
	wire is_token_34;
	wire is_token_28_row;
	wire is_token_29_row;
	wire is_token_30_row;
	wire is_token_31_row;
	wire is_token_32_row;
	wire is_token_33_row;
	wire is_token_34_row;
	wire is_token_28_col;
	wire is_token_29_col;
	wire is_token_30_col;
	wire is_token_31_col;
	wire is_token_32_col;
	wire is_token_33_col;
	wire is_token_34_col;
	wire is_token_row_4;
	assign is_token_row_4 = (((((is_token_28 | is_token_29) | is_token_30) | is_token_31) | is_token_32) | is_token_33) | is_token_34;
	wire is_token_35;
	wire is_token_36;
	wire is_token_37;
	wire is_token_38;
	wire is_token_39;
	wire is_token_40;
	wire is_token_41;
	wire is_token_35_row;
	wire is_token_36_row;
	wire is_token_37_row;
	wire is_token_38_row;
	wire is_token_39_row;
	wire is_token_40_row;
	wire is_token_41_row;
	wire is_token_35_col;
	wire is_token_36_col;
	wire is_token_37_col;
	wire is_token_38_col;
	wire is_token_39_col;
	wire is_token_40_col;
	wire is_token_41_col;
	wire is_token_row_5;
	assign is_token_row_5 = (((((is_token_35 | is_token_36) | is_token_37) | is_token_38) | is_token_39) | is_token_40) | is_token_41;
	assign is_token = ((((is_token_row_0 | is_token_row_1) | is_token_row_2) | is_token_row_3) | is_token_row_4) | is_token_row_5;
	assign tokenRow = {is_token_row_0, is_token_row_1, is_token_row_2, is_token_row_3, is_token_row_4, is_token_row_5};
	wire is_token_col_0;
	wire is_token_col_1;
	wire is_token_col_2;
	wire is_token_col_3;
	wire is_token_col_4;
	wire is_token_col_5;
	wire is_token_col_6;
	assign is_token_col_0 = ((((is_token_0 | is_token_7) | is_token_14) | is_token_21) | is_token_28) | is_token_35;
	assign is_token_col_1 = ((((is_token_1 | is_token_8) | is_token_15) | is_token_22) | is_token_29) | is_token_36;
	assign is_token_col_2 = ((((is_token_2 | is_token_9) | is_token_16) | is_token_23) | is_token_30) | is_token_37;
	assign is_token_col_3 = ((((is_token_3 | is_token_10) | is_token_17) | is_token_24) | is_token_31) | is_token_38;
	assign is_token_col_4 = ((((is_token_4 | is_token_11) | is_token_18) | is_token_25) | is_token_32) | is_token_39;
	assign is_token_col_5 = ((((is_token_5 | is_token_12) | is_token_19) | is_token_26) | is_token_33) | is_token_40;
	assign is_token_col_6 = ((((is_token_6 | is_token_13) | is_token_20) | is_token_27) | is_token_34) | is_token_41;
	assign tokenCol = {is_token_col_0, is_token_col_1, is_token_col_2, is_token_col_3, is_token_col_4, is_token_col_5, is_token_col_6};
	RangeCheck #(.w(9)) level_0_V_0(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_0_row)
	);
	RangeCheck #(.w(10)) level_0_H_0(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_0_col)
	);
	assign is_token_0 = is_token_0_col & is_token_0_row;
	RangeCheck #(.w(9)) level_0_V_1(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_1_row)
	);
	RangeCheck #(.w(10)) level_1_H_1(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_1_col)
	);
	assign is_token_1 = is_token_1_col & is_token_1_row;
	RangeCheck #(.w(9)) level_0_V_2(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_2_row)
	);
	RangeCheck #(.w(10)) level_2_H_2(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_2_col)
	);
	assign is_token_2 = is_token_2_col & is_token_2_row;
	RangeCheck #(.w(9)) level_0_V_3(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_3_row)
	);
	RangeCheck #(.w(10)) level_3_H_3(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_3_col)
	);
	assign is_token_3 = is_token_3_col & is_token_3_row;
	RangeCheck #(.w(9)) level_0_V_4(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_4_row)
	);
	RangeCheck #(.w(10)) level_4_H_4(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_4_col)
	);
	assign is_token_4 = is_token_4_col & is_token_4_row;
	RangeCheck #(.w(9)) level_0_V_5(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_5_row)
	);
	RangeCheck #(.w(10)) level_5_H_5(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_5_col)
	);
	assign is_token_5 = is_token_5_col & is_token_5_row;
	RangeCheck #(.w(9)) level_0_V_6(
		.val(row),
		.high(9'd74),
		.low(9'd30),
		.is_between(is_token_6_row)
	);
	RangeCheck #(.w(10)) level_6_H_6(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_6_col)
	);
	assign is_token_6 = is_token_6_col & is_token_6_row;
	RangeCheck #(.w(9)) level_1_V_7(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_7_row)
	);
	RangeCheck #(.w(10)) level_0_H_7(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_7_col)
	);
	assign is_token_7 = is_token_7_col & is_token_7_row;
	RangeCheck #(.w(9)) level_1_V_8(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_8_row)
	);
	RangeCheck #(.w(10)) level_1_H_8(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_8_col)
	);
	assign is_token_8 = is_token_8_col & is_token_8_row;
	RangeCheck #(.w(9)) level_1_V_9(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_9_row)
	);
	RangeCheck #(.w(10)) level_2_H_9(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_9_col)
	);
	assign is_token_9 = is_token_9_col & is_token_9_row;
	RangeCheck #(.w(9)) level_1_V_10(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_10_row)
	);
	RangeCheck #(.w(10)) level_3_H_10(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_10_col)
	);
	assign is_token_10 = is_token_10_col & is_token_10_row;
	RangeCheck #(.w(9)) level_1_V_11(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_11_row)
	);
	RangeCheck #(.w(10)) level_4_H_11(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_11_col)
	);
	assign is_token_11 = is_token_11_col & is_token_11_row;
	RangeCheck #(.w(9)) level_1_V_12(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_12_row)
	);
	RangeCheck #(.w(10)) level_5_H_12(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_12_col)
	);
	assign is_token_12 = is_token_12_col & is_token_12_row;
	RangeCheck #(.w(9)) level_1_V_13(
		.val(row),
		.high(9'd149),
		.low(9'd105),
		.is_between(is_token_13_row)
	);
	RangeCheck #(.w(10)) level_6_H_13(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_13_col)
	);
	assign is_token_13 = is_token_13_col & is_token_13_row;
	RangeCheck #(.w(9)) level_2_V_14(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_14_row)
	);
	RangeCheck #(.w(10)) level_0_H_14(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_14_col)
	);
	assign is_token_14 = is_token_14_col & is_token_14_row;
	RangeCheck #(.w(9)) level_2_V_15(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_15_row)
	);
	RangeCheck #(.w(10)) level_1_H_15(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_15_col)
	);
	assign is_token_15 = is_token_15_col & is_token_15_row;
	RangeCheck #(.w(9)) level_2_V_16(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_16_row)
	);
	RangeCheck #(.w(10)) level_2_H_16(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_16_col)
	);
	assign is_token_16 = is_token_16_col & is_token_16_row;
	RangeCheck #(.w(9)) level_2_V_17(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_17_row)
	);
	RangeCheck #(.w(10)) level_3_H_17(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_17_col)
	);
	assign is_token_17 = is_token_17_col & is_token_17_row;
	RangeCheck #(.w(9)) level_2_V_18(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_18_row)
	);
	RangeCheck #(.w(10)) level_4_H_18(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_18_col)
	);
	assign is_token_18 = is_token_18_col & is_token_18_row;
	RangeCheck #(.w(9)) level_2_V_19(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_19_row)
	);
	RangeCheck #(.w(10)) level_5_H_19(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_19_col)
	);
	assign is_token_19 = is_token_19_col & is_token_19_row;
	RangeCheck #(.w(9)) level_2_V_20(
		.val(row),
		.high(9'd224),
		.low(9'd180),
		.is_between(is_token_20_row)
	);
	RangeCheck #(.w(10)) level_6_H_20(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_20_col)
	);
	assign is_token_20 = is_token_20_col & is_token_20_row;
	RangeCheck #(.w(9)) level_3_V_21(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_21_row)
	);
	RangeCheck #(.w(10)) level_0_H_21(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_21_col)
	);
	assign is_token_21 = is_token_21_col & is_token_21_row;
	RangeCheck #(.w(9)) level_3_V_22(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_22_row)
	);
	RangeCheck #(.w(10)) level_1_H_22(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_22_col)
	);
	assign is_token_22 = is_token_22_col & is_token_22_row;
	RangeCheck #(.w(9)) level_3_V_23(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_23_row)
	);
	RangeCheck #(.w(10)) level_2_H_23(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_23_col)
	);
	assign is_token_23 = is_token_23_col & is_token_23_row;
	RangeCheck #(.w(9)) level_3_V_24(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_24_row)
	);
	RangeCheck #(.w(10)) level_3_H_24(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_24_col)
	);
	assign is_token_24 = is_token_24_col & is_token_24_row;
	RangeCheck #(.w(9)) level_3_V_25(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_25_row)
	);
	RangeCheck #(.w(10)) level_4_H_25(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_25_col)
	);
	assign is_token_25 = is_token_25_col & is_token_25_row;
	RangeCheck #(.w(9)) level_3_V_26(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_26_row)
	);
	RangeCheck #(.w(10)) level_5_H_26(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_26_col)
	);
	assign is_token_26 = is_token_26_col & is_token_26_row;
	RangeCheck #(.w(9)) level_3_V_27(
		.val(row),
		.high(9'd299),
		.low(9'd255),
		.is_between(is_token_27_row)
	);
	RangeCheck #(.w(10)) level_6_H_27(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_27_col)
	);
	assign is_token_27 = is_token_27_col & is_token_27_row;
	RangeCheck #(.w(9)) level_4_V_28(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_28_row)
	);
	RangeCheck #(.w(10)) level_0_H_28(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_28_col)
	);
	assign is_token_28 = is_token_28_col & is_token_28_row;
	RangeCheck #(.w(9)) level_4_V_29(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_29_row)
	);
	RangeCheck #(.w(10)) level_1_H_29(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_29_col)
	);
	assign is_token_29 = is_token_29_col & is_token_29_row;
	RangeCheck #(.w(9)) level_4_V_30(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_30_row)
	);
	RangeCheck #(.w(10)) level_2_H_30(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_30_col)
	);
	assign is_token_30 = is_token_30_col & is_token_30_row;
	RangeCheck #(.w(9)) level_4_V_31(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_31_row)
	);
	RangeCheck #(.w(10)) level_3_H_31(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_31_col)
	);
	assign is_token_31 = is_token_31_col & is_token_31_row;
	RangeCheck #(.w(9)) level_4_V_32(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_32_row)
	);
	RangeCheck #(.w(10)) level_4_H_32(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_32_col)
	);
	assign is_token_32 = is_token_32_col & is_token_32_row;
	RangeCheck #(.w(9)) level_4_V_33(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_33_row)
	);
	RangeCheck #(.w(10)) level_5_H_33(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_33_col)
	);
	assign is_token_33 = is_token_33_col & is_token_33_row;
	RangeCheck #(.w(9)) level_4_V_34(
		.val(row),
		.high(9'd374),
		.low(9'd330),
		.is_between(is_token_34_row)
	);
	RangeCheck #(.w(10)) level_6_H_34(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_34_col)
	);
	assign is_token_34 = is_token_34_col & is_token_34_row;
	RangeCheck #(.w(9)) level_5_V_35(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_35_row)
	);
	RangeCheck #(.w(10)) level_0_H_35(
		.val(col),
		.high(10'd84),
		.low(10'd45),
		.is_between(is_token_35_col)
	);
	assign is_token_35 = is_token_35_col & is_token_35_row;
	RangeCheck #(.w(9)) level_5_V_36(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_36_row)
	);
	RangeCheck #(.w(10)) level_1_H_36(
		.val(col),
		.high(10'd169),
		.low(10'd130),
		.is_between(is_token_36_col)
	);
	assign is_token_36 = is_token_36_col & is_token_36_row;
	RangeCheck #(.w(9)) level_5_V_37(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_37_row)
	);
	RangeCheck #(.w(10)) level_2_H_37(
		.val(col),
		.high(10'd254),
		.low(10'd215),
		.is_between(is_token_37_col)
	);
	assign is_token_37 = is_token_37_col & is_token_37_row;
	RangeCheck #(.w(9)) level_5_V_38(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_38_row)
	);
	RangeCheck #(.w(10)) level_3_H_38(
		.val(col),
		.high(10'd339),
		.low(10'd300),
		.is_between(is_token_38_col)
	);
	assign is_token_38 = is_token_38_col & is_token_38_row;
	RangeCheck #(.w(9)) level_5_V_39(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_39_row)
	);
	RangeCheck #(.w(10)) level_4_H_39(
		.val(col),
		.high(10'd424),
		.low(10'd385),
		.is_between(is_token_39_col)
	);
	assign is_token_39 = is_token_39_col & is_token_39_row;
	RangeCheck #(.w(9)) level_5_V_40(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_40_row)
	);
	RangeCheck #(.w(10)) level_5_H_40(
		.val(col),
		.high(10'd509),
		.low(10'd470),
		.is_between(is_token_40_col)
	);
	assign is_token_40 = is_token_40_col & is_token_40_row;
	RangeCheck #(.w(9)) level_5_V_41(
		.val(row),
		.high(9'd449),
		.low(9'd405),
		.is_between(is_token_41_row)
	);
	RangeCheck #(.w(10)) level_6_H_41(
		.val(col),
		.high(10'd594),
		.low(10'd555),
		.is_between(is_token_41_col)
	);
	assign is_token_41 = is_token_41_col & is_token_41_row;
endmodule
`default_nettype none
module RangeCheck (
	val,
	high,
	low,
	is_between
);
	parameter w = 8;
	input wire [w - 1:0] val;
	input wire [w - 1:0] high;
	input wire [w - 1:0] low;
	output reg is_between;
	always @(*) is_between = ((low <= val) && (high >= val) ? 1 : 0);
endmodule
module Counter (
	en,
	clear,
	load,
	up,
	clock,
	D,
	Q
);
	parameter WIDTH = 8;
	input wire en;
	input wire clear;
	input wire load;
	input wire up;
	input wire clock;
	input wire [WIDTH - 1:0] D;
	output reg [WIDTH - 1:0] Q;
	always @(posedge clock)
		if (clear)
			Q <= 1'sb0;
		else if (load)
			Q <= D;
		else if (en) begin
			if (up)
				Q <= Q + 1;
			else
				Q <= Q - 1;
		end
endmodule
`default_nettype none
module TopChip (
	inputMoves,
	inputConfirm,
	inputSwitchPlayer,
	inputSwitchPVP,
	inputNewGame,
	inputChangeDebug,
	outputs,
	clock,
	reset
);
	input wire [6:0] inputMoves;
	input wire inputConfirm;
	input wire inputSwitchPlayer;
	input wire inputSwitchPVP;
	input wire inputNewGame;
	input wire inputChangeDebug;
	output wire [11:0] outputs;
	input wire clock;
	input wire reset;
	reg [6:0] inputMovesHalf;
	reg [6:0] inputMovesSync;
	reg inputConfirmHalf;
	reg inputConfirmSync;
	reg inputSwitchPlayerHalf;
	reg inputSwitchPlayerSync;
	reg inputSwitchPVPHalf;
	reg inputSwitchPVPSync;
	reg inputNewGameHalf;
	reg inputNewGameSync;
	reg [1:0] inputChangeDebugHalf;
	reg [1:0] inputChangeDebugSync;
	wire HS;
	wire VS;
	wire blank;
	wire [8:0] rowFromVGA;
	wire [9:0] colFromVGA;
	wire [8:0] rowToModule;
	wire [9:0] colToModule;
	wire is_board;
	wire is_token;
	wire [1:0] VGA_Red;
	wire [1:0] VGA_Green;
	wire [1:0] VGA_Blue;
	wire [83:0] tokens;
	wire [6:0] bot_input;
	wire bot_confirm;
	wire [6:0] player_2_input;
	wire player_2_confirm;
	wire [5:0] tokenRow;
	wire [6:0] tokenCol;
	reg debounceCountEn;
	reg debounceClear;
	reg [22:0] debounceCount;
	reg [22:0] debounceLimit = 23'd6250000;
	assign rowToModule = rowFromVGA;
	assign colToModule = colFromVGA;
	always @(posedge clock) begin
		inputMovesSync <= inputMovesHalf;
		inputMovesHalf <= inputMoves;
		inputConfirmSync <= inputConfirmHalf;
		inputConfirmHalf <= inputConfirm;
		inputSwitchPlayerSync <= inputSwitchPlayerHalf;
		inputSwitchPlayerHalf <= inputSwitchPlayer;
		inputSwitchPVPSync <= inputSwitchPVPHalf;
		inputSwitchPVPHalf <= inputSwitchPVP;
		inputNewGameSync <= inputNewGameHalf;
		inputNewGameHalf <= inputNewGame;
		inputChangeDebugSync <= inputChangeDebugHalf;
		inputChangeDebugHalf <= inputChangeDebug;
	end
	reg inputConfirmLimited;
	reg [1:0] currStateConfirm;
	reg [1:0] nextStateConfirm;
	always @(posedge clock)
		if (reset) begin
			currStateConfirm <= 2'd2;
			debounceCount <= 0;
		end
		else begin
			currStateConfirm <= nextStateConfirm;
			if (debounceCountEn)
				debounceCount <= debounceCount + 23'd1;
			else if (debounceClear)
				debounceCount <= 23'd0;
		end
	always @(*) begin
		inputConfirmLimited = 0;
		debounceCountEn = 0;
		case (currStateConfirm)
			2'd0: begin
				inputConfirmLimited = 1;
				nextStateConfirm = 2'd1;
				debounceCountEn = 0;
				debounceClear = 1;
			end
			2'd2: begin
				inputConfirmLimited = 0;
				debounceCountEn = 0;
				debounceClear = 1;
				if (inputConfirmSync)
					nextStateConfirm = 2'd0;
				else
					nextStateConfirm = 2'd2;
			end
			2'd1: begin
				inputConfirmLimited = 0;
				debounceCountEn = 1;
				if (~inputConfirmSync && (debounceCount >= debounceLimit))
					nextStateConfirm = 2'd2;
				else
					nextStateConfirm = 2'd1;
			end
			default: begin
				inputConfirmLimited = 0;
				debounceCountEn = 0;
				debounceClear = 1;
				nextStateConfirm = 2'd2;
			end
		endcase
	end
	assign player_2_input = (inputSwitchPVPSync ? inputMovesSync : bot_input);
	assign player_2_confirm = (inputSwitchPVPSync ? inputConfirmLimited : bot_confirm);
	assign outputs[0] = VS;
	assign outputs[1] = HS;
	assign outputs[2] = blank;
	assign outputs[4] = VGA_Red[1];
	assign outputs[5] = VGA_Red[0];
	assign outputs[6] = VGA_Green[1];
	assign outputs[7] = VGA_Green[0];
	assign outputs[8] = VGA_Blue[1];
	assign outputs[9] = VGA_Blue[0];
	vga vga(
		.clk(clock),
		.rst(reset),
		.hsync(HS),
		.vsync(VS),
		.valid(blank),
		.v_idx(rowFromVGA),
		.h_idx(colFromVGA)
	);
	Board board(
		.row(rowToModule),
		.col(colToModule),
		.is_board(is_board)
	);
	Token token(
		.row(rowToModule),
		.col(colToModule),
		.is_token(is_token),
		.tokenRow(tokenRow),
		.tokenCol(tokenCol)
	);
	Colors colors(
		.is_board(is_board),
		.is_token(is_token),
		.tokens(tokens),
		.red(VGA_Red),
		.blue(VGA_Blue),
		.green(VGA_Green),
		.clock(clock),
		.reset(reset),
		.tokenRow(tokenRow),
		.tokenCol(tokenCol)
	);
	Ownership owner(
		.player_1_input(inputMovesSync),
		.player_1_confirm(inputConfirmLimited),
		.player_2_input(player_2_input),
		.player_2_confirm(player_2_confirm),
		.switchTurn(inputSwitchPlayerSync),
		.clock(clock),
		.reset(reset),
		.tokens(tokens),
		.newGame(inputNewGameSync)
	);
	PvE pve(
		.clock(clock),
		.reset(reset),
		.tokens(tokens),
		.bot_turn(inputSwitchPlayerSync),
		.bot_move(bot_input),
		.bot_confirm(bot_confirm)
	);
endmodule
module Colors (
	is_board,
	is_token,
	clock,
	reset,
	tokens,
	red,
	blue,
	green,
	tokenRow,
	tokenCol
);
	input wire is_board;
	input wire is_token;
	input wire clock;
	input wire reset;
	input wire [83:0] tokens;
	output reg [1:0] red;
	output reg [1:0] blue;
	output reg [1:0] green;
	input wire [5:0] tokenRow;
	input wire [6:0] tokenCol;
	wire is_player_1;
	wire is_player_2;
	reg [5:0] currentTokenRow;
	reg [6:0] currentTokenCol;
	always @(*)
		case (tokenRow)
			6'b100000: currentTokenRow = 6'd0;
			6'b010000: currentTokenRow = 6'd1;
			6'b001000: currentTokenRow = 6'd2;
			6'b000100: currentTokenRow = 6'd3;
			6'b000010: currentTokenRow = 6'd4;
			6'b000001: currentTokenRow = 6'd5;
			default: currentTokenRow = 6'd0;
		endcase
	always @(*)
		case (tokenCol)
			7'b1000000: currentTokenCol = 7'd0;
			7'b0100000: currentTokenCol = 7'd1;
			7'b0010000: currentTokenCol = 7'd2;
			7'b0001000: currentTokenCol = 7'd3;
			7'b0000100: currentTokenCol = 7'd4;
			7'b0000010: currentTokenCol = 7'd5;
			7'b0000001: currentTokenCol = 7'd6;
			default: currentTokenCol = 7'd0;
		endcase
	assign is_player_1 = (tokens[(((5 - currentTokenRow) * 7) + (6 - currentTokenCol)) * 2+:2] == 2'b01 ? 1 : 0);
	assign is_player_2 = (tokens[(((5 - currentTokenRow) * 7) + (6 - currentTokenCol)) * 2+:2] == 2'b10 ? 1 : 0);
	always @(*) begin
		red = 2'b00;
		green = 2'b00;
		blue = 2'b00;
		if (is_board) begin
			red = 2'b00;
			green = 2'b00;
			blue = 2'b11;
		end
		else if (is_token && is_player_1) begin
			red = 2'b11;
			green = 2'b00;
			blue = 2'b00;
		end
		else if (is_token && is_player_2) begin
			red = 2'b11;
			green = 2'b11;
			blue = 2'b00;
		end
		else if (is_token) begin
			red = 2'b00;
			green = 2'b00;
			blue = 2'b00;
		end
	end
endmodule
module vga (
	v_idx,
	h_idx,
	valid,
	vsync,
	hsync,
	rst,
	clk
);
	output reg [9:0] v_idx;
	output reg [9:0] h_idx;
	output wire valid;
	output reg vsync;
	output reg hsync;
	input wire rst;
	input wire clk;
	assign valid = (v_idx < 480) && (h_idx < 640);
	always @(posedge clk)
		if (rst) begin
			v_idx <= 0;
			h_idx <= 0;
			vsync <= 1;
			hsync <= 1;
		end
		else begin
			hsync <= 1;
			h_idx <= h_idx + 1;
			if ((h_idx >= 656) && (h_idx < 752))
				hsync <= 1'b0;
			if (h_idx >= 800) begin
				h_idx <= 0;
				v_idx <= v_idx + 1;
				if ((v_idx >= 490) && (v_idx < 492))
					vsync <= 0;
				else
					vsync <= 1;
				if (v_idx >= 525)
					v_idx <= 0;
			end
		end
endmodule
