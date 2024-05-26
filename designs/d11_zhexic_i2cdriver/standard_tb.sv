`default_nettype none

`define ASSERT(x) if (!(x)) begin \
    $display("Assert failed at line %d", `__LINE__); \
    $finish(1); \
end


module standard_tb (
    output logic [11:0] io_in,
    input logic [11:0] io_out,
    input logic ready,
    input logic clock, reset
);


    logic SDA_in, SDA_out, SCL, wr_up, writeOK, wr_down, data_incoming;
    logic [7:0] data_in, data_out;

    logic [6:0] test_addr;
    logic [7:0] test_payl;
    assign test_addr = 7'h49;
    assign test_payl = 8'hA7;

    assign io_in[0]     = SDA_in;
    assign io_in[1]     = SCL;
    assign io_in[10]    = data_incoming;

    assign SDA_out  = io_out[0];
    assign wr_up    = io_out[1];
    assign writeOK  = io_out[10];
    assign wr_down  = io_out[11];

    assign io_in[9:2]   = data_in;
    assign data_out     = io_out[9:2];


    task send_bit(logic sendbit);
        for (int i = 0; i < 3; i++) @(negedge clock);
        SDA_in = sendbit;
        for (int i = 0; i < 2; i++) @(negedge clock);
        SCL = '1;
        for (int i = 0; i < 5; i++) @(negedge clock);
        SCL = '0;
    endtask


    initial begin

        data_incoming = '0;
        data_in = '0;
        SDA_in  = '0;
        SCL     = '0;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] SCL/SDA_in=%b, data_incoming=%b, wr_up/SDA_out=%b, wr_down/writeOK=%b, data_in=%b, data_out=%b", 
                 $time, {SCL, SDA_in}, data_incoming, {wr_up, SDA_out}, {wr_down, writeOK}, data_in, data_out);

        // Begin transaction
        SDA_in  = '1;
        SCL     = '1;
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        SDA_in = '0;
        @(negedge clock); @(negedge clock)
        SCL = '0;
        @(negedge clock); @(negedge clock);

        // Send address bits
        for (int i = 0; i < 7; i++) send_bit(test_addr[i]);  
        send_bit(0);
        for (int i = 0; i < 3; i++) @(negedge clock);
        SDA_in = '1;
        for (int i = 0; i < 2; i++) @(negedge clock);
        SCL = '1;
        for (int i = 0; i < 5; i++) @(negedge clock);

        ////////
        for (int i = 0; i < 2; i++) @(negedge clock);
        ////////

        SCL = '1;
        for (int i = 0; i < 5; i++) @(negedge clock);
        SCL = '0;

        // Send payload bits
        for (int i = 0; i < 8; i++) send_bit(test_payl[i]);
        for (int i = 0; i < 3; i++) @(negedge clock);
        SDA_in = '1;
        for (int i = 0; i < 2; i++) @(negedge clock);
        SCL = '1;
        for (int i = 0; i < 12; i++) @(negedge clock);
        SCL = '0;
        for (int i = 0; i < 5; i++) @(negedge clock);
        SCL = '0;
        SDA_in = '0;



        // End transaction
        @(negedge clock);
        SCL = '1;
        @(negedge clock);
        SDA_in = '1;
        $finish(0); //Pass

    end

endmodule
