`default_nettype none

module VGA_demonstrator_test();
  logic CLOCK_25, CLOCK_29_5, reset, choose_vga_mode;
  logic [2:0] VGA_RED, VGA_GREEN, VGA_BLUE;
  logic       VS, HS;
  
  VGA_demonstrator dut(.*);
  
  initial begin
     CLOCK_25 = 1'b0;
     reset = 1'b1;
     reset <= 1'b0;
     forever #5 CLOCK_25 = ~CLOCK_25;
  end
  
  assign CLOCK_29_5 = CLOCK_25;
  
  initial begin
     choose_vga_mode = 1'b0;
     #10_000_000;
     choose_vga_mode = 1'b1;
     #10_000_000;
     $finish();
  end
  
endmodule : VGA_demonstrator_test   
