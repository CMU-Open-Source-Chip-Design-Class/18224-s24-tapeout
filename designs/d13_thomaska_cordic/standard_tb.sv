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

    logic [9:0]  in_val;
    logic [10:0] out_val, expected_out_val;
    logic mode_toggle, out_toggle, done;

    assign io_in[9:0]   = in_val;
    assign io_in[10]    = mode_toggle;
    assign io_in[11]    = out_toggle;

    assign done     = io_out[11];
    assign out_val  = io_out[10:0];



    initial begin

        mode_toggle = '1; out_toggle = '1;
        in_val = 10'b1111_1101_01; expected_out_val = 11'b0010_0110_000;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] in_val=%d, out_val=%d, mode_toggle=%b, out_toggle=%b, done=%b", 
                 $time, in_val, out_val, mode_toggle, out_toggle, done);      

 
        // Wait until calculation has finished.
        while (!done) @(negedge clock);
        ASSERT(out_val == expected_out_val);


        $finish(0); // Pass
    end

endmodule