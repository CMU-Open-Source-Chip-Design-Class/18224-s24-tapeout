`default_nettype none

module PvE(input logic clock, input logic reset, 
input logic [1:0] tokens [6][7],
input logic bot_turn, output logic [6:0] bot_move, output logic bot_confirm);

  logic [6:0] random;
  logic col0Full,col1Full,col2Full,col3Full,col4Full,col5Full,col6Full;
  logic [6:0] wantToMove;
  logic bot_confirm_FSM;

  LSFR0 rand0 (.reset(reset), .clock(clock), .randomOut(random[0]));
  LSFR1 rand1 (.reset(reset), .clock(clock), .randomOut(random[1]));
  LSFR2 rand2 (.reset(reset), .clock(clock), .randomOut(random[2]));
  LSFR3 rand3 (.reset(reset), .clock(clock), .randomOut(random[3]));
  LSFR4 rand4 (.reset(reset), .clock(clock), .randomOut(random[4]));
  LSFR5 rand5 (.reset(reset), .clock(clock), .randomOut(random[5]));
  LSFR6 rand6 (.reset(reset), .clock(clock), .randomOut(random[6]));

  //Determines which columns are possible moves
  always_comb begin
    col6Full = (tokens[0][6] == 2'b00) ? 0:1;
    col5Full = (tokens[0][5] == 2'b00) ? 0:1;
    col4Full = (tokens[0][4] == 2'b00) ? 0:1;
    col3Full = (tokens[0][3] == 2'b00) ? 0:1;
    col2Full = (tokens[0][2] == 2'b00) ? 0:1;
    col1Full = (tokens[0][1] == 2'b00) ? 0:1;
    col0Full = (tokens[0][0] == 2'b00) ? 0:1;
  end

  //Determines which moves the bot wants to play
  always_comb begin
    wantToMove[0] = random[0] & ~col0Full & bot_turn;
    wantToMove[1] = random[1] & ~col1Full & bot_turn;
    wantToMove[2] = random[2] & ~col2Full & bot_turn;
    wantToMove[3] = random[3] & ~col3Full & bot_turn;
    wantToMove[4] = random[4] & ~col4Full & bot_turn;
    wantToMove[5] = random[5] & ~col5Full & bot_turn;
    wantToMove[6] = random[6] & ~col6Full & bot_turn;
  end

  PvEFSM fsm(.clock(clock), .reset(reset), .wantToMove(wantToMove),
  .bot_move(bot_move), .bot_confirm(bot_confirm), .bot_turn(bot_turn));


endmodule: PvE

module PvEFSM(input logic clock, input logic reset, 
input logic [6:0] wantToMove, input logic bot_turn,
output logic [6:0] bot_move, output logic bot_confirm);

  logic [6:0] selectedMove;

  logic [22:0] timeOut;
  logic timeOutEn, timeOutClear;
  //Below is for FPGA and Chip
  logic [22:0] timeOutDelay = 23'd6_250_000;
  //below is for cocoTB
  // logic [22:0] timeOutDelay = 23'd0;

  enum logic [4:0] {START,MOVE,MOVED} currState, nextState;

  always_ff @(posedge clock) begin
    if(reset) begin
      currState <= START;
      timeOut <= 23'd0;
    end
    else begin
      currState <= nextState;
      if(timeOutClear)
        timeOut <= 23'd0;
      else if(timeOutEn)
        timeOut <= timeOut + 23'd1;
    end
  end

  always_comb begin
    if(wantToMove[3])
      selectedMove = 7'd3;
    else if(wantToMove[4])
      selectedMove = 7'd4;
    else if(wantToMove[2])
      selectedMove = 7'd2;
    else if(wantToMove[5])
      selectedMove = 7'd5;
    else if(wantToMove[1])
      selectedMove = 7'd1;
    else if(wantToMove[6])
      selectedMove = 7'd6;
    else if(wantToMove[0])
      selectedMove = 7'd0;
    else
      //we need to reselect the move
      selectedMove = 7'd10;
  end

  always_comb begin
    bot_move = 7'd0;
    bot_confirm = 0;
    timeOutClear = 1;
    timeOutEn = 0;
    unique case(currState)
      START: begin
        bot_confirm = 0;
        bot_move = 7'd9;
        timeOutClear = 1;
        timeOutEn = 0;
        if(~bot_turn)
          nextState = START;
        else begin
          if(selectedMove < 7'd7)
            nextState = MOVE;
          else
            nextState = START;
        end
      end
      MOVE: begin
        bot_move[selectedMove] = 1;
        bot_confirm = 1;
        timeOutClear = 1;
        timeOutEn = 0;
        nextState = MOVED;
      end
      MOVED: begin
        bot_move = 7'd9;
        bot_confirm = 0;
        timeOutEn = 1;
        timeOutClear = 0;
        if(~bot_turn && (timeOut >= timeOutDelay))
          nextState = START;
        else
          nextState = MOVED;
      end
      default: begin
        bot_move = 7'd9;
        bot_confirm = 0;
        nextState = START;
      end
    endcase
  end

endmodule: PvEFSM


// module PvEFSM(input logic clock, input logic reset, 
// input logic [6:0] wantToMove, input logic bot_turn,
// output logic [6:0] bot_move, output logic bot_confirm);

//   enum logic [4:0] {START,ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX} currState, nextState;

//   always_ff @(posedge clock) begin
//     if(reset)
//       currState <= START;
//     else
//       currState <= nextState;
//   end

//   always_comb begin
//     bot_move = 7'd0;
//     bot_confirm = 0;
//     unique case(currState)
//       START: begin
//         bot_confirm = 0;
//         bot_move = 7'd9;
//         if(~bot_turn)
//           nextState = START;
//         else begin
//           if(wantToMove[3])
//             nextState = THREE;
//           else if(wantToMove[4])
//             nextState = FOUR;
//           else if(wantToMove[2])
//             nextState = TWO;
//           else if(wantToMove[5])
//             nextState = FIVE;
//           else if(wantToMove[1])
//             nextState = ONE;
//           else if(wantToMove[6])
//             nextState = SIX;
//           else if(wantToMove[0])
//             nextState = ZERO;
//           else
//             nextState = START;
//         end
//       end
//       ZERO: begin
//         bot_move[0] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = ZERO;
//         else
//           nextState = START;
//       end
//       ONE: begin
//         bot_move[1] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = ONE;
//         else
//           nextState = START;
//       end
//       TWO: begin
//         bot_move[2] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = TWO;
//         else
//           nextState = START;
//       end
//       THREE: begin
//         bot_move[3] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = THREE;
//         else
//           nextState = START;
//       end
//       FOUR: begin
//         bot_move[4] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = FOUR;
//         else
//           nextState = START;
//       end
//       FIVE: begin
//         bot_move[5] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = FIVE;
//         else
//           nextState = START;
//       end
//       SIX: begin
//         bot_move[6] = 1;
//         bot_confirm = 1;
//         if(bot_turn)
//           nextState = SIX;
//         else
//           nextState = START;
//       end
//     endcase
//   end

// endmodule: PvEFSM

module LSFR0 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b1111;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR0

module LSFR1 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b0011;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR1

module LSFR2 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b1101;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR2

module LSFR3 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b1100;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR3

module LSFR4 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b1001;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR4

module LSFR5 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b0011;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR5

module LSFR6 (input logic reset, input logic clock,
            output logic randomOut);

  logic [3:0] inputFF,outputFF;

  assign randomOut = outputFF[3];

  always_ff @(posedge clock) begin
    if(reset)
      outputFF <= 4'b0101;
    else
      outputFF <= inputFF;
  end

  always_comb begin
    inputFF[0] = outputFF[3] ^ outputFF[2];
    inputFF[1] = outputFF[0];
    inputFF[2] = outputFF[1];
    inputFF[3] = outputFF[2];
  end
endmodule: LSFR6