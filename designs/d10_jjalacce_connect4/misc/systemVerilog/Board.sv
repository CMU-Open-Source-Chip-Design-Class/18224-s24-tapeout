`default_nettype none

module Board
(input logic [8:0] row, input logic [9:0] col,
output is_board);
  logic level_0_H_Between, level_1_H_Between, level_2_H_Between,
  level_3_H_Between, level_4_H_Between, level_5_H_Between, level_6_H_Between;
  logic is_board_H;
  assign is_board_H = level_0_H_Between | level_1_H_Between | level_2_H_Between |
  level_3_H_Between | level_4_H_Between | level_5_H_Between | level_6_H_Between;
  RangeCheck #(.w(9)) level_0_H (.val(row), .high(9'd29), .low(9'd0),
   .is_between(level_0_H_Between));
  RangeCheck #(.w(9)) level_1_H (.val(row), .high(9'd104), .low(9'd75),
   .is_between(level_1_H_Between));
  RangeCheck #(.w(9)) level_2_H (.val(row), .high(9'd179), .low(9'd150),
   .is_between(level_2_H_Between));
  RangeCheck #(.w(9)) level_3_H (.val(row), .high(9'd254), .low(9'd225),
   .is_between(level_3_H_Between));
  RangeCheck #(.w(9)) level_4_H (.val(row), .high(9'd329), .low(9'd300),
   .is_between(level_4_H_Between));
  RangeCheck #(.w(9)) level_5_H (.val(row), .high(9'd404), .low(9'd375),
   .is_between(level_5_H_Between));
  RangeCheck #(.w(9)) level_6_H (.val(row), .high(9'd479), .low(9'd450),
   .is_between(level_6_H_Between));

  logic level_0_V_Between, level_1_V_Between, level_2_V_Between,
  level_3_V_Between, level_4_V_Between, level_5_V_Between, level_6_V_Between,
  level_7_V_Between;
  logic is_board_V;
  assign is_board_V = level_0_V_Between | level_1_V_Between | level_2_V_Between |
  level_3_V_Between | level_4_V_Between | level_5_V_Between | level_6_V_Between |
  level_7_V_Between;
  RangeCheck #(.w(10)) level_0_V (.val(col), .high(10'd44), .low(10'd0),
   .is_between(level_0_V_Between));
  RangeCheck #(.w(10)) level_1_V (.val(col), .high(10'd129), .low(10'd85),
   .is_between(level_1_V_Between));
  RangeCheck #(.w(10)) level_2_V (.val(col), .high(10'd214), .low(10'd170),
   .is_between(level_2_V_Between));
  RangeCheck #(.w(10)) level_3_V (.val(col), .high(10'd299), .low(10'd255),
   .is_between(level_3_V_Between));
  RangeCheck #(.w(10)) level_4_V (.val(col), .high(10'd384), .low(10'd340),
   .is_between(level_4_V_Between));
  RangeCheck #(.w(10)) level_5_V (.val(col), .high(10'd469), .low(10'd425),
   .is_between(level_5_V_Between));
  RangeCheck #(.w(10)) level_6_V (.val(col), .high(10'd554), .low(10'd510),
   .is_between(level_6_V_Between));
  RangeCheck #(.w(10)) level_7_V (.val(col), .high(10'd639), .low(10'd595),
   .is_between(level_7_V_Between));


  assign is_board = is_board_H | is_board_V;



endmodule: Board