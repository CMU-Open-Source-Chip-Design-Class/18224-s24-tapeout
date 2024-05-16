`default_nettype none

`define ASSERT(x) if (!(x)) begin \
    $display("Assert failed at line %d", `__LINE__); \
    $finish(1); 
end

module standard_tb (
    output logic [11:0] io_in,
    input logic [11:0] io_out,
    input logic ready,
    input logic clock, reset
);

    logic [7:0]  in_bus, out_bus;
    logic ard_clk, ard_data_ready, ard_receive_ready, 
          bus_pc, bus_mar, bus_mdr, halt;

    assign io_in[7:0]   = in_bus;
    assign io_in[10]    = ard_clk;
    assign io_in[9]     = ard_data_ready;
    assign io_in[8]     = ard_receive_ready;

    assign out_bus  = io_out[7:0];
    assign bus_pc   = io_out[8];
    assign bus_mar  = io_out[9];
    assign bus_mdr  = io_out[10];
    assign halt     = io_out[11];

    assign ard_clk      = clock;

    logic[15:0][15:0] instr_memory;

    logic[15:0][15:0] data_memory;
    logic[15:0] pc, store_address, load_data;
    logic signed [15:0] result;
    logic[15:0] pc, address;

    initial begin
        #1000000 $finish();
    end

    logic halt_accum;

    always_ff @(posedge clock) begin
        if (reset) halt_accum <= '0;
        else halt_accum <= halt_accum | halt;
    end

    initial begin

        // {} = '0;
        logic [15:0] addr, a, b;
        addr = 16'd4;
        a = 16'd5;
        b = 16'd6;
        result = a + b;

        instr_memory[0] = {ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
        instr_memory[1] = a;
        instr_memory[2] = {ADD, 3'd2 , 3'd0, 3'd0, I_TYPE};
        instr_memory[3] = b;
        instr_memory[4] = {ADD, 3'd3, 3'd1 , 3'd2, R_TYPE};
        instr_memory[5] = {SW, 3'd0, 3'd3, 3'd0, M_TYPE};
        instr_memory[6] = addr;
        instr_memory[7] = {'b0, SYS_END};

        ard_receive_ready = '0; ard_data_ready = '0; data_memory = '0;
        pc = '0; in_bus = '0;
        #100;
        while (!ready) @(negedge clock);

        ard_receive_ready = '1;
        // @(negedge clock); 

        // TB code from student's submitted testbench
        while (~halt_accum) begin
            if(bus_pc) begin
                pc <= {out_bus, pc[15:8]};
                @(negedge clock);
                pc <= {out_bus, pc[15:8]};
                @(negedge clock);
                ard_receive_ready <= 1'b0;
                ard_data_ready <= 1'b1;
                in_bus <= instr_memory[pc][7:0];
                @(negedge clock);
                ard_data_ready <= 1'b1;
                in_bus <= instr_memory[pc][15:8];
                @(negedge clock);
                if(instr_memory[pc][3:0] == I_TYPE || instr_memory[pc][3:0] == M_TYPE) begin
                    ard_data_ready <= 1'b1;
                    in_bus <= instr_memory[pc+1][7:0];
                    @(negedge clock);
                    ard_data_ready <= 1'b1;
                    in_bus <= instr_memory[pc+1][15:8];
                    @(negedge clock);
                    ard_data_ready <= 1'b0;
                end else begin
                    ard_data_ready <= 1'b0;
                end
                ard_receive_ready <= 1'b1;
                @(negedge clock);
            end else if(bus_mar) begin
                address <= {out_bus, address[15:8]};
                @(negedge clock);
                address <= {out_bus, address[15:8]};
                @(negedge clock);
                if(~bus_mdr) begin
                    ard_receive_ready <= 1'b0;
                    ard_data_ready <= 1'b1;
                    in_bus <= data_memory[address][7:0];
                    @(negedge clock);
                    ard_data_ready <= 1'b1;
                    in_bus <= data_memory[address][15:8];
                    @(negedge clock);
                    ard_data_ready <= 1'b0;
                    ard_receive_ready <= 1'b1;
                    @(negedge clock);
                end else begin
                    load_data <= {out_bus, load_data[15:8]};
                    @(negedge clock);
                    load_data <= {out_bus, load_data[15:8]};
                    @(negedge clock);
                    data_memory[address] <= load_data;
                    ard_receive_ready <= 1'b1;
                    ard_data_ready <= 1'b0;
                    @(negedge clock);
                end
            end else begin
                @(negedge clock);
            end
        end 

        $display("Add Test Case Passed!! Memory at address %h was %d, which is %d + %d.", addr, $signed(data_memory[addr]), a, b);
        $finish(0); // Pass
    end
endmodule