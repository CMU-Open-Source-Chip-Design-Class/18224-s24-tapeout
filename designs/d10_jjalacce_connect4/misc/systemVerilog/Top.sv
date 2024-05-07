`default_nettype none


// input Pins
// 0-6: Allows the human player to select between the 7 available columns to place
// their next token
// 7: Allows the human player to confirm the selected column
// 8: Switch between player 1 and player 2 turn
// 9: Switch between PvP and PvE mode
// 10: Start New Game
// 11: Change what is output on the debug outputs
// Output Pins
// 0: VGA Vertical Sync
// 1: VGA Horizontal Sync
// 2: VGA Blank
// 3: VGA VGA Clock
// 4-5: VGA Red
// 6-7: VGA Green
// 8-9: VGA Blue
// 10-11: Debug Output


module Top(input logic [6:0] inputMoves, input logic inputConfirm,
inputSwitchPlayer, inputSwitchPVP, inputNewGame,
input logic inputChangeDebug,
output logic [11:0] outputs, input logic clock, input logic reset);


  logic [6:0] inputMovesHalf, inputMovesSync;
  logic inputConfirmHalf, inputConfirmSync;
  logic inputSwitchPlayerHalf, inputSwitchPlayerSync;
  logic inputSwitchPVPHalf, inputSwitchPVPSync;
  logic inputNewGameHalf, inputNewGameSync;
  logic [1:0] inputChangeDebugHalf, inputChangeDebugSync;

  logic HS, VS, blank;
  logic [8:0] rowFromVGA;
  logic [9:0] colFromVGA;

  logic [8:0] rowToModule;
  logic [9:0] colToModule;

  logic is_board, is_token;
  logic [1:0] VGA_Red, VGA_Green, VGA_Blue;

  logic [1:0] tokens [6][7];

  logic [6:0] bot_input;
  logic bot_confirm;

  logic [6:0] player_2_input;
  logic player_2_confirm;

  logic [5:0] tokenRow;
  logic [6:0] tokenCol;

  logic debounceCountEn,debounceClear;
  logic [22:0] debounceCount;

  // //For COCO TB testing
  // logic [22:0] debounceLimit = 23'd0;
  //For FPGA and CHIP
  logic [22:0] debounceLimit = 23'd6_250_000;
  //comment out these assigns for cocoTB
  assign rowToModule = rowFromVGA;
  assign colToModule = colFromVGA;

  //Syncronize Inputs
  always_ff @(posedge clock) begin
    inputMovesSync <= inputMovesHalf;
    inputMovesHalf <= inputMoves;

    inputConfirmSync <= inputConfirmHalf;
    inputConfirmHalf <= inputConfirm;

    inputSwitchPlayerSync <= inputSwitchPlayerHalf;
    inputSwitchPlayerHalf <= inputSwitchPlayer;

    inputSwitchPVPSync <= inputSwitchPVPHalf;
    inputSwitchPVPHalf <= inputSwitchPVP;

    inputNewGameSync <= inputNewGameHalf;
    inputNewGameHalf <= inputNewGame;

    inputChangeDebugSync <= inputChangeDebugHalf;
    inputChangeDebugHalf <= inputChangeDebug;
  end

  //FSM that makes sure that the confirm input is only high for 1 clock
  logic inputConfirmLimited;
  enum logic [1:0] {PRESSED,PRESSEDLOCKED,NOTPRESSED} currStateConfirm, nextStateConfirm;
  always_ff @(posedge clock) begin
    if(reset) begin
      currStateConfirm <= NOTPRESSED;
      debounceCount <= 0;
    end
    else begin
      currStateConfirm <= nextStateConfirm;
      if(debounceCountEn)
        debounceCount <= debounceCount + 23'd1;
      else if(debounceClear)
        debounceCount <= 23'd0;
    end
  end
  always_comb begin
    inputConfirmLimited = 0;
    debounceCountEn = 0;
    case(currStateConfirm)
      PRESSED: begin
        inputConfirmLimited = 1;
        nextStateConfirm = PRESSEDLOCKED;
        debounceCountEn = 0;
        debounceClear = 1;
      end
      NOTPRESSED: begin
        inputConfirmLimited = 0;
        debounceCountEn = 0;
        debounceClear = 1;
        if(inputConfirmSync)
          nextStateConfirm = PRESSED;
        else
          nextStateConfirm = NOTPRESSED;
      end
      PRESSEDLOCKED: begin
        inputConfirmLimited = 0;
        debounceCountEn = 1;
        if(~inputConfirmSync && (debounceCount >= debounceLimit))
          nextStateConfirm = NOTPRESSED;
        else
          nextStateConfirm = PRESSEDLOCKED;
      end
      default: begin
        inputConfirmLimited = 0;
        debounceCountEn = 0;
        debounceClear = 1;
        nextStateConfirm = NOTPRESSED;
      end
    endcase
  end

  //if pvp is 1 then send player input if 0 send bot input
  assign player_2_input = inputSwitchPVPSync ?  inputMovesSync : bot_input;
  assign player_2_confirm = inputSwitchPVPSync ? inputConfirmLimited : bot_confirm;

  assign outputs[0] = VS;
  assign outputs[1] = HS;
  assign outputs[2] = blank;

  assign outputs[4] = VGA_Red[1];
  assign outputs[5] = VGA_Red[0];
  assign outputs[6] = VGA_Green[1];
  assign outputs[7] = VGA_Green[0];
  assign outputs[8] = VGA_Blue[1];
  assign outputs[9] = VGA_Blue[0];

  vga vga(.clk(clock), .rst(reset),.hsync(HS), .vsync(VS), .valid(blank),
  .v_idx(rowFromVGA), .h_idx(colFromVGA));

  //Tested
  Board board (.row(rowToModule), .col(colToModule), .is_board(is_board));
  //Tested
  Token token (.row(rowToModule), .col(colToModule), .is_token(is_token),
  .tokenRow(tokenRow), .tokenCol(tokenCol));

  Colors colors(.is_board(is_board), .is_token(is_token), .tokens(tokens),
  .red(VGA_Red), .blue(VGA_Blue), .green(VGA_Green), 
  .clock(clock), .reset(reset), .tokenRow(tokenRow), .tokenCol(tokenCol));

  //when inputsSync[8] is high that is player2 turn
  //when inputsSync[8] is low that is player 1 turn
  //Tested
  Ownership owner(.player_1_input(inputMovesSync), 
  .player_1_confirm(inputConfirmLimited),
   .player_2_input(player_2_input), .player_2_confirm(player_2_confirm),
  .switchTurn(inputSwitchPlayerSync), .clock(clock), .reset(reset), .tokens(tokens),
  .newGame(inputNewGameSync));
  //Tested
  PvE pve(.clock(clock), .reset(reset), .tokens(tokens), 
  .bot_turn(inputSwitchPlayerSync),
  .bot_move(bot_input), .bot_confirm(bot_confirm));

endmodule: Top


module Colors(input logic is_board, is_token, clock, reset,
input logic [1:0] tokens [6][7],
output logic [1:0] red, blue, green, input logic [5:0] tokenRow,
input logic [6:0] tokenCol);

  logic is_player_1, is_player_2;

  //Have a counter that increments each time is_token is asserted and use that
  //To figure out which token we are on to check the correct value in
  //tokens array

  //stillInToken prevents from the same token incrementing the counter
  //multiple times

  // logic [6:0] tokenRow;
  // logic [5:0] tokenCol;
  // logic stillInToken;

  // always_ff @(posedge clock) begin
  //   if(reset) begin
  //     tokenRow <= 0;
  //     tokenCol <= 0;
  //     stillInToken <= 0;
  //   end
  //   //We need to increment the counter
  //   if(is_token) begin
  //     if(stillInToken == 0) begin
  //       stillInToken <= 1;
  //       if(tokenCol == 6'd6) begin
  //         //We are past the max value
  //         if(tokenRow == 7'd5) begin
  //           tokenRow <= 7'd0;
  //           tokenCol <= 6'd0;
  //         end
  //         //We need to move to the next row up
  //         else begin 
  //           tokenCol <= 6'd0;
  //           tokenRow <= tokenRow + 7'd1;
  //         end
  //       end
  //       else begin
  //         tokenCol <= tokenCol + 6'd1;
  //       end
  //     end
  //   end
  //   else begin
  //     tokenRow <= tokenRow;
  //     tokenCol <= tokenCol;
  //   end
  //   if(is_board) begin
  //     stillInToken <= 0;
  //   end
  // end
  
  logic [5:0] currentTokenRow;
  logic [6:0] currentTokenCol;

  always_comb begin
    case(tokenRow)
      6'b100_000: currentTokenRow = 6'd0;
      6'b010_000: currentTokenRow = 6'd1;
      6'b001_000: currentTokenRow = 6'd2;
      6'b000_100: currentTokenRow = 6'd3;
      6'b000_010: currentTokenRow = 6'd4;
      6'b000_001: currentTokenRow = 6'd5;
      default: currentTokenRow =6'd0;
    endcase
  end

  always_comb begin
    case(tokenCol)
      7'b100_0000: currentTokenCol = 7'd0;
      7'b010_0000: currentTokenCol = 7'd1;
      7'b001_0000: currentTokenCol = 7'd2;
      7'b000_1000: currentTokenCol = 7'd3;
      7'b000_0100: currentTokenCol = 7'd4;
      7'b000_0010: currentTokenCol = 7'd5;
      7'b000_0001: currentTokenCol = 7'd6;
      default: currentTokenCol = 7'd0;
    endcase
  end

  assign is_player_1 = (tokens[currentTokenRow][currentTokenCol] == 2'b01) ? 1:0;
  assign is_player_2 = (tokens[currentTokenRow][currentTokenCol] == 2'b10) ? 1:0; 

  always_comb begin
    red = 2'b00;
    green = 2'b00;
    blue = 2'b00;
    if(is_board) begin
      red = 2'b00;
      green = 2'b00;
      blue = 2'b11;
    end
    //Red is player 1's token
    else if(is_token && is_player_1) begin
      red = 2'b11;
      green = 2'b00;
      blue = 2'b00;
    end
    //Yellow is player 2's token
    else if(is_token && is_player_2) begin
      red = 2'b11;
      green = 2'b11;
      blue = 2'b00;
    end
    //Black is an unclaimed token
    else if(is_token) begin
      red = 2'b00;
      green = 2'b00;
      blue = 2'b00;
    end
  end

endmodule: Colors


//From Anish Singhani
module vga (
    output logic [9:0] v_idx,
    output logic [9:0] h_idx,
    output logic valid,
    output logic vsync, hsync,

    input logic rst,
    input logic clk
);

assign valid = (v_idx < 480) && (h_idx < 640);

always @(posedge clk) begin
    if (rst) begin
        v_idx <= 0;
        h_idx <= 0;

        vsync <= 1;
        hsync <= 1;
    end
    else begin
        hsync <= 1;
        h_idx <= h_idx + 1;

        // Horizontal sync region
        if (h_idx >= 656 && h_idx < 752) begin
            hsync <= 1'b0;
        end

        // End of row
        if (h_idx >= 800) begin
            h_idx <= 0;
            v_idx <= v_idx + 1;

            // Vertical sync region
            if (v_idx >= 490 && v_idx < 492) begin
                vsync <= 0;
            end
            else begin
                vsync <= 1;
            end

            // End of frame
            if (v_idx >= 525) begin
                v_idx <= 0;
            end
        end
    end
end

endmodule