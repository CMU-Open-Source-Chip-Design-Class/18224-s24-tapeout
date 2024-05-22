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

    initial begin

        io_in = 0;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] VSync=%b, HSync=%b, VGA Red=%d, VGA Green=%d, VGA Blue=%d", 
                 $time, io_out[0], io_out[1], 
                 {io_out[4], io_out[3], io_out[2], 1'b0}, 
                 {io_out[7], io_out[3], io_out[5], 1'b0}, 
                 {io_out[10], io_out[9], io_out[8], 1'b0},
                 io_in);

        // Simply pulse the clock 1,000,000 times
        // Look at vcd dumpfile to check for correctness
        io_in[0] = 1;
        repeat(1000000) @(negedge clock);

        $finish(0); // Pass
    end

endmodule