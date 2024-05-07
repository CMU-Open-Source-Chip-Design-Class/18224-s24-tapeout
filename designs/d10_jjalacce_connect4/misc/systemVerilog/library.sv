`default_nettype none

//Checks if val is within a range
module RangeCheck
    #(parameter w = 8)
    (input logic [w-1:0] val, 
     input logic [w-1:0] high, low,
     output logic is_between);

    always_comb begin
        is_between = (low <= val) && (high >= val) ? 1 : 0;
    end

endmodule: RangeCheck

//Up/Down parameterized counter with clear, load, en (in order of significance)
module Counter
  #(parameter WIDTH = 8)
  (input logic en, clear, load, up, clock, input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);
  always_ff @(posedge clock) begin
    if(clear)
      Q <= '0;
    else if(load)
      Q <= D;
    else if(en) begin
      if(up)
        Q <= Q+1;
      else
        Q <= Q-1;
    end
  end
endmodule: Counter