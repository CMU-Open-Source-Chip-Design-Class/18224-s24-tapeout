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

        io_in = 1;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] OLED_clk=%b, OLED_mosi=%b, OLED_dc=%b, OLED_cs_n=%b, OLED_rst_n=%b", 
                 $time, io_out[11], io_out[10], io_out[9], io_out[8], io_out[7]);

        @(negedge clock); @(negedge clock);
        @(negedge clock); @(negedge clock);
        @(negedge clock); @(negedge clock);
        @(negedge clock); @(negedge clock);
        io_in = '0;
        
        @(negedge clock); @(negedge clock);
        @(negedge clock); @(negedge clock);
        io_in = 1;
        

        // Simply pulse the clock 100,000 times
        // Look at vcd dumpfile to check for correctness
        repeat(100000) @(negedge clock);

        $finish(0); // Pass
    end

endmodule