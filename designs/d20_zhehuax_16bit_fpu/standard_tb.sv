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

    logic [9:0]  in_val, out_val, expected_out_val;
    logic [1:0]  in_tag, out_tag;

    assign out_tag  = io_out[1:0];
    assign out_val  = io_out[9:2];

    assign io_in[1:0] = in_tag;
    // assign io_in[5:2] = op;
    assign io_in[9:2] = in_val;




    initial begin

        in_val = 8'h4E;
        in_tag = 2'b11;

        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] in_val=%d, out_val=%d, in_tag=%d, out_tag=%d", 
                 $time, in_val, out_val, in_tag, out_tag);      

        // Pass in first number
        @(negedge clock);
        in_val = 8'h4E;
        in_tag = 2'b01;
        @(negedge clock);
        in_val = 8'h54;
        in_tag = 2'b01;

        // Pass in second number (note it's the same number
        // as number 1)
        @(negedge clock);
        in_val = 8'h4E;
        in_tag = 2'b10;
        @(negedge clock);
        in_val = 8'h54;
        in_tag = 2'b10;

        // Perform subtraction
        @(negedge clock);
        in_val = 8'b0010;
        in_tag = 2'b11;

        @(negedge clock);
        @(negedge clock);

        @(negedge clock);
        @(negedge clock);


        $finish(0); // Pass
    end

endmodule