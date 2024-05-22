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

    logic [3:0] col_sel, row_L;
    assign col_sel = io_out[3:0];
    assign row_L   = io_out[8:4];

    logic mode, power, start, stop;
    assign io_in[3:0] = {start, stop, power, mode};

    initial begin

        mode = '0; power = '0; start = '0; stop = '0;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] Col=%d, Row_L=%d, mode=%b, power=%b, start=%b, stop=%b", 
                 $time, col_sel, row_L, mode, power, start, stop);

        // Wait one second
        repeat(10000) @(negedge clock);

        // Toggle mode and wait 2 seconds to transition
        // to chrono mode
        mode = '1;
        repeat(20000) @(negedge clock);

        mode = '0; 
        repeat(10000) @(negedge clock);

        // Start chronometer and wait for 3 seconds
        start = '1;
        repeat(30000) @(negedge clock);

        stop = '1;
        repeat(10000) @(negedge clock);

        // return to time mode
        mode = '1;
        repeat(60000) @(negedge clock);

        $finish(0); // Pass
    end

endmodule