//SPDX-FileCopyrightText: 2021 Ethan Polcyn & Anish Singhani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
`default_nettype none

// Calculate and render score
module score (
    input wire [9:0] vaddr,
    input wire [9:0] haddr,
    input wire halt,

    output reg pixel,
    output wire [15:0] score_out,

	input wire game_rst,
    input wire clk,
    input wire sys_rst
);

localparam SCORE_INC_TIME = 5000000;

reg [21:0] ctr;
reg [3:0] score_saved[3:0];
reg [3:0] score[3:0];

assign score_out = {score[3], score[2], score[1], score[0]};

// Digit ROM
reg [189:0] digits[52:0];

always @(posedge clk) begin
    if (game_rst || sys_rst) begin
        ctr <= 0;
        score[3] <= 0;
        score[2] <= 0;
        score[1] <= 0;
        score[0] <= 0;
    end
    else if (!halt) begin
        ctr <= ctr + 1;
        if(ctr >= 2517500)begin
            ctr <= 0;
            score[0] <= score[0] + 1;
            if(score[0] + 1 >= 10)begin
                score[0] <= 0;

                score[1] <= score[1] + 1;
                if(score[1] + 1 >= 10)begin
                    score[1] <= 0;

                    score[2] <= score[2] + 1;
                    if(score[2] + 1 >= 10)begin
                        score[2] <= 0;

                        score[3] <= score[3] + 1;
                        if(score[3] + 1 >= 10)begin
                            score[3] <= 0;
                        end
                    end
                end
            end
        end
    end
end

always @(posedge clk) begin
    pixel <= 0;

    if (vaddr > 20 && vaddr < 73) begin
        if (haddr > 460 && haddr < 480) begin
            pixel <= digits[vaddr-21][(haddr-461)+(19*score_saved[3])];
        end
        else if (haddr > 482 && haddr < 502) begin
            pixel <= digits[vaddr-21][(haddr-483)+(19*score_saved[2])];
        end
        else if (haddr > 504 && haddr < 524) begin
            pixel <= digits[vaddr-21][(haddr-505)+(19*score_saved[1])];
        end
        else if (haddr > 526 && haddr < 546) begin
            pixel <= digits[vaddr-21][(haddr-527)+(19*score_saved[0])];
        end
    end
    else begin
        score_saved[3] <= score[3];
        score_saved[2] <= score[2];
        score_saved[1] <= score[1];
        score_saved[0] <= score[0];
    end
end

initial begin
    digits[0]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[1]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[2]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[3]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[4]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[5]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[6]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[7]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[8]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[9]  = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[10] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[11] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[12] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[13] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[14] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[15] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[16] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[17] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[18] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[19] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[20] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[21] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[22] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[23] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[24] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[25] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[26] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[27] = 189'b000111111111111100000000111111111110001111111111111111110000111111111100000000011111111111111100001111111100000000111111111111111100000011111111111110000000011111100000000000001111111100000;
    digits[28] = 189'b000111111111111100000000111111111110001111111111111111110000111111111100000000011111111111111100001111111100000000111111111111111100000011111111111110000000011111100000000000001111111100000;
    digits[29] = 189'b000111111111111100000000111111111110001111111111111111110000111111111100000000011111111111111100001111111100000000111111111111111100000011111111111110000000011111100000000000001111111100000;
    digits[30] = 189'b111111000000011111000011100000001111101111110000000111110000000000011111100000000000000001111100001111111111000000000111110000000000011111100000001111100000011111111000000000111110000011100;
    digits[31] = 189'b111111000000011111000011100000001111101111110000000111110000000000011111100000000000000001111100001111111111000000000111110000000000011111100000001111100000011111111000000000111110000011100;
    digits[32] = 189'b111111000000011111000011100000001111101111110000000111110000000000011111100000000000000001111100001111111111000000000111110000000000011111100000001111100000011111111000000000111110000011100;
    digits[33] = 189'b111111000000011111000011100001111111100001111100000000000000000000000011111000011111111111111100001111100111111000000001111110000000011111111000000000000000011111100000000111111000000011111;
    digits[34] = 189'b111111000000011111000011100001111111100001111100000000000000000000000011111000011111111111111100001111100111111000000001111110000000011111111000000000000000011111100000000111111000000011111;
    digits[35] = 189'b111111000000011111000011100001111111100001111100000000000000000000000011111000011111111111111100001111100111111000000001111110000000011111111000000000000000011111100000000111111000000011111;
    digits[36] = 189'b111111111111111100000000111111111110000000011111100000000000111111111111111011111100000000000000001111100000111110000111111111100000000011111111110000000000011111100000000111111000000011111;
    digits[37] = 189'b111111111111111100000000111111111110000000011111100000000000111111111111111011111100000000000000001111100000111110000111111111100000000011111111110000000000011111100000000111111000000011111;
    digits[38] = 189'b111111111111111100000000111111111110000000011111100000000000111111111111111011111100000000000000001111100000111110000111111111100000000011111111110000000000011111100000000111111000000011111;
    digits[39] = 189'b111111000000000000011111111111000011100000000011111000000111111000000011111011111100000000000001111111111111111110111111000000000000000000111111111110000000011111100000000111111000000011111;
    digits[40] = 189'b111111000000000000011111111111000011100000000011111000000111111000000011111011111100000000000001111111111111111110111111000000000000000000111111111110000000011111100000000111111000000011111;
    digits[41] = 189'b111111000000000000011111111111000011100000000011111000000111111000000011111011111100000000000001111111111111111110111111000000000000000000111111111110000000011111100000000111111000000011111;
    digits[42] = 189'b000111110000000000011111100000000011100000000011111000000111111000000011111011111100000001111100001111100000000000111111000000011111000000000001111111100000011111100000000000111000011111100;
    digits[43] = 189'b000111110000000000011111100000000011100000000011111000000111111000000011111011111100000001111100001111100000000000111111000000011111000000000001111111100000011111100000000000111000011111100;
    digits[44] = 189'b000111110000000000011111100000000011100000000011111000000111111000000011111011111100000001111100001111100000000000111111000000011111000000000001111111100000011111100000000000111000011111100;
    digits[45] = 189'b000001111111111100000011111111111110000000000011111000000000111111111111100000011111111111110000001111100000000000000111111111111100011111111111111111101111111111111111000000001111111100000;
    digits[46] = 189'b000001111111111100000011111111111110000000000011111000000000111111111111100000011111111111110000001111100000000000000111111111111100011111111111111111101111111111111111000000001111111100000;
    digits[47] = 189'b000001111111111100000011111111111110000000000011111000000000111111111111100000011111111111110000001111100000000000000111111111111100011111111111111111101111111111111111000000001111111100000;
    digits[48] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[49] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[50] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[51] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digits[52] = 189'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
end

endmodule

