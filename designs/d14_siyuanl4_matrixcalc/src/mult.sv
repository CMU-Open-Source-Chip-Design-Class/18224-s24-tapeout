`default_nettype none

module Multiply_Path(input logic [63:0] mat_A, mat_B,
                     input logic clk, rst, mult_en,
                     output logic [159:0] mat_out,
                     output logic finish);
    logic [3:0] mult1_in1, mult1_in2;
    logic [7:0] mult1_out;
    logic [3:0] mult2_in1, mult2_in2;
    logic [7:0] mult2_out;
    logic [3:0] mult3_in1, mult3_in2;
    logic [7:0] mult3_out;
    logic [3:0] mult4_in1, mult4_in2;
    logic [7:0] mult4_out;
    logic [3:0] mult5_in1, mult5_in2;
    logic [7:0] mult5_out;
    logic [3:0] mult6_in1, mult6_in2;
    logic [7:0] mult6_out;
    logic [3:0] mult7_in1, mult7_in2;
    logic [7:0] mult7_out;
    logic [3:0] mult8_in1, mult8_in2;
    logic [7:0] mult8_out;

    logic [7:0] add_in1, add_in2, add_in3, add_in4;
    logic [9:0] add_out;

    logic [7:0] add_in5, add_in6, add_in7, add_in8;
    logic [9:0] add_out2;

    logic layer_1_en, layer_2_en;

    
    Multiplier #(4) mult1(.S(mult1_out),
                          .A(mult1_in1),
                          .B(mult1_in2));
    
    Multiplier #(4) mult2(.S(mult2_out),
                          .A(mult2_in1),
                          .B(mult2_in2));
    
    Multiplier #(4) mult3(.S(mult3_out),
                          .A(mult3_in1),
                          .B(mult3_in2));

    Multiplier #(4) mult4(.S(mult4_out),
                          .A(mult4_in1),
                          .B(mult4_in2));
    
    Multiplier #(4) mult5(.S(mult5_out),
                          .A(mult5_in1),
                          .B(mult5_in2));
    
    Multiplier #(4) mult6(.S(mult6_out),
                          .A(mult6_in1),
                          .B(mult6_in2));
    
    Multiplier #(4) mult7(.S(mult7_out),
                          .A(mult7_in1),
                          .B(mult7_in2));
    
    Multiplier #(4) mult8(.S(mult8_out),
                          .A(mult8_in1),
                          .B(mult8_in2));
    
    Register #(32) layer_1_reg(.D({mult1_out, mult2_out, mult3_out, mult4_out}),
                               .en(layer_1_en),
                               .clock(clk),
                               .clear(rst),
                               .Q({add_in1, add_in2, add_in3, add_in4}));
    
    Register #(32) layer_1_2_reg(.D({mult5_out, mult6_out, mult7_out, mult8_out}),
                                 .en(layer_1_en),
                                 .clock(clk),
                                 .clear(rst),
                                 .Q({add_in5, add_in6, add_in7, add_in8}));
    
    assign add_out = add_in1 + add_in2 + add_in3 + add_in4;
    assign add_out2 = add_in5 + add_in6 + add_in7 + add_in8;

    ShiftRegister_20_160 shift_register(.data_in({add_out, add_out2}),
                                      .en(layer_2_en),
                                      .clock(clk),
                                      .rst(rst),
                                      .Q(mat_out));
    
    mult_fsm fsm(.mat_A(mat_A),
                 .mat_B(mat_B),
                 .clk(clk),
                 .rst(rst),
                 .mult_en(mult_en),
                 .mult1_in1(mult1_in1),
                 .mult1_in2(mult1_in2),
                 .mult2_in1(mult2_in1),
                 .mult2_in2(mult2_in2),
                 .mult3_in1(mult3_in1),
                 .mult3_in2(mult3_in2),
                 .mult4_in1(mult4_in1),
                 .mult4_in2(mult4_in2),
                 .mult5_in1(mult5_in1),
                 .mult5_in2(mult5_in2),
                 .mult6_in1(mult6_in1),
                 .mult6_in2(mult6_in2),
                 .mult7_in1(mult7_in1),
                 .mult7_in2(mult7_in2),
                 .mult8_in1(mult8_in1),
                 .mult8_in2(mult8_in2),
                 .layer_1_en(layer_1_en),
                 .layer_2_en(layer_2_en),
                 .finish(finish));
    

endmodule : Multiply_Path


module mult_fsm(input logic [63:0] mat_A, mat_B,
                input logic clk, rst, mult_en,
                output logic [3:0] mult1_in1, mult1_in2,
                output logic [3:0] mult2_in1, mult2_in2,
                output logic [3:0] mult3_in1, mult3_in2,
                output logic [3:0] mult4_in1, mult4_in2,
                output logic [3:0] mult5_in1, mult5_in2,
                output logic [3:0] mult6_in1, mult6_in2,
                output logic [3:0] mult7_in1, mult7_in2,
                output logic [3:0] mult8_in1, mult8_in2,
                output logic layer_1_en, layer_2_en, finish);
    
    logic [3:0] mat_A_1, mat_A_2, mat_A_3, mat_A_4;
    logic [3:0] mat_A_5, mat_A_6, mat_A_7, mat_A_8;
    logic [3:0] mat_A_9, mat_A_10, mat_A_11, mat_A_12;
    logic [3:0] mat_A_13, mat_A_14, mat_A_15, mat_A_16;
    logic [3:0] mat_B_1, mat_B_2, mat_B_3, mat_B_4;
    logic [3:0] mat_B_5, mat_B_6, mat_B_7, mat_B_8;
    logic [3:0] mat_B_9, mat_B_10, mat_B_11, mat_B_12;
    logic [3:0] mat_B_13, mat_B_14, mat_B_15, mat_B_16;

    assign mat_A_1 = mat_A[63:60];
    assign mat_A_2 = mat_A[59:56];
    assign mat_A_3 = mat_A[55:52];
    assign mat_A_4 = mat_A[51:48];
    assign mat_A_5 = mat_A[47:44];
    assign mat_A_6 = mat_A[43:40];
    assign mat_A_7 = mat_A[39:36];
    assign mat_A_8 = mat_A[35:32];
    assign mat_A_9 = mat_A[31:28];
    assign mat_A_10 = mat_A[27:24];
    assign mat_A_11 = mat_A[23:20];
    assign mat_A_12 = mat_A[19:16];
    assign mat_A_13 = mat_A[15:12];
    assign mat_A_14 = mat_A[11:8];
    assign mat_A_15 = mat_A[7:4];
    assign mat_A_16 = mat_A[3:0];

    assign mat_B_1 = mat_B[63:60];
    assign mat_B_2 = mat_B[59:56];
    assign mat_B_3 = mat_B[55:52];
    assign mat_B_4 = mat_B[51:48];
    assign mat_B_5 = mat_B[47:44];
    assign mat_B_6 = mat_B[43:40];
    assign mat_B_7 = mat_B[39:36];
    assign mat_B_8 = mat_B[35:32];
    assign mat_B_9 = mat_B[31:28];
    assign mat_B_10 = mat_B[27:24];
    assign mat_B_11 = mat_B[23:20];
    assign mat_B_12 = mat_B[19:16];
    assign mat_B_13 = mat_B[15:12];
    assign mat_B_14 = mat_B[11:8];
    assign mat_B_15 = mat_B[7:4];
    assign mat_B_16 = mat_B[3:0];
    
    enum logic [4:0] {S,M1,M2A1,M3A2,M4A3,M5A4,M6A5,M7A6,M8A7,A8,E} cur_state, n_state;
    always_comb begin
        case(cur_state)
            S: begin
                mult1_in1 = 4'b0;
                mult1_in2 = 4'b0;
                mult2_in1 = 4'b0;
                mult2_in2 = 4'b0;
                mult3_in1 = 4'b0;
                mult3_in2 = 4'b0;
                mult4_in1 = 4'b0;
                mult4_in2 = 4'b0;
                mult5_in1 = 4'b0;
                mult5_in2 = 4'b0;
                mult6_in1 = 4'b0;
                mult6_in2 = 4'b0;
                mult7_in1 = 4'b0;
                mult7_in2 = 4'b0;
                mult8_in1 = 4'b0;
                mult8_in2 = 4'b0;
                layer_1_en = 1'b0;
                layer_2_en = 1'b0;
                finish = 1'b0;
                if(mult_en)
                    n_state = M1;
                else
                    n_state = S;
            end
            M1: begin
                mult1_in1 = mat_A_1;
                mult1_in2 = mat_B_1;
                mult2_in1 = mat_A_2;
                mult2_in2 = mat_B_5;
                mult3_in1 = mat_A_3;
                mult3_in2 = mat_B_9;
                mult4_in1 = mat_A_4;
                mult4_in2 = mat_B_13;
                mult5_in1 = mat_A_1;
                mult5_in2 = mat_B_2;
                mult6_in1 = mat_A_2;
                mult6_in2 = mat_B_6;
                mult7_in1 = mat_A_3;
                mult7_in2 = mat_B_10;
                mult8_in1 = mat_A_4;
                mult8_in2 = mat_B_14;
                layer_1_en = 1'b1;
                layer_2_en = 1'b0;
                finish = 1'b0;
                n_state = M2A1;
            end

            M2A1: begin
                mult1_in1 = mat_A_1;
                mult1_in2 = mat_B_3;
                mult2_in1 = mat_A_2;
                mult2_in2 = mat_B_7;
                mult3_in1 = mat_A_3;
                mult3_in2 = mat_B_11;
                mult4_in1 = mat_A_4;
                mult4_in2 = mat_B_15;
                mult5_in1 = mat_A_1;
                mult5_in2 = mat_B_4;
                mult6_in1 = mat_A_2;
                mult6_in2 = mat_B_8;
                mult7_in1 = mat_A_3;
                mult7_in2 = mat_B_12;
                mult8_in1 = mat_A_4;
                mult8_in2 = mat_B_16;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M3A2;
            end

            M3A2: begin
                mult1_in1 = mat_A_5;
                mult1_in2 = mat_B_1;
                mult2_in1 = mat_A_6;
                mult2_in2 = mat_B_5;
                mult3_in1 = mat_A_7;
                mult3_in2 = mat_B_9;
                mult4_in1 = mat_A_8;
                mult4_in2 = mat_B_13;
                mult5_in1 = mat_A_5;
                mult5_in2 = mat_B_2;
                mult6_in1 = mat_A_6;
                mult6_in2 = mat_B_6;
                mult7_in1 = mat_A_7;
                mult7_in2 = mat_B_10;
                mult8_in1 = mat_A_8;
                mult8_in2 = mat_B_14;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M4A3;
            end

            M4A3: begin
                mult1_in1 = mat_A_5;
                mult1_in2 = mat_B_3;
                mult2_in1 = mat_A_6;
                mult2_in2 = mat_B_7;
                mult3_in1 = mat_A_7;
                mult3_in2 = mat_B_11;
                mult4_in1 = mat_A_8;
                mult4_in2 = mat_B_15;
                mult5_in1 = mat_A_5;
                mult5_in2 = mat_B_4;
                mult6_in1 = mat_A_6;
                mult6_in2 = mat_B_8;
                mult7_in1 = mat_A_7;
                mult7_in2 = mat_B_12;
                mult8_in1 = mat_A_8;
                mult8_in2 = mat_B_16;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M5A4;
            end

            M5A4: begin
                mult1_in1 = mat_A_9;
                mult1_in2 = mat_B_1;
                mult2_in1 = mat_A_10;
                mult2_in2 = mat_B_5;
                mult3_in1 = mat_A_11;
                mult3_in2 = mat_B_9;
                mult4_in1 = mat_A_12;
                mult4_in2 = mat_B_13;
                mult5_in1 = mat_A_9;
                mult5_in2 = mat_B_2;
                mult6_in1 = mat_A_10;
                mult6_in2 = mat_B_6;
                mult7_in1 = mat_A_11;
                mult7_in2 = mat_B_10;
                mult8_in1 = mat_A_12;
                mult8_in2 = mat_B_14;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M6A5;
            end

            M6A5: begin
                mult1_in1 = mat_A_9;
                mult1_in2 = mat_B_3;
                mult2_in1 = mat_A_10;
                mult2_in2 = mat_B_7;
                mult3_in1 = mat_A_11;
                mult3_in2 = mat_B_11;
                mult4_in1 = mat_A_12;
                mult4_in2 = mat_B_15;
                mult5_in1 = mat_A_9;
                mult5_in2 = mat_B_4;
                mult6_in1 = mat_A_10;
                mult6_in2 = mat_B_8;
                mult7_in1 = mat_A_11;
                mult7_in2 = mat_B_12;
                mult8_in1 = mat_A_12;
                mult8_in2 = mat_B_16;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M7A6;
            end

            M7A6: begin
                mult1_in1 = mat_A_13;
                mult1_in2 = mat_B_1;
                mult2_in1 = mat_A_14;
                mult2_in2 = mat_B_5;
                mult3_in1 = mat_A_15;
                mult3_in2 = mat_B_9;
                mult4_in1 = mat_A_16;
                mult4_in2 = mat_B_13;
                mult5_in1 = mat_A_13;
                mult5_in2 = mat_B_2;
                mult6_in1 = mat_A_14;
                mult6_in2 = mat_B_6;
                mult7_in1 = mat_A_15;
                mult7_in2 = mat_B_10;
                mult8_in1 = mat_A_16;
                mult8_in2 = mat_B_14;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = M8A7;
            end

            M8A7: begin
                mult1_in1 = mat_A_13;
                mult1_in2 = mat_B_3;
                mult2_in1 = mat_A_14;
                mult2_in2 = mat_B_7;
                mult3_in1 = mat_A_15;
                mult3_in2 = mat_B_11;
                mult4_in1 = mat_A_16;
                mult4_in2 = mat_B_15;
                mult5_in1 = mat_A_13;
                mult5_in2 = mat_B_4;
                mult6_in1 = mat_A_14;
                mult6_in2 = mat_B_8;
                mult7_in1 = mat_A_15;
                mult7_in2 = mat_B_12;
                mult8_in1 = mat_A_16;
                mult8_in2 = mat_B_16;
                layer_1_en = 1'b1;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = A8;
            end

            A8: begin
                mult1_in1 = 4'b0;
                mult1_in2 = 4'b0;
                mult2_in1 = 4'b0;
                mult2_in2 = 4'b0;
                mult3_in1 = 4'b0;
                mult3_in2 = 4'b0;
                mult4_in1 = 4'b0;
                mult4_in2 = 4'b0;
                mult5_in1 = 4'b0;
                mult5_in2 = 4'b0;
                mult6_in1 = 4'b0;
                mult6_in2 = 4'b0;
                mult7_in1 = 4'b0;
                mult7_in2 = 4'b0;
                mult8_in1 = 4'b0;
                mult8_in2 = 4'b0;
                layer_1_en = 1'b0;
                layer_2_en = 1'b1;
                finish = 1'b0;
                n_state = E;
            end

            E: begin
                mult1_in1 = 4'b0;
                mult1_in2 = 4'b0;
                mult2_in1 = 4'b0;
                mult2_in2 = 4'b0;
                mult3_in1 = 4'b0;
                mult3_in2 = 4'b0;
                mult4_in1 = 4'b0;
                mult4_in2 = 4'b0;
                mult5_in1 = 4'b0;
                mult5_in2 = 4'b0;
                mult6_in1 = 4'b0;
                mult6_in2 = 4'b0;
                mult7_in1 = 4'b0;
                mult7_in2 = 4'b0;
                mult8_in1 = 4'b0;
                mult8_in2 = 4'b0;
                layer_1_en = 1'b0;
                layer_2_en = 1'b0;
                finish = 1'b1;
                n_state = E;
            end


            default: begin
                mult1_in1 = 4'b0;
                mult1_in2 = 4'b0;
                mult2_in1 = 4'b0;
                mult2_in2 = 4'b0;
                mult3_in1 = 4'b0;
                mult3_in2 = 4'b0;
                mult4_in1 = 4'b0;
                mult4_in2 = 4'b0;
                mult5_in1 = 4'b0;
                mult5_in2 = 4'b0;
                mult6_in1 = 4'b0;
                mult6_in2 = 4'b0;
                mult7_in1 = 4'b0;
                mult7_in2 = 4'b0;
                mult8_in1 = 4'b0;
                mult8_in2 = 4'b0;
                layer_1_en = 1'b0;
                layer_2_en = 1'b0;
                finish = 1'b0;
                n_state = S;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if(rst)
            cur_state <= S;
        else
            cur_state <= n_state;
    end

endmodule : mult_fsm