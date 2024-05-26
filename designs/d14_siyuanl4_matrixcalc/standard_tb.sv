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


    initial #100000 $finish(1);


    task enter_pulse();
        io_in[8] = '1;
        @(negedge clock); @(negedge clock);
        io_in[8] = '0;
        @(negedge clock); @(negedge clock);
    endtask

    task switch_pulse();
        io_in[9] = '1;
        @(negedge clock); @(negedge clock);
        io_in[9] = '0;
        @(negedge clock); @(negedge clock);
    endtask

    initial begin

        io_in[7:0]      = 8'h11;
        io_in[11:10]    = 2'b10;
        io_in[9]        = '0;;
        io_in[8]        = '0;


        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] data_in=%d, enter=%b, sw=%b, op=%d, data_out=%d, index=%d, {error, finish}=%b", 
                 $time, io_in[7:0], io_in[8], io_in[9], io_in[11:10], io_out[4:0], io_out[10:7], io_out[6:5]);

        // Begin entering elements
        @(negedge clock);


        // Enter all 32 elements, two at a time.
        for(int i = 0; i < 16; i++) begin
            enter_pulse();
        end

        while(!(io_out[5]));
        // io_in = '1;

        // Output all resulting 16 elements
        for(int i = 0; i < 32; i++) switch_pulse();

        @(negedge clock); @(negedge clock); @(negedge clock);
        $finish(0); // Pass
    end

endmodule
