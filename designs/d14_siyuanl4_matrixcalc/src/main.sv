`default_nettype none

module Matrix_Calculator 
    (input logic [7:0] data_in,
     input logic enter, sw,
     input logic [1:0] operation,
     input logic clk, rst,
     output logic [4:0] data_out,
     output logic finish, error,
     output logic [3:0] index);
    
    logic input_en;
    logic[127:0] input_matrix;
    logic[1:0] input_op;
    logic[159:0] add_output, mul_output;
    logic[159:0] selected_output;
    logic[63:0] input_matrix_A, input_matrix_B;
    
    logic add_en, mul_en;
    logic add_finish, mul_finish;
    logic switch_pulse, enter_pulse;

    assign input_matrix_A = input_matrix[127:64];
    assign input_matrix_B = input_matrix[63:0];
    
    ShiftRegister_8_128 shift_register(.data_in(data_in),
                                      .en(enter_pulse && input_en),
                                      .clock(clk),
                                      .rst(rst),
                                      .Q(input_matrix));

    Register #(2) op_reg(.D(operation),
                         .en(enter_pulse && input_en),
                         .clock(clk),
                         .clear(rst),
                         .Q(input_op));
    
    Mux2to1 #(160) output_mux(.Y(selected_output),
                             .I1(add_output),
                             .I0(mul_output),
                             .S(input_op[1]));
    
    matrix_calc_fsm fsm(.clk(clk),
                        .rst(rst),
                        .enter(enter_pulse),
                        .add_finish(add_finish),
                        .mul_finish(mul_finish),
                        .finish(finish),
                        .input_op(input_op),
                        .input_en(input_en),
                        .error(error),
                        .mul_en(mul_en),
                        .add_en(add_en));
    
    Add_Path add_logic(.mat_A(input_matrix_A),
                       .mat_B(input_matrix_B),
                       .clk(clk),
                       .rst(rst),
                       .add_en(add_en),
                       .sign(input_op[0]),
                       .mat_out(add_output),
                       .finish(add_finish));
    
    Multiply_Path mul_logic(.mat_A(input_matrix_A),
                            .mat_B(input_matrix_B),
                            .clk(clk),
                            .rst(rst),
                            .mult_en(mul_en),
                            .mat_out(mul_output),
                            .finish(mul_finish));

    edge_detector sw_de(.clk(clk),
                        .signal(sw),
                        .pulse(switch_pulse));
    
    edge_detector ed_de(.clk(clk),
                        .signal(enter),
                        .pulse(enter_pulse));
    

    logic [4:0] index_count;

    // output index logic
    Counter #(5) index_counter(.clock(clk),
                               .clear(rst),
                               .en(finish && switch_pulse),
                               .Q(index_count));
    assign index = index_count[4:1];

    // output switching logic
    always_comb begin
        case(index_count)
            5'b0000_0: data_out = selected_output[159:155];
            5'b0000_1: data_out = selected_output[154:150];
            5'b0001_0: data_out = selected_output[149:145];
            5'b0001_1: data_out = selected_output[144:140];
            5'b0010_0: data_out = selected_output[139:135];
            5'b0010_1: data_out = selected_output[134:130];
            5'b0011_0: data_out = selected_output[129:125];
            5'b0011_1: data_out = selected_output[124:120];
            5'b0100_0: data_out = selected_output[119:115];
            5'b0100_1: data_out = selected_output[114:110];
            5'b0101_0: data_out = selected_output[109:105];
            5'b0101_1: data_out = selected_output[104:100];
            5'b0110_0: data_out = selected_output[99:95];
            5'b0110_1: data_out = selected_output[94:90];
            5'b0111_0: data_out = selected_output[89:85];
            5'b0111_1: data_out = selected_output[84:80];
            5'b1000_0: data_out = selected_output[79:75];
            5'b1000_1: data_out = selected_output[74:70];
            5'b1001_0: data_out = selected_output[69:65];
            5'b1001_1: data_out = selected_output[64:60];
            5'b1010_0: data_out = selected_output[59:55];
            5'b1010_1: data_out = selected_output[54:50];
            5'b1011_0: data_out = selected_output[49:45];
            5'b1011_1: data_out = selected_output[44:40];
            5'b1100_0: data_out = selected_output[39:35];
            5'b1100_1: data_out = selected_output[34:30];
            5'b1101_0: data_out = selected_output[29:25];
            5'b1101_1: data_out = selected_output[24:20];
            5'b1110_0: data_out = selected_output[19:15];
            5'b1110_1: data_out = selected_output[14:10];
            5'b1111_0: data_out = selected_output[9:5];
            5'b1111_1: data_out = selected_output[4:0];
            default: data_out = 5'b0;
        endcase
    end

endmodule : Matrix_Calculator


module matrix_calc_fsm (input logic clk, rst,
                        input logic enter,
                        input logic [1:0] input_op,
                        input logic add_finish, mul_finish,
                        output logic finish,
                        output logic input_en, error,
                        output logic mul_en, add_en);
    
    
    enum logic [4:0] {S,S1,S2,S3,S4,S5,S6,S7,S8,
                      S9,S10,S11,S12,S13,S14,S15,S16,
                      M,A,E,F} cur_state, n_state;
    always_comb begin
        case(cur_state)
            S: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S1;
                end
                else begin
                    n_state = S;
                end
            end
            S1: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S2;
                end
                else begin
                    n_state = S1;
                end
            end
            S2: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S3;
                end
                else begin
                    n_state = S2;
                end
            end
            S3: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S4;
                end
                else begin
                    n_state = S3;
                end
            end
            S4: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S5;
                end
                else begin
                    n_state = S4;
                end
            end
            S5: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S6;
                end
                else begin
                    n_state = S5;
                end
            end
            S6: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S7;
                end
                else begin
                    n_state = S6;
                end
            end
            S7: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S8;
                end
                else begin
                    n_state = S7;
                end
            end
            S8: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S9;
                end
                else begin
                    n_state = S8;
                end
            end
            S9: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S10;
                end
                else begin
                    n_state = S9;
                end
            end
            S10: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S11;
                end
                else begin
                    n_state = S10;
                end
            end
            S11: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S12;
                end
                else begin
                    n_state = S11;
                end
            end
            S12: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S13;
                end
                else begin
                    n_state = S12;
                end
            end
            S13: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S14;
                end
                else begin
                    n_state = S13;
                end
            end
            S14: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S15;
                end
                else begin
                    n_state = S14;
                end
            end
            S15: begin
                input_en = 1'b1;
                error = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if(enter) begin
                    n_state = S16;
                end
                else begin
                    n_state = S15;
                end
            end
            S16: begin
                input_en = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                if (input_op == 2'b00) begin
                    n_state = M;
                    error = 1'b0;
                    mul_en = 1'b1;
                end
                else if (input_op[1] == 1'b1) begin
                    n_state = A;
                    error = 1'b0;
                    add_en = 1'b1;
                end
                else begin
                    n_state = F;
                    error = 1'b1;
                end
            end
            F: begin
                input_en = 1'b0;
                error = 1'b1;
                mul_en = 1'b0;
                add_en = 1'b0;
                finish = 1'b0;
                n_state = F;
            end
            M: begin
                input_en = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                error = 1'b0;
                if (mul_finish) begin
                    n_state = E;
                    finish = 1'b1;
                end
                else begin
                    n_state = M;
                    finish = 1'b0;
                end
            end
            A: begin
                input_en = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                error = 1'b0;
                if (add_finish) begin
                    n_state = E;
                    finish = 1'b1;
                end
                else begin
                    n_state = A;
                    finish = 1'b0;
                end
            end
            E: begin
                input_en = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                error = 1'b0;
                finish = 1'b1;
                n_state = E;
            end
            default: begin
                input_en = 1'b0;
                mul_en = 1'b0;
                add_en = 1'b0;
                error = 1'b0;
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

endmodule : matrix_calc_fsm



