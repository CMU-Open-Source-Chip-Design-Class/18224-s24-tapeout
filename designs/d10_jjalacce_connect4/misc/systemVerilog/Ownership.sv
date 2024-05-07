`default_nettype none

module Ownership
(input logic [6:0] player_1_input, player_2_input,
input logic player_1_confirm, player_2_confirm,
input logic switchTurn, input logic clock, input logic reset,
output logic [1:0] tokens [6][7], input logic newGame);

  //tokens array works side by side bits are considered sigle token
  //each set of 14 is a single row

  logic [6:0] move;
  logic confirm;
  logic [1:0] set;
  logic currentPlayer;

  logic [1:0] tokensIn [6][7];

  currentPlayerFSM fsm(.switchTurn(switchTurn), .currentPlayer(currentPlayer),
   .clock(clock), .reset(reset));

  //set is the value that the choosen token should take
  assign set =(~currentPlayer & confirm) ? 2'b01 : (currentPlayer & confirm) 
  ? 2'b10 : 2'b00;

  always_ff @(posedge clock) begin
    if(reset)
      tokens <= 84'd0;
    else if(newGame)
      tokens <= 84'd0;
    else begin
      if(~confirm)
        tokens <= tokens;
      else begin
        if(tokens[5][move] == 2'b00) begin
          tokens[5][move] <= set;
        end
        else if(tokens[4][move] == 2'b00) begin
          tokens[4][move] <= set;
        end
        else if(tokens[3][move] == 2'b00) begin
          tokens[3][move] <= set;
        end
        else if(tokens[2][move] == 2'b00) begin
          tokens[2][move] <= set;
        end
        else if(tokens[1][move] == 2'b00) begin
          tokens[1][move] <= set;
        end
        else if(tokens[0][move] == 2'b00) begin
          tokens[0][move] <= set;
        end
      end
    end
  end

  //currentPlayer = 1 is player 1 currentPlayer = 0 is player 2
  always_comb begin
    if(~currentPlayer) begin
      case(player_1_input)
        7'd1: move = 7'd0;
        7'd2: move = 7'd1;
        7'd4: move = 7'd2;
        7'd8: move = 7'd3;
        7'd16: move = 7'd4;
        7'd32: move = 7'd5;
        7'd64: move = 7'd6;
        //We should never hit the default
        default: move = 7'd9;
      endcase
      confirm = player_1_confirm;
    end
    else begin
      case(player_2_input)
        7'd1: move = 7'd0;
        7'd2: move = 7'd1;
        7'd4: move = 7'd2;
        7'd8: move = 7'd3;
        7'd16: move = 7'd4;
        7'd32: move = 7'd5;
        7'd64: move = 7'd6;
        //We should never hit the default
        default: move = 7'd9;
      endcase
      confirm = player_2_confirm;
    end
  end

  //Assigns ownership to the selected token
  //If none of the tokens in the move column are 00 that means they are all
  //selected and the move is invalid
  // always_comb begin
  //   if(~confirm)
  //     tokensIn = tokens;
  //   else begin
  //     if(tokens[5][move] == 2'b00) begin
  //       tokensIn[5][move] = set;
  //     end
  //     else if(tokens[4][move] == 2'b00) begin
  //       tokensIn[4][move] = set;
  //     end
  //     else if(tokens[3][move] == 2'b00) begin
  //       tokensIn[3][move] = set;
  //     end
  //     else if(tokens[2][move] == 2'b00) begin
  //       tokensIn[2][move] = set;
  //     end
  //     else if(tokens[1][move] == 2'b00) begin
  //       tokensIn[1][move] = set;
  //     end
  //     else if(tokens[0][move] == 2'b00) begin
  //       tokensIn[0][move] = set;
  //     end
  //   end
  // end
  


endmodule: Ownership


module currentPlayerFSM
(input logic switchTurn,
output logic currentPlayer, input logic clock, input logic reset);

  enum logic {P1TURN, P2TURN} currState, nextState;

  always_ff @(posedge clock) begin
    if(reset)
      currState = P1TURN;
    else
      currState = nextState;
  end

  always_comb begin
    case(currState)
      P1TURN: begin
        if(switchTurn)
          nextState = P2TURN;
        else
          nextState = P1TURN;
      end
      P2TURN: begin
        if(~switchTurn)
          nextState = P1TURN;
        else
          nextState = P2TURN;
      end
    endcase
  end

  always_comb begin
    case(currState)
      P1TURN: currentPlayer = 0;
      P2TURN: currentPlayer = 1;
    endcase
  end

endmodule: currentPlayerFSM