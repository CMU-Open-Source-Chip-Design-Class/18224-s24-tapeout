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


    logic rx, emergency_override, tx, framing_error, emergency, receiving, sending;
    logic [1:0] runway_override, runway_active;

    assign io_in[0]     = rx;
    assign io_in[2:1]   = runway_override;
    assign io_in[3]     = emergency_override;

    assign tx               = io_out[0];
    assign framing_error    = io_out[1];
    assign runway_active    = io_out[3:2];
    assign emergency        = io_out[4];
    assign receiving        = io_out[5];
    assign sending          = io_out[6];

    logic [7:0] send_ID_command;
    assign send_ID_command = 8'b0000_111_0;


    initial begin

        {rx, runway_override, emergency_override} = '0;
        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] {em_override, run_override, rx}=%b, sending/receiving/emergency=%b, runway_active/framing_error/tx=%b", 
                 $time, io_in[3:0], io_out[6:4], io_out[3:0]);

        // Send ID request (clk_freq / br zeroes, followed by command packet,
        // followed by clk_freq / br ones)
        rx = '0;
        for (int i = 0; i < 217; i++) @(negedge clock);
        for (int i = 0; i < 8; i++) begin
            for (int j = 0; j < 217; j++) begin
                rx = send_ID_command[i];
                @(negedge clock);
            end
        end
        rx = '1;
        for (int i = 0; i < 217; i++) @(negedge clock);

        // Await reply
        for (int i = 0; i < 11*217; i++) @(negedge clock);

        $finish(0); // pass
    end

endmodule