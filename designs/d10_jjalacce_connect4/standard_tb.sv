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

    initial begin

        io_in = 0;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md
        $monitor("[%d] {VGA Clock, VGA Blank, HSync, VSync}=%d, Red=%d, Green=%d, Blue=%b, in=%d", 
                 $time, io_out[3:0], io_out[5:4], io_out[7:6], io_out[9:8], io_in);

        // Simply pulse the clock 1,000,000 times
        // Look at vcd dumpfile to check for correctness
        io_in[0] = 1;
        repeat(1000000) @(negedge clock);

        $finish(0); // Pass
    end

endmodule
