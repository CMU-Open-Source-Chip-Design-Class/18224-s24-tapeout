`default_nettype none

module my_fpga  // testing wrapper for FPGA verification
   (input  logic        clk_25mhz,
    input  logic [ 6:0] btn,
    output logic [27:0] gp, gn,
    output logic [ 7:0] led
    );

   logic reset, choose_vga_mode;
   assign reset  = btn[6];
   assign choose_vga_mode = btn[5];
   
   Blink8LEDs livecheck(.CLK_25(clk_25mhz),
                        .led(led));
   logic clk_295mhz;
   clock_manager cm(.clk_25mhz,
                    .clk_295mhz,
                    .locked()
                   );

  VGA_demonstrator vgad(.CLOCK_25(clk_25mhz), 
                        .CLOCK_29_5(clk_295mhz), 
                        .reset,
                        .choose_vga_mode,
                        .VGA_RED  ({gn[21], gn[22], gn[23]}), 
                        .VGA_GREEN({gn[14], gn[15], gn[16]}), 
                        .VGA_BLUE ({gp[21], gp[22], gp[23]}),
                        .VS       (gp[16]), 
                        .HS       (gp[17])
                       );

  assign gn[24] = '0;
  assign gn[17] = '0;
  assign gp[24] = '0;
  
endmodule : my_fpga
