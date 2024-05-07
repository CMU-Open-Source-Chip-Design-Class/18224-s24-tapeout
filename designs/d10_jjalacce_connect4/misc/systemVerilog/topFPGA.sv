`default_nettype none

module topFPGA (
    output logic [7:0] led,
    input logic [6:0] btn,
    input logic [3:0] sw,
    input logic clk_25mhz,
    //first button board
    input logic gp0,gp1,gp2,gp3,
    //second button board
    input logic gp7,gp8,gp9,gp10,

    output logic gn14, gn15, gn16, gn17,
    output logic gp16, gp17,
    output logic gn21, gn22, gn23, gn24,
    output logic gp21, gp22, gp23, gp24,
    
    output logic ftdi_rxd,
    input logic ftdi_txd
);

    logic [6:0] inputMoves;
    assign inputMoves = {gp0,gp1,gp2,gp3,gp7,gp8,gp9};

    logic [1:0] red, green, blue;
    logic hsync, vsync;

    logic [11:0] chipOutputs;
    logic valid;

    // Pinout of the VGA PMOD
    // We check 'valid' here to avoid outputting outside of the 640x480 pixel area
    // IMPORTANT: Make sure to do this on your own chip as well, otherwise some
    // VGA monitors will not accept the signal
    assign {gn21, gn22, gn23, gn24} = valid ? {red[1:0], 1'b0} : '0;
    assign {gp21, gp22, gp23, gp24} = valid ? {blue[1:0], 1'b0} : '0;
    assign {gn14, gn15, gn16, gn17} = valid ? {green[1:0], 1'b0} : '0;
    assign gp16 = vsync;
    assign gp17 = hsync;

    
    assign vsync = chipOutputs[0];
    assign hsync = chipOutputs[1];
    assign valid = chipOutputs[2];
    //chipOutputs[3] is the vga clock
    assign red = chipOutputs[5:4];
    assign green = chipOutputs[7:6];
    assign blue = chipOutputs[9:8];
    //chipOutputs[11:10] are debug outputs that are not used


    //temporarly connected SwitchPVP to 1 to lock to PVP mode
    Top chip(.clock(clk_25mhz), .reset(~btn[0]), .inputMoves(inputMoves),
     .inputConfirm(btn[1]),
    .inputSwitchPlayer(sw[0]), .inputSwitchPVP(sw[1]),
    .inputNewGame(btn[4]), .inputChangeDebug(btn[5]),
    .outputs(chipOutputs));

endmodule
