`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    TopChip design (.clock(clock), .reset(reset), .inputMoves(io_in[6:0]), .inputConfirm(io_in[7]),
                .inputSwitchPlayer(io_in[8]), .inputSwitchPVP(io_in[9]), .inputNewGame(io_in[10]),
                .inputChangeDebug(io_in[11]),
                .outputs(io_out));

endmodule
