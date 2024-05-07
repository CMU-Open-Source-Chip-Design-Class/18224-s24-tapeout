`default_nettype none

module Token
(input logic [8:0] row, input logic [9:0] col,
output logic is_token, output logic [5:0] tokenRow,
output logic [6:0] tokenCol);

  //might be able to take advantage of the repeated values to send the current
  //token row and token column that the vga row and vga col is one

  logic is_token_0,is_token_1,is_token_2,is_token_3,is_token_4,is_token_5,
  is_token_6;
  logic is_token_0_row,is_token_1_row,is_token_2_row,is_token_3_row,
  is_token_4_row,is_token_5_row,is_token_6_row;
  logic is_token_0_col,is_token_1_col,is_token_2_col,is_token_3_col,
  is_token_4_col,is_token_5_col,is_token_6_col;
  logic is_token_row_0;
  assign is_token_row_0 = is_token_0 | is_token_1 | is_token_2 | is_token_3 |
  is_token_4 | is_token_5 | is_token_6;

  logic is_token_7,is_token_8,is_token_9,is_token_10,is_token_11,is_token_12,
  is_token_13;
  logic is_token_7_row,is_token_8_row,is_token_9_row,is_token_10_row,
  is_token_11_row,is_token_12_row,is_token_13_row;
  logic is_token_7_col,is_token_8_col,is_token_9_col,is_token_10_col,
  is_token_11_col,is_token_12_col,is_token_13_col;
  logic is_token_row_1;
  assign is_token_row_1 = is_token_7 | is_token_8 | is_token_9 | is_token_10 |
  is_token_11 | is_token_12 | is_token_13;

  logic is_token_14,is_token_15,is_token_16,is_token_17,is_token_18,is_token_19,
  is_token_20;
  logic is_token_14_row,is_token_15_row,is_token_16_row,is_token_17_row,
  is_token_18_row,is_token_19_row,is_token_20_row;
  logic is_token_14_col,is_token_15_col,is_token_16_col,is_token_17_col,
  is_token_18_col,is_token_19_col,is_token_20_col;
  logic is_token_row_2;
  assign is_token_row_2 = is_token_14 | is_token_15 | is_token_16 | is_token_17 | 
  is_token_18 | is_token_19 | is_token_20;

  logic is_token_21,is_token_22,is_token_23,is_token_24,is_token_25,is_token_26,
  is_token_27;
  logic is_token_21_row,is_token_22_row,is_token_23_row,is_token_24_row,
  is_token_25_row,is_token_26_row,is_token_27_row;
  logic is_token_21_col,is_token_22_col,is_token_23_col,is_token_24_col,
  is_token_25_col,is_token_26_col,is_token_27_col;
  logic is_token_row_3;
  assign is_token_row_3 = is_token_21 | is_token_22 | is_token_23 | is_token_24 |
  is_token_25 | is_token_26 | is_token_27;

  logic is_token_28,is_token_29,is_token_30,is_token_31,is_token_32,is_token_33,
  is_token_34;
  logic is_token_28_row,is_token_29_row,is_token_30_row,is_token_31_row,
  is_token_32_row,is_token_33_row,is_token_34_row;
  logic is_token_28_col,is_token_29_col,is_token_30_col,is_token_31_col,
  is_token_32_col,is_token_33_col,is_token_34_col;
  logic is_token_row_4;
  assign is_token_row_4 = is_token_28 | is_token_29 | is_token_30 | is_token_31 |
  is_token_32 | is_token_33 | is_token_34;

  logic is_token_35,is_token_36,is_token_37,is_token_38,is_token_39,is_token_40,
  is_token_41;
  logic is_token_35_row,is_token_36_row,is_token_37_row,is_token_38_row,
  is_token_39_row,is_token_40_row,is_token_41_row;
  logic is_token_35_col,is_token_36_col,is_token_37_col,is_token_38_col,
  is_token_39_col,is_token_40_col,is_token_41_col;
  logic is_token_row_5;
  assign is_token_row_5 = is_token_35 | is_token_36 | is_token_37 | is_token_38 | 
  is_token_39 | is_token_40 | is_token_41;

  assign is_token = is_token_row_0 | is_token_row_1 | is_token_row_2 | 
  is_token_row_3 | is_token_row_4 | is_token_row_5;

  assign tokenRow = {is_token_row_0, is_token_row_1,is_token_row_2,
  is_token_row_3,is_token_row_4,is_token_row_5};

  logic is_token_col_0, is_token_col_1,is_token_col_2,is_token_col_3,
  is_token_col_4,is_token_col_5,is_token_col_6;

  assign is_token_col_0 = is_token_0 | is_token_7 | is_token_14 | is_token_21 |
  is_token_28 | is_token_35;
  assign is_token_col_1 = is_token_1 | is_token_8 | is_token_15 | is_token_22 |
  is_token_29 | is_token_36;
  assign is_token_col_2 = is_token_2 | is_token_9 | is_token_16 | is_token_23 |
  is_token_30 | is_token_37;
  assign is_token_col_3 = is_token_3 | is_token_10 | is_token_17 | is_token_24 |
  is_token_31 | is_token_38;
  assign is_token_col_4 = is_token_4 | is_token_11 | is_token_18 | is_token_25 |
  is_token_32 | is_token_39;
  assign is_token_col_5 = is_token_5 | is_token_12 | is_token_19 | is_token_26 |
  is_token_33 | is_token_40;
  assign is_token_col_6 = is_token_6 | is_token_13 | is_token_20 | is_token_27 |
  is_token_34 | is_token_41;


  assign tokenCol = {is_token_col_0,is_token_col_1,is_token_col_2,
  is_token_col_3,is_token_col_4,is_token_col_5,is_token_col_6};

  //Row 0
  RangeCheck #(.w(9)) level_0_V_0 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_0_row));
  RangeCheck #(.w(10)) level_0_H_0 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_0_col));
  assign is_token_0 = is_token_0_col & is_token_0_row;

  RangeCheck #(.w(9)) level_0_V_1 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_1_row));
  RangeCheck #(.w(10)) level_1_H_1 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_1_col));
  assign is_token_1 = is_token_1_col & is_token_1_row;

  RangeCheck #(.w(9)) level_0_V_2 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_2_row));
  RangeCheck #(.w(10)) level_2_H_2 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_2_col));
  assign is_token_2 = is_token_2_col & is_token_2_row;

  RangeCheck #(.w(9)) level_0_V_3 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_3_row));
  RangeCheck #(.w(10)) level_3_H_3 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_3_col));
  assign is_token_3 = is_token_3_col & is_token_3_row;

  RangeCheck #(.w(9)) level_0_V_4 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_4_row));
  RangeCheck #(.w(10)) level_4_H_4 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_4_col));
  assign is_token_4 = is_token_4_col & is_token_4_row;

  RangeCheck #(.w(9)) level_0_V_5 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_5_row));
  RangeCheck #(.w(10)) level_5_H_5 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_5_col));
  assign is_token_5 = is_token_5_col & is_token_5_row;

  RangeCheck #(.w(9)) level_0_V_6 (.val(row), .high(9'd74), .low(9'd30),
   .is_between(is_token_6_row));
  RangeCheck #(.w(10)) level_6_H_6 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_6_col));
  assign is_token_6 = is_token_6_col & is_token_6_row;

  //Row 1
  RangeCheck #(.w(9)) level_1_V_7 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_7_row));
  RangeCheck #(.w(10)) level_0_H_7 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_7_col));
  assign is_token_7 = is_token_7_col & is_token_7_row;

  RangeCheck #(.w(9)) level_1_V_8 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_8_row));
  RangeCheck #(.w(10)) level_1_H_8 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_8_col));
  assign is_token_8 = is_token_8_col & is_token_8_row;

  RangeCheck #(.w(9)) level_1_V_9 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_9_row));
  RangeCheck #(.w(10)) level_2_H_9 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_9_col));
  assign is_token_9 = is_token_9_col & is_token_9_row;

  RangeCheck #(.w(9)) level_1_V_10 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_10_row));
  RangeCheck #(.w(10)) level_3_H_10 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_10_col));
  assign is_token_10 = is_token_10_col & is_token_10_row;

  RangeCheck #(.w(9)) level_1_V_11 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_11_row));
  RangeCheck #(.w(10)) level_4_H_11 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_11_col));
  assign is_token_11 = is_token_11_col & is_token_11_row;

  RangeCheck #(.w(9)) level_1_V_12 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_12_row));
  RangeCheck #(.w(10)) level_5_H_12 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_12_col));
  assign is_token_12 = is_token_12_col & is_token_12_row;

  RangeCheck #(.w(9)) level_1_V_13 (.val(row), .high(9'd149), .low(9'd105),
   .is_between(is_token_13_row));
  RangeCheck #(.w(10)) level_6_H_13 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_13_col));
  assign is_token_13 = is_token_13_col & is_token_13_row;

  //Row 2
  RangeCheck #(.w(9)) level_2_V_14 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_14_row));
  RangeCheck #(.w(10)) level_0_H_14 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_14_col));
  assign is_token_14 = is_token_14_col & is_token_14_row;

  RangeCheck #(.w(9)) level_2_V_15 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_15_row));
  RangeCheck #(.w(10)) level_1_H_15 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_15_col));
  assign is_token_15 = is_token_15_col & is_token_15_row;

  RangeCheck #(.w(9)) level_2_V_16 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_16_row));
  RangeCheck #(.w(10)) level_2_H_16 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_16_col));
  assign is_token_16 = is_token_16_col & is_token_16_row;

  RangeCheck #(.w(9)) level_2_V_17 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_17_row));
  RangeCheck #(.w(10)) level_3_H_17 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_17_col));
  assign is_token_17 = is_token_17_col & is_token_17_row;

  RangeCheck #(.w(9)) level_2_V_18 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_18_row));
  RangeCheck #(.w(10)) level_4_H_18 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_18_col));
  assign is_token_18 = is_token_18_col & is_token_18_row;

  RangeCheck #(.w(9)) level_2_V_19 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_19_row));
  RangeCheck #(.w(10)) level_5_H_19 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_19_col));
  assign is_token_19 = is_token_19_col & is_token_19_row;

  RangeCheck #(.w(9)) level_2_V_20 (.val(row), .high(9'd224), .low(9'd180),
   .is_between(is_token_20_row));
  RangeCheck #(.w(10)) level_6_H_20 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_20_col));
  assign is_token_20 = is_token_20_col & is_token_20_row;

  //Row 3
  RangeCheck #(.w(9)) level_3_V_21 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_21_row));
  RangeCheck #(.w(10)) level_0_H_21 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_21_col));
  assign is_token_21 = is_token_21_col & is_token_21_row;

  RangeCheck #(.w(9)) level_3_V_22 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_22_row));
  RangeCheck #(.w(10)) level_1_H_22 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_22_col));
  assign is_token_22 = is_token_22_col & is_token_22_row;

  RangeCheck #(.w(9)) level_3_V_23 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_23_row));
  RangeCheck #(.w(10)) level_2_H_23 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_23_col));
  assign is_token_23 = is_token_23_col & is_token_23_row;

  RangeCheck #(.w(9)) level_3_V_24 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_24_row));
  RangeCheck #(.w(10)) level_3_H_24 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_24_col));
  assign is_token_24 = is_token_24_col & is_token_24_row;

  RangeCheck #(.w(9)) level_3_V_25 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_25_row));
  RangeCheck #(.w(10)) level_4_H_25 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_25_col));
  assign is_token_25 = is_token_25_col & is_token_25_row;

  RangeCheck #(.w(9)) level_3_V_26 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_26_row));
  RangeCheck #(.w(10)) level_5_H_26 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_26_col));
  assign is_token_26 = is_token_26_col & is_token_26_row;

  RangeCheck #(.w(9)) level_3_V_27 (.val(row), .high(9'd299), .low(9'd255),
   .is_between(is_token_27_row));
  RangeCheck #(.w(10)) level_6_H_27 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_27_col));
  assign is_token_27 = is_token_27_col & is_token_27_row;
  
  //Row 4
  RangeCheck #(.w(9)) level_4_V_28 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_28_row));
  RangeCheck #(.w(10)) level_0_H_28 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_28_col));
  assign is_token_28 = is_token_28_col & is_token_28_row;

  RangeCheck #(.w(9)) level_4_V_29 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_29_row));
  RangeCheck #(.w(10)) level_1_H_29 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_29_col));
  assign is_token_29 = is_token_29_col & is_token_29_row;

  RangeCheck #(.w(9)) level_4_V_30 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_30_row));
  RangeCheck #(.w(10)) level_2_H_30 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_30_col));
  assign is_token_30 = is_token_30_col & is_token_30_row;

  RangeCheck #(.w(9)) level_4_V_31 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_31_row));
  RangeCheck #(.w(10)) level_3_H_31 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_31_col));
  assign is_token_31 = is_token_31_col & is_token_31_row;

  RangeCheck #(.w(9)) level_4_V_32 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_32_row));
  RangeCheck #(.w(10)) level_4_H_32 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_32_col));
  assign is_token_32 = is_token_32_col & is_token_32_row;

  RangeCheck #(.w(9)) level_4_V_33 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_33_row));
  RangeCheck #(.w(10)) level_5_H_33 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_33_col));
  assign is_token_33 = is_token_33_col & is_token_33_row;

  RangeCheck #(.w(9)) level_4_V_34 (.val(row), .high(9'd374), .low(9'd330),
   .is_between(is_token_34_row));
  RangeCheck #(.w(10)) level_6_H_34 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_34_col));
  assign is_token_34 = is_token_34_col & is_token_34_row;

  //Row 5
  RangeCheck #(.w(9)) level_5_V_35 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_35_row));
  RangeCheck #(.w(10)) level_0_H_35 (.val(col), .high(10'd84), .low(10'd45),
   .is_between(is_token_35_col));
  assign is_token_35 = is_token_35_col & is_token_35_row;

  RangeCheck #(.w(9)) level_5_V_36 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_36_row));
  RangeCheck #(.w(10)) level_1_H_36 (.val(col), .high(10'd169), .low(10'd130),
   .is_between(is_token_36_col));
  assign is_token_36 = is_token_36_col & is_token_36_row;

  RangeCheck #(.w(9)) level_5_V_37 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_37_row));
  RangeCheck #(.w(10)) level_2_H_37 (.val(col), .high(10'd254), .low(10'd215),
   .is_between(is_token_37_col));
  assign is_token_37 = is_token_37_col & is_token_37_row;

  RangeCheck #(.w(9)) level_5_V_38 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_38_row));
  RangeCheck #(.w(10)) level_3_H_38 (.val(col), .high(10'd339), .low(10'd300),
   .is_between(is_token_38_col));
  assign is_token_38 = is_token_38_col & is_token_38_row;

  RangeCheck #(.w(9)) level_5_V_39 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_39_row));
  RangeCheck #(.w(10)) level_4_H_39 (.val(col), .high(10'd424), .low(10'd385),
   .is_between(is_token_39_col));
  assign is_token_39 = is_token_39_col & is_token_39_row;

  RangeCheck #(.w(9)) level_5_V_40 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_40_row));
  RangeCheck #(.w(10)) level_5_H_40 (.val(col), .high(10'd509), .low(10'd470),
   .is_between(is_token_40_col));
  assign is_token_40 = is_token_40_col & is_token_40_row;

  RangeCheck #(.w(9)) level_5_V_41 (.val(row), .high(9'd449), .low(9'd405),
   .is_between(is_token_41_row));
  RangeCheck #(.w(10)) level_6_H_41 (.val(col), .high(10'd594), .low(10'd555),
   .is_between(is_token_41_col));
  assign is_token_41 = is_token_41_col & is_token_41_row;



endmodule: Token