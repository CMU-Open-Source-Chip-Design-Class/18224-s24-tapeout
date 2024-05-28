`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
  // PIN MAPPING
  // io_in[0] = choose vga mode, when 0 640x480. When 1, 800x480
  // io_in[11:1] unused
  //
  // io_out[2:0] RED
  // io_out[5:3] GREEN
  // io_out[8:6] BLUE
  // io_out[9]   HS
  // io_out[10]  VS
  // io_out[11]  liveness check.  Toggles every couple of seconds
  
  VGA_demonstrator vgad(.CLOCK_25(clock), 
                        .CLOCK_29_5(clock),
                        .reset,
                        .choose_vga_mode(io_in[0]),
                        .VGA_RED  (io_out[2:0]), 
                        .VGA_GREEN(io_out[5:3]), 
                        .VGA_BLUE (io_out[8:6]),
                        .VS       (io_out[10]), 
                        .HS       (io_out[9])
                       );

   logic [7:0] virtual_leds;
   Blink8LEDs livecheck(.CLK_25(clock),
                        .led(virtual_leds));
   assign io_out[11] = virtual_leds[7];
                       
endmodule : my_chip

module VGA_demonstrator
  (input  logic       CLOCK_25, CLOCK_29_5, reset,
   input  logic       choose_vga_mode,
   output logic       blank,
   output logic [2:0] VGA_RED, VGA_GREEN, VGA_BLUE,
   output logic       VS, HS);
   
  logic [7:0] VGA_RED_640, VGA_GREEN_640, VGA_BLUE_640;
  logic [7:0] VGA_RED_800, VGA_GREEN_800, VGA_BLUE_800;
  
  logic hs_640, vs_640, hs_800, vs_800;
  logic frame_done_640, frame_done_800;
  logic blank_640, blank_800;
  logic [8:0] row_640, row_800;
  logic [9:0] col_640, col_800;
  
  // Multiplexer
  always_comb
    if (choose_vga_mode) begin
      VGA_RED   = VGA_RED_640[7:5];
      VGA_GREEN = VGA_GREEN_640[7:5];
      VGA_BLUE  = VGA_BLUE_640[7:5];
      VS        = vs_640;
      HS        = hs_640;
      blank     = blank_640;
    end else begin
      VGA_RED   = VGA_RED_800[7:5];
      VGA_GREEN = VGA_GREEN_800[7:5];
      VGA_BLUE  = VGA_BLUE_800[7:5];
      VS        = vs_800;
      HS        = hs_800;
      blank     = blank_800;
    end      
  
  VGA_640x480 v0(.CLOCK_25,
                 .reset,
                 .HS(hs_640),
                 .VS(vs_640),
                 .blank(blank_640),
                 .frame_done(frame_done_640),
                 .row(row_640),
                 .col(col_640)
                );
  Graphics_640x480 g0(.clock(CLOCK_25),
                      .reset,
                      .row(row_640),
                      .col(col_640),
                      .frame_done(frame_done_640),
                      .blank(blank_640),
                      .VGA_RED(VGA_RED_640),
                      .VGA_GREEN(VGA_GREEN_640),
                      .VGA_BLUE(VGA_BLUE_640)
                     );
                
  VGA_800x480 v1(.CLOCK_29_5,
                 .reset,
                 .HS(hs_800),
                 .VS(vs_800),
                 .blank(blank_800),
                 .frame_done(frame_done_800),
                 .row(row_800),
                 .col(col_800)
                );
  Graphics_800x480 g1(.clock(CLOCK_29_5),
                      .reset,
                      .row(row_800),
                      .col(col_800),
                      .frame_done(frame_done_800),
                      .blank(blank_800),
                      .VGA_RED(VGA_RED_800),
                      .VGA_GREEN(VGA_GREEN_800),
                      .VGA_BLUE(VGA_BLUE_800)
                     );
                
endmodule : VGA_demonstrator

module VGA_640x480
  (input  logic       CLOCK_25,  // Assumes 25MHz
   input  logic       reset,
   output logic       HS, VS, blank,
   output logic       frame_done, // active for one clock after last row / last col
   output logic [8:0] row,
   output logic [9:0] col
   );

  logic clock;
  assign clock = CLOCK_25;

  logic clear, h_clear, h_done, h_blank, v_blank;
  logic [9:0] horiz_clock_counter;
  assign col = horiz_clock_counter[9:0];
  assign h_done = (horiz_clock_counter == 10'd799);
  assign h_clear = clear | h_done;
  assign blank = h_blank | v_blank;
  assign h_blank = (horiz_clock_counter > 10'd639);

  // THIS IS FOR 25 MHZ
  // TDisp is from   0 - 639
  // TFP   is from 640 - 655
  // TPW   is from 656 - 751
  // TBP   is from 752 - 799
  Counter #(10) hcounter(.D('0),
                         .Q(horiz_clock_counter),
                         .en(1'b1),
                         .clear(h_clear),
                         .load(1'b0),
                         .up(1'b1),
                         .clock
                        );

  logic h_pw_L;
  assign HS = ~h_pw_L;
  OffsetCheck  #(10) hpulse_oc(.val(horiz_clock_counter),
                               .delta(10'd96),
                               .low(10'd656),
                               .is_between(h_pw_L)
                              );

  logic v_done, v_clear;
  logic [9:0] vert_row_counter;
  assign row = vert_row_counter[8:0];
  assign v_done = (vert_row_counter == 10'd520);
  assign v_clear = clear | (v_done & h_done);
  assign v_blank = (vert_row_counter > 10'd479);
  assign frame_done = ((vert_row_counter == 10'd479) &&
                       (horiz_clock_counter == 10'd640));

  // TDisp is from   0 - 479
  // TFP   is from 480 - 489
  // TPW   is from 490 - 491
  // TBP   is from 492 - 520
  Counter #(10) vcounter(.D('0),
                         .Q(vert_row_counter),
                         .en(h_done),  // only count once per row
                         .clear(v_clear),
                         .load(1'b0),
                         .up(1'b1),
                         .clock
                        );

  logic v_pw_L;
  assign VS = ~v_pw_L;
  OffsetCheck  #(10) vpulse_oc(.val(vert_row_counter),
                               .delta(10'd2),
                               .low(10'd490),
                               .is_between(v_pw_L)
                              );


  // Simple initializing FSM
  enum {INIT, RUNNING} state;

  always_ff @(posedge clock, posedge reset)
    if (reset)
      state <= INIT;
    else
      state <= RUNNING;

  assign clear = (state == INIT);

endmodule : VGA_640x480

module Graphics_640x480
  (input  logic       clock, reset,
   input  logic [8:0] row,
   input  logic [9:0] col,
   input  logic       frame_done, blank,
   output logic [7:0] VGA_RED, VGA_GREEN, VGA_BLUE
   );

  logic is_blue, is_green, is_cyan, is_red, is_purple, is_yellow, is_white;
  
  // A generate statement would have worked very nicely here!
  Rectangle #(.X(10'd80), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r0(.row,
               .col,
               .is_in_rectangle(is_blue)
              );
              
  Rectangle #(.X(10'd160), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r1(.row,
               .col,
               .is_in_rectangle(is_green)
              );
              
  Rectangle #(.X(10'd240), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r2(.row,
               .col,
               .is_in_rectangle(is_cyan)
              );
              
  Rectangle #(.X(10'd320), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r3(.row,
               .col,
               .is_in_rectangle(is_red)
              );
              
  Rectangle #(.X(10'd400), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r4(.row,
               .col,
               .is_in_rectangle(is_purple)
              );
              
  Rectangle #(.X(10'd480), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r5(.row,
               .col,
               .is_in_rectangle(is_yellow)
              );
              
  Rectangle #(.X(10'd560), .Y(9'd0), .WIDTH(10'd80), .HEIGHT(9'd240)) 
            r6(.row,
               .col,
               .is_in_rectangle(is_white)
              );
              
   assign VGA_RED   = (is_red | is_purple | is_yellow | is_white) ? 8'hFF : 8'h00;                
   assign VGA_GREEN = (is_green | is_cyan | is_yellow | is_white) ? 8'hFF : 8'h00;                
   assign VGA_BLUE  = (is_blue | is_cyan | is_purple | is_white)  ? 8'hFF : 8'h00;   
                
endmodule : Graphics_640x480

module VGA_800x480
  (input  logic       CLOCK_29_5,  // Assumes 29.5 MHz
   input  logic       reset,
   output logic       HS, VS, blank,
   output logic       frame_done, // active for one clock after last row / last col
   output logic [8:0] row,
   output logic [9:0] col
   );

  // Want to move to 800x480at60fps?
  // Pixel Clock: 29.5 MHz
  // H Total: 992 -> 800 active, 24 Front porch, 72 Sync, 96 Back porch (sync polarity -)
  // V Total: 500 -> 480 active, 3  Front porch,  7 sync, 10 back porch (sync polarity +)
  // According to VGA Calculator at: https://tomverbeure.github.io/video_timings_calculator
  logic clock;
  assign clock = CLOCK_29_5;

  logic clear, h_clear, h_done, h_blank, v_blank;
  logic [9:0] horiz_clock_counter;
  assign col = horiz_clock_counter[9:0];
  assign h_done = (horiz_clock_counter == 10'd991);
  assign h_clear = clear | h_done;
  assign blank = h_blank | v_blank;
  assign h_blank = (horiz_clock_counter > 10'd799);


  // THIS IS FOR 29.5 MHZ
  // TDisp is from   0 - 799 (800)
  // TFP   is from 800 - 823 ( 24)
  // TPW   is from 824 - 830 ( 72)
  // TBP   is from 896 - 991 ( 96)
  Counter #(10) hcounter(.D('0),
                         .Q(horiz_clock_counter),
                         .en(1'b1),
                         .clear(h_clear),
                         .load(1'b0),
                         .up(1'b1),
                         .clock
                        );

  logic h_pw_L;
  assign HS = ~h_pw_L;
  OffsetCheck  #(10) hpulse_oc(.val(horiz_clock_counter),
                               .delta(10'd72),
                               .low(10'd824),
                               .is_between(h_pw_L)
                              );

  logic v_done, v_clear;
  logic [9:0] vert_row_counter;
  assign row = vert_row_counter[8:0];
  assign v_done = (vert_row_counter == 10'd480);
  assign v_clear = clear | (v_done & h_done);
  assign v_blank = (vert_row_counter > 10'd499);
  assign frame_done = ((vert_row_counter == 10'd499) &&
                       (horiz_clock_counter == 10'd800));

  // TDisp is from   0 - 479 (480)
  // TFP   is from 480 - 482 (  3)
  // TPW   is from 483 - 489 (  7)
  // TBP   is from 490 - 499 ( 10)
  Counter #(10) vcounter(.D('0),
                         .Q(vert_row_counter),
                         .en(h_done),  // only count once per row
                         .clear(v_clear),
                         .load(1'b0),
                         .up(1'b1),
                         .clock
                        );

  OffsetCheck  #(10) vpulse_oc(.val(vert_row_counter),
                               .delta(10'd7),
                               .low(10'd483),
                               .is_between(VS)  // active high sync pulse
                              );


  // Simple initializing FSM
  enum {INIT, RUNNING} state;

  always_ff @(posedge clock, posedge reset)
    if (reset)
      state <= INIT;
    else
      state <= RUNNING;

  assign clear = (state == INIT);

endmodule : VGA_800x480

module Graphics_800x480
  (input  logic       clock, reset,
   input  logic [8:0] row,
   input  logic [9:0] col,
   input  logic       frame_done, blank,
   output logic [7:0] VGA_RED, VGA_GREEN, VGA_BLUE
   );

  logic is_blue, is_green, is_cyan, is_red, is_purple, is_yellow, is_white;
  
  // A generate statement would have worked very nicely here!
  Rectangle #(.X(10'd100), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd60)) 
            r0(.row,
               .col,
               .is_in_rectangle(is_blue)
              );
              
  Rectangle #(.X(10'd200), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd120)) 
            r1(.row,
               .col,
               .is_in_rectangle(is_green)
              );
              
  Rectangle #(.X(10'd300), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd180)) 
            r2(.row,
               .col,
               .is_in_rectangle(is_cyan)
              );
              
  Rectangle #(.X(10'd400), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd240)) 
            r3(.row,
               .col,
               .is_in_rectangle(is_red)
              );
              
  Rectangle #(.X(10'd500), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd300)) 
            r4(.row,
               .col,
               .is_in_rectangle(is_purple)
              );
              
  Rectangle #(.X(10'd600), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd360)) 
            r5(.row,
               .col,
               .is_in_rectangle(is_yellow)
              );
              
  Rectangle #(.X(10'd700), .Y(9'd0), .WIDTH(10'd100), .HEIGHT(9'd420)) 
            r6(.row,
               .col,
               .is_in_rectangle(is_white)
              );
              
   assign VGA_RED   = (is_red | is_purple | is_yellow | is_white) ? 8'hFF : 8'h00;                
   assign VGA_GREEN = (is_green | is_cyan | is_yellow | is_white) ? 8'hFF : 8'h00;                
   assign VGA_BLUE  = (is_blue | is_cyan | is_purple | is_white)  ? 8'hFF : 8'h00;
        
endmodule : Graphics_800x480

// outputs 1 when value is >= low and < high
// Note: Like a Python Range -- includes low.  Up to, not equal to high
module RangeCheck
 #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] val, high, low,
   output logic             is_between);

  logic low_eq, low_gt, high_lt, high_eq;
  assign is_between = (low_eq | low_gt) & (high_lt);

  MagComp #(WIDTH) lower(.A(val),
                         .B(low),
                         .AltB(),
                         .AeqB(low_eq),
                         .AgtB(low_gt)
                        );

  MagComp #(WIDTH) higher(.A(val),
                          .B(high),
                          .AltB(high_lt),
                          .AeqB(high_eq),
                          .AgtB()
                         );

endmodule : RangeCheck

// outputs 1 when value is >= low and < low + val
// Note: Like a Python Range -- includes low.  Up to, not equal to high
module OffsetCheck
 #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] val, delta, low,
   output logic             is_between);

  logic [WIDTH-1:0] high;

  RangeCheck #(WIDTH) rc(.val,
                         .low,
                         .high,
                         .is_between
                        );

  assign high = low + delta;

endmodule : OffsetCheck

module Rectangle
  #(parameter X, Y, WIDTH, HEIGHT)
  (input  logic [8:0] row,
   input  logic [9:0] col,
   output logic       is_in_rectangle
   );
   
  logic is_x, is_y;
  assign is_in_rectangle = is_x & is_y;
  
  OffsetCheck #(10) x(.val(col),
                      .delta(WIDTH),
                      .low(X),
                      .is_between(is_x)
                     );  

  OffsetCheck #( 9) y(.val(row),
                      .delta(HEIGHT),
                      .low(Y),
                      .is_between(is_y)
                     );  
                     
endmodule : Rectangle

module MagComp
  #(parameter   WIDTH = 8)
  (output logic             AltB, AeqB, AgtB,
   input  logic [WIDTH-1:0] A, B);

  always_comb begin
      AeqB = (A == B);
      AltB = (A <  B);
      AgtB = (A >  B);
    end

endmodule: MagComp

module Counter
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, clear, load, clock, up,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (clear)
      Q <= {WIDTH {1'b0}};
    else if (load)
      Q <= D;
    else if (en)
      if (up)
        Q <= Q + 1'b1;
      else
        Q <= Q - 1'b1;

endmodule : Counter

module Blink8LEDs // LEDs blink to show something is going on
  (input  logic       CLK_25,
   output logic [7:0] led);

   logic [26:0] led_count;
   assign led[7:0] = led_count[26:19];

   Counter #(27) ledcounter(.D('0),
                            .Q(led_count),
                            .en(1'b1),
                            .clear(1'b0),
                            .load(1'b0),
                            .up(1'b1),
                            .clock(CLK_25)
                           );
endmodule : Blink8LEDs
