`default_nettype none

// WIDTH-bit magnitude comparator
module MagComp
  #(parameter WIDTH = 30)
  (output logic AltB, AeqB, AgtB,
   input logic [WIDTH-1:0] A,
   input logic [WIDTH-1:0] B);
  assign AltB= (A<B);
  assign AgtB= (A>B);
  assign AeqB= (A==B);
endmodule : MagComp

// WIDTH-bit full adder
module Adder
  #(parameter WIDTH = 30)
  (output logic [WIDTH:0] S,
   input logic add,
   input logic [WIDTH-1:0] A,
   input logic [WIDTH-1:0] B);
  assign S = add ? A+B : A-B;
endmodule : Adder

// WIDTH-bit multiplier
module Multiplier
  #(parameter WIDTH = 30)
  (output logic [(WIDTH*2)-1:0] S,
   input logic [WIDTH-1:0] A,
   input logic [WIDTH-1:0] B);
  assign S = A*B;
endmodule : Multiplier


// 2:1 multiplexer for WIDTH-bit
module Mux2to1
  #(parameter WIDTH = 30)
  (output logic [WIDTH-1:0]Y,
   input logic S,
   input logic [WIDTH-1:0]I0,
   input logic [WIDTH-1:0]I1);
  assign Y=S?I1:I0;
endmodule : Mux2to1


// WIDTH-bit register
module Register
  #(parameter WIDTH = 3)
  (input logic [WIDTH-1:0] D,
   input logic en, clear,
   input logic clock,
   output logic [WIDTH-1:0] Q);
  always_ff @(posedge clock)
    if (clear)
      Q <= 0;
    else if (en)
      Q <= D;
    else
      Q <= Q;
endmodule: Register

// WIDTH-bit Counter
module Counter
  #(parameter WIDTH = 4)
  (input logic clock,
   input logic clear,
   input logic en,
   output logic [WIDTH-1:0] Q);
  always_ff @(posedge clock) begin
    if (clear) begin
      Q <= 0;
    end
    else if (en) begin
      Q <= Q + 1'b1;
    end
    else begin
      Q <= Q;
    end
  end
endmodule: Counter

// signal Synchronizer
module Synchronizer
  (input logic async,
   input logic clock,
   output logic sync);
  logic tmp1, tmp2;
  assign tmp2 = tmp1;
  always_ff @(posedge clock)
    tmp1 <= async;
  always_ff @(posedge clock)
    sync <= tmp2;
endmodule : Synchronizer

// 8 bit in 128 bit out shift register
module ShiftRegister_8_128 
  (input logic [7:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [127:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 128'b0;
    end
    else if (en) begin
      Q <= {Q[119:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_8_128

// 6 bit in 96 bit out shift register
module ShiftRegister_6_96
  (input logic [5:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [95:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 96'b0;
    end
    else if (en) begin
      Q <= {Q[89:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_6_96

// 48 bit in 96 bit out shift register
module ShiftRegister_48_96
  (input logic [47:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [95:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 96'b0;
    end
    else if (en) begin
      Q <= {Q[47:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_48_96

// edge detector
module edge_detector (
    input logic signal,
    input logic clk,
    output logic pulse
);
    logic tmp1;

    always_ff @(posedge clk) begin
        tmp1<=signal;
    end

    assign pulse = (~tmp1)& signal;
endmodule: edge_detector

// 12 bit in 96 bit out shift register
module ShiftRegister_12_96
  (input logic [11:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [95:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 96'b0;
    end
    else if (en) begin
      Q <= {Q[83:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_12_96

module ShiftRegister_20_160
  (input logic [19:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [159:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 160'b0;
    end
    else if (en) begin
      Q <= {Q[149:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_20_160

module ShiftRegister_96_96
  (input logic [95:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [95:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 96'b0;
    end
    else if (en) begin
      Q <= data_in;
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_96_96

module ShiftRegister_160_160
  (input logic [159:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [159:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 160'b0;
    end
    else if (en) begin
      Q <= data_in;
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_160_160

module ShiftRegister_80_160
  (input logic [79:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [159:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 160'b0;
    end
    else if (en) begin
      Q <= {Q[79:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_80_160

module ShiftRegister_40_160
  (input logic [39:0] data_in,
   input logic en,
   input logic clock, rst,
   output logic [159:0] Q);
  always_ff @(posedge clock) begin
    if (rst) begin
      Q <= 160'b0;
    end
    else if (en) begin
      Q <= {Q[119:0],data_in};
    end
    else begin
      Q <= Q;
    end
  end
endmodule : ShiftRegister_40_160