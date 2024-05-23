`default_nettype none

`define ASSERT(x) if (!(x)) begin \
    $display("Assert failed at line %d", `__LINE__); \
    $finish(1); 
end

module standard_tb (
    output logic [11:0] io_in,
    input  logic [11:0] io_out,
    input logic ready,
    input logic clock, reset
);

    // DUT controls
    logic read, write;
    logic [1:0] wires_in, wires_out, status;
    logic [3:0] data_in, data_out, mode, data_indx;

    always_comb begin
        // Inputs, tb outputs
        io_in[1:0]  = wires_in;
        io_in[5:2]  = data_in;
        io_in[9:6]  = mode;
        io_in[10]   = write;
        io_in[11]   = read;

        // Outputs, tb inputs
        status      = io_out[11:10];
        data_indx   = io_out[9:6];
        data_out    = io_out[5:2];
        wires_out   = io_out[1:0];
    end


    // Testbench transmitter instantiation
    logic send_packet, send_done;
    logic [3:0] send_PID, send_ENDP;
    logic [6:0] send_Addr;
    logic [63:0] send_Payload;

    PACKET_SEND test_transmitter(.PID(send_PID), .ENDP(send_ENDP), 
                                 .Addr(send_Addr), .Payload(send_Payload), 
                                 .wires_out(wires_in), .reset_n(~reset), .*);


    // Testbench receiver instantiation
    logic expect_packet, receive_done, had_errors;
    logic [3:0] recd_PID, recd_ENDP;
    logic [6:0] recd_Addr;
    logic [63:0] recd_Payload;

    PACKET_RECEIVE test_receiver(.PID(recd_PID), .ENDP(recd_ENDP), 
                                 .Addr(recd_Addr), .Payload(recd_Payload), 
                                 .wires_in(wires_out), .reset_n(~reset), .*);



    initial #100000 $finish(1); // Timeout


    // Change this for different packets
    logic [63:0] data_to_write, temp;
    assign data_to_write = 64'h40aa11b7682df6d8;
    
    initial begin

        // Setup
        read = '0; write   = '0;
        mode = '0; data_in = '0;
        expect_packet = '0; send_packet = '0;

        #100;
        while (!ready) @(negedge clock);

        // ENUMERATION:
        /*
            0 -> Do nothing
            1 -> Set Address
            2 -> Set ENDP
            3 -> Set Memory Address
            4 -> Set Data to write
            5 -> Output received data
            6 -> Output data to send
            7 -> Output {Addr, ENDP of Addr, ENDP of Data, Mempage}
        */

        // Input data
        $display("-------------");
        $display("INPUTING DATA");
        $display("-------------\n");

        // Input address
        mode = 4'd1; data_in = 4'd0;
        @(negedge clock); @(negedge clock);
        data_in = 4'd5; mode = '0;
        @(negedge clock); @(negedge clock);

        // Input ENDP
        mode = 4'd2; data_in = 4'd4;
        @(negedge clock); @(negedge clock);
        data_in = 4'd8; mode = '0;
        @(negedge clock); @(negedge clock);

        // Input Memory address
        mode = 4'd3; data_in = 4'd0;
        @(negedge clock); @(negedge clock);
        data_in = 4'hf; mode = '0;
        @(negedge clock); data_in = 4'h2;
        @(negedge clock); data_in = 4'h1;
        @(negedge clock); 

        // Input data to write
        temp = data_to_write;
        mode = 4'd4; @(negedge clock);
        mode = 4'd0;
        for (int i = 0; i < 16; i++) begin
            data_in = temp[63:60];
            @(negedge clock);
            temp = temp << 4;
        end


        // Ensure data is correct

        wait(status == '0);
        mode = 4'd6; temp = '0; @(negedge clock);
        mode = '0;

        for (int i = 0; i < 16; i++) begin
            temp = temp + (data_out << 4*i);
            @(negedge clock);
        end
        wait(status == '0);
        @(negedge clock);
        $display("\n-------------");
        $display("Data to write is %h \n", temp);

        mode = 4'd7; temp = '0; @(negedge clock);
        mode = '0; 
        for (int i = 0; i < 8; i++) begin
            temp = temp + (data_out << 4*i);
            @(negedge clock);
        end

        wait(status == '0);
        #1 $display("Writing to memory page %h, with data ENDP %h, address ENDP %h, and Address %h", 
                 temp[15:0], temp[19:16], temp[23:20], temp[31:24]);

        $display("-------------\n");

        $display("\n---------------");
        $display("INITIATE WRITE");
        $display("---------------\n");
        // Initiate write
        write = '1; expect_packet = '1;
        @(negedge clock); @(negedge clock);
        write = '0; 

        //         EXPECT *OUT*
        // PID: 1, Addr: 5, ENDP: 4, Payload: x, CRC5: 10, CRC16: x
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock); @(negedge clock);
        expect_packet = '1;


        //         EXPECT *DATA0*
        // PID: 3, Addr: x, ENDP: x, Payload: hf21000000000000, CRC5: x, CRC16: a0e7
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock);
        

        //         SEND *ACK*
        // PID: 2, Addr: x, ENDP: x, Payload: x, CRC5: x, CRC16: x  
        send_PID = 4'd2; send_Addr = 7'd5; send_ENDP = 4'd8; send_Payload = 64'h40aa11b7682df6d8;
        send_packet = '1; @(negedge clock);
        send_packet = '0;

        wait(send_done);
        #1 $display("Sent packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", send_PID, send_Addr, send_ENDP, send_Payload);
        expect_packet = '1;
        


        //         EXPECT *OUT*
        // PID: 1, Addr: 5, ENDP: 8, Payload: x, CRC5: he, CRC16: x
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock); @(negedge clock);
        expect_packet = '1;


        //         EXPECT *DATA0*
        // PID: 3, Addr: x, ENDP: x, Payload: h40aa11b7682df6d8, CRC5: x, CRC16: 544a
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock);


        //         SEND *ACK*
        // PID: 2, Addr: x, ENDP: x, Payload: x, CRC5: x, CRC16: x  
        send_PID = 4'd2; send_Addr = 7'd5; send_ENDP = 4'd8; send_Payload = 64'h40aa11b7682df6d8;
        send_packet = '1; @(negedge clock);
        send_packet = '0;

        wait(send_done);
        #1 $display("Sent packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", send_PID, send_Addr, send_ENDP, send_Payload);


        // Completed write
        #1 $display("\n\nCompleted Write at time %t\n\n", $time);

        wait(status == '0); $display("Currently idle at time %t", $time);



        $display("\n-------------");
        $display("INITIATE READ");
        $display("-------------\n");
        // Initiate read
        read = '1; expect_packet = '1;
        @(negedge clock); @(negedge clock);
        read = '0; 

        //         EXPECT *OUT*
        // PID: 1, Addr: 5, ENDP: 4, Payload: x, CRC5: 10, CRC16: x
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock); @(negedge clock);
        expect_packet = '1;

        //         EXPECT *DATA0*
        // PID: 3, Addr: x, ENDP: x, Payload: h40aa11b7682df6d8, CRC5: x, CRC16: 544a
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock);


        //         SEND *ACK*
        // PID: 2, Addr: x, ENDP: x, Payload: x, CRC5: x, CRC16: x  
        send_PID = 4'd2; send_Addr = 7'd5; send_ENDP = 4'd8; send_Payload = 64'h40aa11b7682df6d8;
        send_packet = '1; @(negedge clock);
        send_packet = '0;

        wait(send_done);
        #1 $display("Sent packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", send_PID, send_Addr, send_ENDP, send_Payload);
        expect_packet = '1;


        //         EXPECT *IN*
        // PID: 1, Addr: 9, ENDP: 8, Payload: x, CRC5: 0e, CRC16: x
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock);

        

        //         SEND *DATA0*
        // PID: 3, Addr: x, ENDP: x, Payload: h40aa11b7682df6d8, CRC5: x, CRC16: 544a 
        send_PID = 4'd3; send_Addr = 7'd5; send_ENDP = 4'd8; send_Payload = 64'h40aa11b7682df6d8;
        send_packet = '1; @(negedge clock);
        send_packet = '0;

        wait(send_done);
        #1 $display("Sent packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", send_PID, send_Addr, send_ENDP, send_Payload);
        expect_packet = '1;

        
        //         EXPECT *ACK*
        // PID: 2, Addr: x, ENDP: x, Payload: x, CRC5: x, CRC16: x
        wait(receive_done);
        expect_packet = '0;
        #1 $display("Received packet with PID: %h, Addr: %h, ENDP: %h, Payload: %h\n", recd_PID, recd_Addr, recd_ENDP, recd_Payload);
        @(negedge clock);

        // Completed read
        #1 $display("\n\nCompleted Read at time %t\n\n", $time);

        wait(status == '0); $display("Currently idle at time %t\n", $time);


        // Output received data
        @(negedge clock);
        mode = 4'd5; temp = '0; @(negedge clock);
        mode = '0; 

        for (int i = 0; i < 16; i++) begin
            temp = temp + (data_out << 4*i);
            @(negedge clock);
        end
        wait(status == '0);
        @(negedge clock);
        $display("Received data was %h \n", temp);

        $finish(0);
    end
endmodule: standard_tb

module WIRE_LISTENER_tb (
	clock,
	reset_n,
	wires_in,
	bit_out,
	invalid,
	saw_eop
);
	input wire clock;
	input wire reset_n;
	input wire [1:0] wires_in;
	output reg bit_out;
	output reg invalid;
	output wire saw_eop;
	wire dp;
	wire dm;
	assign dp = wires_in[1];
	assign dm = wires_in[0];
	reg [2:0] dp_log;
	reg [2:0] dm_log;
	always @(posedge clock or negedge reset_n)
		if (!reset_n) begin
			dp_log <= 1'sb0;
			dm_log <= 1'sb0;
		end
		else begin
			dp_log <= (dp_log << 1) + dp;
			dm_log <= (dm_log << 1) + dm;
		end
	always @(*)
		case ({dp, dm})
			2'b00: begin
				bit_out = 1'sb0;
				invalid = 1'sb1;
			end
			2'b01: begin
				bit_out = 1'sb0;
				invalid = 1'sb0;
			end
			2'b10: begin
				bit_out = 1'sb1;
				invalid = 1'sb0;
			end
			2'b11: begin
				bit_out = 1'sb1;
				invalid = 1'sb1;
			end
		endcase
	assign saw_eop = (dp_log == 3'b001) & (dm_log == 3'b000);
endmodule
module SYNC_DETECTOR_tb (
	clock,
	reset_n,
	bit_in,
	saw_sync
);
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	output wire saw_sync;
	reg [7:0] log;
	always @(posedge clock or negedge reset_n)
		if (!reset_n)
			log <= 1'sb0;
		else
			log <= (log << 1) + bit_in;
	assign saw_sync = (log[6:0] == 7'b0101010) & (bit_in == 1'b0);
endmodule
module NRZI_DECODER_tb (
	clock,
	reset_n,
	bit_in,
	en,
	init,
	bit_out
);
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	input wire en;
	input wire init;
	output wire bit_out;
	reg cur_value;
	wire cur_value_next;
	assign bit_out = cur_value == bit_in;
	assign cur_value_next = bit_in;
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			cur_value <= 1'sb1;
		else if (en)
			cur_value <= (init ? 1'b0 : cur_value_next);
		else
			cur_value <= cur_value;
endmodule
module BIT_UNSTUFFER_tb (
	clock,
	reset_n,
	en,
	bit_in,
	hard_init,
	bit_out,
	is_stuffing
);
	input wire clock;
	input wire reset_n;
	input wire en;
	input wire bit_in;
	input wire hard_init;
	output reg bit_out;
	output reg is_stuffing;
	reg [2:0] count;
	reg [2:0] count_next;
	always @(*)
		if (count == 3'd6) begin
			bit_out = 1'sb0;
			count_next = 1'sb0;
			is_stuffing = 1'sb1;
		end
		else begin
			bit_out = bit_in;
			count_next = (bit_in ? count + 1 : {3 {1'sb0}});
			is_stuffing = 1'sb0;
		end
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			count <= 1'sb0;
		else if (hard_init)
			count <= 1'sb0;
		else
			count <= (en ? count_next : count);
endmodule
module PACKET_RECEIVER_tb (
	clock,
	reset_n,
	bit_in,
	phase,
	pid,
	pid_to_fsm,
	addr_endp,
	payload,
	PID_ERROR
);
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	input wire [1:0] phase;
	output wire [3:0] pid;
	output wire [3:0] pid_to_fsm;
	output wire [10:0] addr_endp;
	output wire [63:0] payload;
	output wire PID_ERROR;
	wire [1:0] temp;
	reg [7:0] PID_accum;
	reg [10:0] ADDR_ENDP_accum;
	reg [63:0] PAYLOAD_accum;
	wire [3:0] pid_inv;
	assign pid = PID_accum[3:0];
	assign pid_inv = PID_accum[7:4];
	assign addr_endp = ADDR_ENDP_accum;
	assign payload = PAYLOAD_accum;
	assign pid_to_fsm = PID_accum[4:1];
	assign PID_ERROR = PID_accum[3:0] != PID_accum[7:4];
	always @(posedge clock or negedge reset_n)
		if (!reset_n) begin
			PID_accum <= 1'sb0;
			ADDR_ENDP_accum <= 1'sb0;
			PAYLOAD_accum <= 1'sb0;
		end
		else
			case (phase)
				2'd0: begin
					PID_accum <= PID_accum;
					ADDR_ENDP_accum <= ADDR_ENDP_accum;
					PAYLOAD_accum <= PAYLOAD_accum;
				end
				2'd1: begin
					PID_accum <= {bit_in, PID_accum[7:1]};
					ADDR_ENDP_accum <= ADDR_ENDP_accum;
					PAYLOAD_accum <= PAYLOAD_accum;
				end
				2'd2: begin
					PID_accum <= PID_accum;
					ADDR_ENDP_accum <= {bit_in, ADDR_ENDP_accum[10:1]};
					PAYLOAD_accum <= PAYLOAD_accum;
				end
				2'd3: begin
					PID_accum <= PID_accum;
					ADDR_ENDP_accum <= ADDR_ENDP_accum;
					PAYLOAD_accum <= {bit_in, PAYLOAD_accum[63:1]};
				end
			endcase
endmodule
module PACKET_RECEIVE_MANAGER_tb (
	clock,
	reset_n,
	saw_sync,
	saw_eop,
	pause,
	enable,
	PID,
	packet_phase,
	crc_select,
	crc_init,
	crc_pause,
	stuff_en,
	nrzi_en,
	nrzi_init,
	hard_init,
	send_done
);
	input wire clock;
	input wire reset_n;
	input wire saw_sync;
	input wire saw_eop;
	input wire pause;
	input wire enable;
	input wire [3:0] PID;
	output reg [1:0] packet_phase;
	output reg crc_select;
	output reg crc_init;
	output reg crc_pause;
	output reg stuff_en;
	output reg nrzi_en;
	output reg nrzi_init;
	output reg hard_init;
	output reg send_done;
	reg [2:0] cur_state;
	reg [2:0] next_state;
	reg [6:0] count;
	reg [6:0] count_next;
	always @(*)
		case (cur_state)
			3'b000: begin
				next_state = (saw_sync & enable ? 3'd1 : 3'b000);
				count_next = 1'sb0;
			end
			3'd1:
				if (count == 7'd7) begin
					count_next = 1'sb0;
					if ((PID == 4'b1001) || (PID == 4'b0001))
						next_state = 3'd2;
					else if (PID == 4'b0011)
						next_state = 3'd3;
					else if ((PID == 4'b1010) || (PID == 4'b0010))
						next_state = 3'd6;
					else
						next_state = 3'd7;
				end
				else begin
					next_state = 3'd1;
					count_next = count + 1;
				end
			3'd2: begin
				next_state = ((count == 7'd10) && ~pause ? 3'd4 : 3'd2);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd10 ? {7 {1'sb0}} : count + 1);
			end
			3'd3: begin
				next_state = ((count == 7'd63) && ~pause ? 3'd5 : 3'd3);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd63 ? {7 {1'sb0}} : count + 1);
			end
			3'd4: begin
				next_state = ((count == 7'd4) && ~pause ? 3'd6 : 3'd4);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd4 ? {7 {1'sb0}} : count + 1);
			end
			3'd5: begin
				next_state = ((count == 7'd15) && ~pause ? 3'd6 : 3'd5);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd15 ? {7 {1'sb0}} : count + 1);
			end
			3'd6: begin
				next_state = (count == 7'd2 ? 3'b000 : 3'd6);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd2 ? {7 {1'sb0}} : count + 1);
			end
			3'd7: begin
				next_state = (saw_eop ? 3'b000 : 3'd7);
				count_next = (saw_eop ? {7 {1'sb0}} : count + 1);
			end
		endcase
	always @(*) begin
		packet_phase = 1'sb0;
		crc_select = 1'sb0;
		crc_init = 1'sb1;
		stuff_en = 1'sb0;
		nrzi_en = 1'sb1;
		nrzi_init = 1'sb1;
		send_done = 1'sb0;
		hard_init = 1'sb0;
		crc_pause = pause;
		case (cur_state)
			3'b000: begin
				packet_phase = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb1;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				nrzi_init = ~(saw_sync & enable);
				send_done = 1'sb0;
				hard_init = 1'sb1;
			end
			3'd1: begin
				packet_phase = (pause ? {2 {1'sb0}} : 2'd1);
				crc_select = 1'sb0;
				crc_init = 1'sb1;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = 1'sb0;
				crc_pause = pause;
			end
			3'd2: begin
				packet_phase = (pause ? {2 {1'sb0}} : 2'd2);
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = 1'sb0;
				crc_pause = pause;
			end
			3'd3: begin
				packet_phase = (pause ? {2 {1'sb0}} : 2'd3);
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = 1'sb0;
				crc_pause = pause;
			end
			3'd4: begin
				packet_phase = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = 1'sb0;
				crc_pause = pause;
			end
			3'd5: begin
				packet_phase = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = 1'sb0;
				crc_pause = pause;
			end
			3'd6: begin
				packet_phase = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				send_done = count == 7'd2;
				crc_pause = 1'sb1;
				hard_init = 1'sb1;
			end
			3'd7: begin
				packet_phase = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb0;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				nrzi_init = 1'sb0;
				crc_pause = 1'sb1;
				send_done = saw_eop;
			end
		endcase
	end
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			cur_state <= 3'b000;
		else
			cur_state <= next_state;
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			count <= 1'sb0;
		else
			count <= count_next;
endmodule
module CRC_DRIVER_RECEIVE_tb (
	clock,
	reset_n,
	select_crc,
	init,
	pause,
	bit_in,
	index,
	bit_out,
	residue_match5,
	residue_match16
);
	input wire clock;
	input wire reset_n;
	input wire select_crc;
	input wire init;
	input wire pause;
	input wire bit_in;
	input wire [6:0] index;
	output wire bit_out;
	output wire residue_match5;
	output wire residue_match16;
	wire en;
	assign en = ~pause;
	wire [4:0] crc5_out;
	reg [4:0] crc5_out_inv;
	wire [15:0] crc16_out;
	reg [15:0] crc16_out_inv;
	always @(*) begin
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 5; i = i + 1)
				crc5_out_inv[i] = ~crc5_out[i];
		end
		begin : sv2v_autoblock_2
			reg signed [31:0] j;
			for (j = 0; j < 16; j = j + 1)
				crc16_out_inv[j] = ~crc16_out[j];
		end
	end
	CRC5_tb crc5(
		.residue_match(residue_match5),
		.clock(clock),
		.reset_n(reset_n),
		.bit_in(bit_in),
		.en(en),
		.init(init),
		.crc5_out(crc5_out)
	);
	CRC16_tb crc16(
		.residue_match(residue_match16),
		.clock(clock),
		.reset_n(reset_n),
		.bit_in(bit_in),
		.en(en),
		.init(init),
		.crc16_out(crc16_out)
	);
	assign bit_out = (select_crc ? crc5_out_inv[4 - index] : crc16_out_inv[15 - index]);
endmodule
module PACKET_RECEIVE_tb (
	clock,
	reset_n,
	expect_packet,
	PID,
	ENDP,
	Addr,
	Payload,
	receive_done,
	had_errors,
	wires_in
);
	input wire clock;
	input wire reset_n;
	input wire expect_packet;
	output wire [3:0] PID;
	output wire [3:0] ENDP;
	output wire [6:0] Addr;
	output wire [63:0] Payload;
	output wire receive_done;
	output wire had_errors;
	input wire [1:0] wires_in;
	wire wire_out;
	wire saw_eop;
	WIRE_LISTENER_tb wire_in(
		.bit_out(wire_out),
		.invalid(),
		.clock(clock),
		.reset_n(reset_n),
		.wires_in(wires_in),
		.saw_eop(saw_eop)
	);
	wire saw_sync;
	SYNC_DETECTOR_tb find_sync(
		.bit_in(wire_out),
		.clock(clock),
		.reset_n(reset_n),
		.saw_sync(saw_sync)
	);
	wire nrzi_out;
	wire nrzi_en;
	wire nrzi_init;
	NRZI_DECODER_tb nrzi(
		.bit_in(wire_out),
		.bit_out(nrzi_out),
		.en(nrzi_en),
		.init(nrzi_init),
		.clock(clock),
		.reset_n(reset_n)
	);
	wire stuff_out;
	wire stuff_en;
	wire pause;
	wire hard_init;
	BIT_UNSTUFFER_tb bit_unstuff(
		.bit_in(nrzi_out),
		.bit_out(stuff_out),
		.en(stuff_en),
		.is_stuffing(pause),
		.clock(clock),
		.reset_n(reset_n),
		.hard_init(hard_init)
	);
	wire [1:0] phase;
	wire [3:0] pid;
	wire [3:0] pid_to_fsm;
	wire [10:0] addr_endp;
	wire [63:0] payload;
	wire PID_ERROR;
	PACKET_RECEIVER_tb packet_decode(
		.bit_in(stuff_out),
		.clock(clock),
		.reset_n(reset_n),
		.phase(phase),
		.pid(pid),
		.pid_to_fsm(pid_to_fsm),
		.addr_endp(addr_endp),
		.payload(payload),
		.PID_ERROR(PID_ERROR)
	);
	wire crc_select;
	wire crc_init;
	wire residue_match5;
	wire residue_match16;
	wire crc_pause;
	localparam [6:0] sv2v_uu_crc_ext_index_0 = 1'sb0;
	CRC_DRIVER_RECEIVE_tb crc(
		.bit_in(stuff_out),
		.bit_out(),
		.index(sv2v_uu_crc_ext_index_0),
		.select_crc(crc_select),
		.init(crc_init),
		.pause(crc_pause),
		.clock(clock),
		.reset_n(reset_n),
		.residue_match5(residue_match5),
		.residue_match16(residue_match16)
	);
	PACKET_RECEIVE_MANAGER_tb fsm(
		.enable(expect_packet),
		.PID(pid_to_fsm),
		.send_done(receive_done),
		.packet_phase(phase),
		.clock(clock),
		.reset_n(reset_n),
		.saw_sync(saw_sync),
		.saw_eop(saw_eop),
		.pause(pause),
		.crc_select(crc_select),
		.crc_init(crc_init),
		.crc_pause(crc_pause),
		.stuff_en(stuff_en),
		.nrzi_en(nrzi_en),
		.nrzi_init(nrzi_init),
		.hard_init(hard_init)
	);
	assign PID = pid;
	assign Addr = addr_endp[6:0];
	assign ENDP = addr_endp[10:7];
	assign Payload = payload;
	assign had_errors = (~residue_match5 & ~residue_match16) & receive_done;
endmodule

module PACKET_SEND_tb (
	clock,
	reset_n,
	send_packet,
	PID,
	ENDP,
	Addr,
	Payload,
	send_done,
	wires_out
);
	input wire clock;
	input wire reset_n;
	input wire send_packet;
	input wire [3:0] PID;
	input wire [3:0] ENDP;
	input wire [6:0] Addr;
	input wire [63:0] Payload;
	output wire send_done;
	output wire [1:0] wires_out;
	wire pause;
	wire encoder_or_crc;
	wire bit_to_stuff;
	wire crc_select;
	wire crc_init;
	wire stuff_en;
	wire nrzi_en;
	wire wire_en;
	wire is_eop;
	wire packet_pause;
	wire crc_pause;
	wire hard_init;
	wire packet_out;
	wire crc_out;
	wire stuff_out;
	wire nrzi_out;
	wire nrzi_init;
	wire [6:0] crc_index;
	wire [6:0] packet_index;
	wire [1:0] packet_phase;
	assign bit_to_stuff = (encoder_or_crc ? packet_out : crc_out);
	PACKET_SEND_MANAGER_tb fsm(
		.clock(clock),
		.reset_n(reset_n),
		.pause(pause),
		.send_packet(send_packet),
		.PID(PID),
		.encoder_or_crc(encoder_or_crc),
		.crc_select(crc_select),
		.crc_init(crc_init),
		.hard_init(hard_init),
		.stuff_en(stuff_en),
		.nrzi_en(nrzi_en),
		.nrzi_init(nrzi_init),
		.wire_en(wire_en),
		.is_eop(is_eop),
		.packet_pause(packet_pause),
		.crc_pause(crc_pause),
		.packet_index(packet_index),
		.crc_index(crc_index),
		.packet_phase(packet_phase),
		.send_done(send_done)
	);
	PACKET_ENCODER_tb encoder(
		.pause(packet_pause),
		.index(packet_index),
		.phase(packet_phase),
		.bit_out(packet_out),
		.clock(clock),
		.reset_n(reset_n),
		.PID(PID),
		.Addr(Addr),
		.ENDP(ENDP),
		.Payload(Payload)
	);
	CRC_DRIVER_tb crc(
		.bit_in(packet_out),
		.select_crc(crc_select),
		.init(crc_init),
		.pause(crc_pause),
		.index(crc_index),
		.bit_out(crc_out),
		.clock(clock),
		.reset_n(reset_n)
	);
	BIT_STUFFER_tb bit_stuff(
		.bit_in(bit_to_stuff),
		.en(stuff_en),
		.bit_out(stuff_out),
		.is_stuffing(pause),
		.clock(clock),
		.reset_n(reset_n),
		.hard_init(hard_init)
	);
	NRZI_tb nrzi(
		.bit_in(stuff_out),
		.en(nrzi_en),
		.init(nrzi_init),
		.bit_out(nrzi_out),
		.clock(clock),
		.reset_n(reset_n)
	);
	WIRE_DRIVER_tb out_wire(
		.bit_in(nrzi_out),
		.en(wire_en),
		.wires_out(wires_out),
		.clock(clock),
		.reset_n(reset_n),
		.is_eop(is_eop)
	);
endmodule
module CRC5_tb (
	clock,
	reset_n,
	bit_in,
	en,
	init,
	crc5_out,
	residue_match
);
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	input wire en;
	input wire init;
	output reg [4:0] crc5_out;
	output wire residue_match;
	wire x1;
	assign x1 = bit_in ^ crc5_out[4];
	assign residue_match = crc5_out == 5'b01100;
	always @(posedge clock or negedge reset_n)
		if (~reset_n) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 5; i = i + 1)
				crc5_out[i] <= 1'sb1;
		end
		else if (init) begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 5; i = i + 1)
				crc5_out[i] <= 1'sb1;
		end
		else begin
			crc5_out[0] <= (en ? x1 : crc5_out[0]);
			crc5_out[2] <= (en ? crc5_out[1] ^ x1 : crc5_out[2]);
			crc5_out[1] <= (en ? crc5_out[0] : crc5_out[1]);
			crc5_out[3] <= (en ? crc5_out[2] : crc5_out[3]);
			crc5_out[4] <= (en ? crc5_out[3] : crc5_out[4]);
		end
endmodule
module CRC16_tb (
	clock,
	reset_n,
	bit_in,
	en,
	init,
	crc16_out,
	residue_match
);
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	input wire en;
	input wire init;
	output reg [15:0] crc16_out;
	output wire residue_match;
	wire x1;
	assign x1 = bit_in ^ crc16_out[15];
	assign residue_match = crc16_out == 16'h800d;
	always @(posedge clock or negedge reset_n)
		if (~reset_n) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 16; i = i + 1)
				crc16_out[i] <= 1'sb1;
		end
		else if (init) begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 16; i = i + 1)
				crc16_out[i] <= 1'sb1;
		end
		else begin
			crc16_out[0] <= (en ? x1 : crc16_out[0]);
			crc16_out[2] <= (en ? crc16_out[1] ^ x1 : crc16_out[2]);
			crc16_out[15] <= (en ? crc16_out[14] ^ x1 : crc16_out[15]);
			crc16_out[1] <= (en ? crc16_out[0] : crc16_out[1]);
			crc16_out[3] <= (en ? crc16_out[2] : crc16_out[3]);
			crc16_out[4] <= (en ? crc16_out[3] : crc16_out[4]);
			crc16_out[5] <= (en ? crc16_out[4] : crc16_out[5]);
			crc16_out[6] <= (en ? crc16_out[5] : crc16_out[6]);
			crc16_out[7] <= (en ? crc16_out[6] : crc16_out[7]);
			crc16_out[8] <= (en ? crc16_out[7] : crc16_out[8]);
			crc16_out[9] <= (en ? crc16_out[8] : crc16_out[9]);
			crc16_out[10] <= (en ? crc16_out[9] : crc16_out[10]);
			crc16_out[11] <= (en ? crc16_out[10] : crc16_out[11]);
			crc16_out[12] <= (en ? crc16_out[11] : crc16_out[12]);
			crc16_out[13] <= (en ? crc16_out[12] : crc16_out[13]);
			crc16_out[14] <= (en ? crc16_out[13] : crc16_out[14]);
		end
endmodule
module CRC_DRIVER_tb (
	clock,
	reset_n,
	select_crc,
	init,
	pause,
	bit_in,
	index,
	bit_out
);
	input wire clock;
	input wire reset_n;
	input wire select_crc;
	input wire init;
	input wire pause;
	input wire bit_in;
	input wire [6:0] index;
	output wire bit_out;
	wire en;
	wire residue_match5;
	wire residue_match16;
	assign en = ~pause;
	wire [4:0] crc5_out;
	reg [4:0] crc5_out_inv;
	wire [15:0] crc16_out;
	reg [15:0] crc16_out_inv;
	always @(*) begin
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 5; i = i + 1)
				crc5_out_inv[i] = ~crc5_out[i];
		end
		begin : sv2v_autoblock_2
			reg signed [31:0] j;
			for (j = 0; j < 16; j = j + 1)
				crc16_out_inv[j] = ~crc16_out[j];
		end
	end
	CRC5_tb crc5(
		.residue_match(residue_match5),
		.clock(clock),
		.reset_n(reset_n),
		.bit_in(bit_in),
		.en(en),
		.init(init),
		.crc5_out(crc5_out)
	);
	CRC16_tb crc16(
		.residue_match(residue_match16),
		.clock(clock),
		.reset_n(reset_n),
		.bit_in(bit_in),
		.en(en),
		.init(init),
		.crc16_out(crc16_out)
	);
	assign bit_out = (select_crc ? crc5_out_inv[4 - index] : crc16_out_inv[15 - index]);
endmodule
module PACKET_SEND_MANAGER_tb (
	clock,
	reset_n,
	pause,
	send_packet,
	PID,
	encoder_or_crc,
	crc_select,
	crc_init,
	hard_init,
	stuff_en,
	nrzi_en,
	nrzi_init,
	wire_en,
	is_eop,
	packet_pause,
	crc_pause,
	packet_index,
	crc_index,
	packet_phase,
	send_done
);
	input wire clock;
	input wire reset_n;
	input wire pause;
	input wire send_packet;
	input wire [3:0] PID;
	output reg encoder_or_crc;
	output reg crc_select;
	output reg crc_init;
	output reg hard_init;
	output reg stuff_en;
	output reg nrzi_en;
	output reg nrzi_init;
	output reg wire_en;
	output reg is_eop;
	output reg packet_pause;
	output reg crc_pause;
	output reg [6:0] packet_index;
	output reg [6:0] crc_index;
	output reg [1:0] packet_phase;
	output reg send_done;
	reg [2:0] cur_state;
	reg [2:0] next_state;
	reg [6:0] count;
	reg [6:0] count_next;
	always @(*)
		case (cur_state)
			3'b000: begin
				next_state = (send_packet ? 3'b001 : 3'b000);
				count_next = 1'sb0;
			end
			3'b001: begin
				next_state = (count == 7'd7 ? 3'd2 : 3'b001);
				count_next = (count == 7'd7 ? {7 {1'sb0}} : count + 1);
			end
			3'd2:
				if (count == 7'd7) begin
					count_next = 1'sb0;
					if ((PID == 4'b1001) || (PID == 4'b0001))
						next_state = 3'd3;
					else if (PID == 4'b0011)
						next_state = 3'd5;
					else
						next_state = 3'd7;
				end
				else begin
					next_state = 3'd2;
					count_next = count + 1;
				end
			3'd3: begin
				next_state = ((count == 7'd10) && ~pause ? 3'd4 : 3'd3);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd10 ? {7 {1'sb0}} : count + 1);
			end
			3'd4: begin
				next_state = ((count == 7'd4) && ~pause ? 3'd7 : 3'd4);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd4 ? {7 {1'sb0}} : count + 1);
			end
			3'd6: begin
				next_state = ((count == 7'd15) && ~pause ? 3'd7 : 3'd6);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd15 ? {7 {1'sb0}} : count + 1);
			end
			3'd5: begin
				next_state = ((count == 7'd63) && ~pause ? 3'd6 : 3'd5);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd63 ? {7 {1'sb0}} : count + 1);
			end
			3'd7: begin
				next_state = (count == 7'd2 ? 3'b000 : 3'd7);
				if (pause)
					count_next = count;
				else
					count_next = (count == 7'd2 ? {7 {1'sb0}} : count + 1);
			end
		endcase
	always @(*) begin
		encoder_or_crc = 1'sb1;
		packet_index = 1'sb0;
		packet_phase = 1'sb0;
		crc_index = 1'sb0;
		crc_select = 1'sb0;
		crc_init = 1'sb1;
		stuff_en = 1'sb0;
		nrzi_en = 1'sb0;
		nrzi_init = 1'sb0;
		wire_en = 1'sb0;
		is_eop = 1'sb0;
		send_done = 1'sb0;
		hard_init = 1'sb0;
		packet_pause = pause;
		crc_pause = pause;
		case (cur_state)
			3'b000: begin
				packet_index = 1'sb0;
				crc_index = 1'sb0;
				crc_select = 1'sb0;
				crc_init = 1'sb1;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb0;
				wire_en = 1'sb0;
				packet_phase = 1'sb0;
				nrzi_init = 1'sb1;
				hard_init = 1'sb1;
			end
			3'b001: begin
				packet_index = count;
				packet_phase = 2'b11;
				encoder_or_crc = 1'sb1;
				crc_pause = 1'sb1;
				crc_init = 1'sb1;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd2: begin
				packet_index = count;
				packet_phase = 1'sb0;
				encoder_or_crc = 1'sb1;
				crc_pause = 1'sb1;
				crc_init = 1'sb1;
				stuff_en = 1'sb0;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd3: begin
				packet_index = count;
				packet_phase = 2'b01;
				encoder_or_crc = 1'sb1;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd5: begin
				packet_index = count;
				packet_phase = 2'b10;
				encoder_or_crc = 1'sb1;
				crc_init = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd4: begin
				crc_index = count;
				encoder_or_crc = 1'sb0;
				crc_init = 1'sb0;
				crc_pause = 1'sb1;
				crc_select = 1'sb1;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd6: begin
				crc_index = count;
				encoder_or_crc = 1'sb0;
				crc_init = 1'sb0;
				crc_pause = 1'sb1;
				crc_select = 1'sb0;
				stuff_en = 1'sb1;
				nrzi_en = 1'sb1;
				wire_en = 1'sb1;
			end
			3'd7: begin
				wire_en = 1'sb1;
				is_eop = ~pause;
				stuff_en = count == {7 {1'sb0}};
				send_done = count == 7'd2;
				crc_init = 1'sb1;
				hard_init = 1'sb1;
			end
		endcase
	end
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			cur_state <= 3'b000;
		else
			cur_state <= next_state;
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			count <= 1'sb0;
		else
			count <= count_next;
endmodule
module PACKET_ENCODER_tb (
	clock,
	reset_n,
	pause,
	PID,
	Addr,
	ENDP,
	Payload,
	index,
	phase,
	bit_out
);
	input wire clock;
	input wire reset_n;
	input wire pause;
	input wire [3:0] PID;
	input wire [6:0] Addr;
	input wire [3:0] ENDP;
	input wire [63:0] Payload;
	input wire [6:0] index;
	input wire [1:0] phase;
	output reg bit_out;
	reg [95:0] data_register;
	reg [15:0] acknak_register;
	reg [26:0] inout_register;
	reg [3:0] PID_lsb;
	reg [3:0] PID_lsb_inv;
	reg [3:0] ENDP_lsb;
	reg [6:0] Addr_lsb;
	reg [63:0] Payload_lsb;
	reg [7:0] SYNC;
	reg [7:0] PID_full;
	reg [10:0] Addr_Endp_register;
	always @(*) begin
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 4; i = i + 1)
				begin
					PID_lsb[i] = PID[3 - i];
					PID_lsb_inv[i] = ~PID[3 - i];
					ENDP_lsb[i] = ENDP[3 - i];
				end
		end
		begin : sv2v_autoblock_2
			reg signed [31:0] j;
			for (j = 0; j < 7; j = j + 1)
				Addr_lsb[j] = Addr[6 - j];
		end
		begin : sv2v_autoblock_3
			reg signed [31:0] k;
			for (k = 0; k < 64; k = k + 1)
				Payload_lsb[k] = Payload[63 - k];
		end
		SYNC = 8'b00000001;
		PID_full = {PID_lsb, PID_lsb_inv};
		Addr_Endp_register = {Addr_lsb, ENDP_lsb};
	end
	always @(*) begin
		inout_register = 1'sb0;
		data_register = 1'sb0;
		acknak_register = 1'sb0;
		if ((PID == 4'b1001) || (PID == 4'b0001))
			inout_register = {SYNC, PID_lsb, PID_lsb_inv, Addr_lsb, ENDP_lsb};
		else if (PID == 4'b0011)
			data_register = {SYNC, PID_lsb, PID_lsb_inv, Payload_lsb};
		else if ((PID == 4'b0010) || (PID == 4'b1010))
			acknak_register = {SYNC, PID_lsb, PID_lsb_inv};
		else begin
			inout_register = 1'sb0;
			data_register = 1'sb0;
			acknak_register = 1'sb0;
		end
	end
	always @(*)
		if (phase == 2'b00)
			bit_out = PID_full[7 - index];
		else if (phase == 2'b01)
			bit_out = Addr_Endp_register[10 - index];
		else if (phase == 2'b10)
			bit_out = Payload_lsb[63 - index];
		else
			bit_out = SYNC[7 - index];
endmodule
module BIT_STUFFER_tb (
	bit_in,
	en,
	clock,
	reset_n,
	hard_init,
	bit_out,
	is_stuffing
);
	input wire bit_in;
	input wire en;
	input wire clock;
	input wire reset_n;
	input wire hard_init;
	output reg bit_out;
	output reg is_stuffing;
	reg [2:0] count;
	reg [2:0] count_next;
	always @(*)
		if (count == 3'd6) begin
			bit_out = 1'sb0;
			count_next = 1'sb0;
			is_stuffing = 1'sb1;
		end
		else begin
			bit_out = bit_in;
			count_next = (bit_in ? count + 1 : {3 {1'sb0}});
			is_stuffing = 1'sb0;
		end
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			count <= 1'sb0;
		else if (hard_init)
			count <= 1'sb0;
		else
			count <= (en ? count_next : count);
endmodule
module NRZI_tb (
	bit_in,
	en,
	init,
	clock,
	reset_n,
	bit_out
);
	input wire bit_in;
	input wire en;
	input wire init;
	input wire clock;
	input wire reset_n;
	output wire bit_out;
	reg cur_value;
	wire cur_value_next;
	assign bit_out = (bit_in ? cur_value : ~cur_value);
	assign cur_value_next = bit_out;
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			cur_value <= 1'sb1;
		else if (init)
			cur_value <= 1'sb1;
		else
			cur_value <= (en ? cur_value_next : cur_value);
endmodule
module WIRE_DRIVER_tb (
	wires_out,
	clock,
	reset_n,
	bit_in,
	is_eop,
	en
);
	output wire [1:0] wires_out;
	input wire clock;
	input wire reset_n;
	input wire bit_in;
	input wire is_eop;
	input wire en;
	reg [1:0] cur_state;
	reg [1:0] next_state;
	reg drive_dp;
	reg drive_dm;
	assign wires_out[1] = (en ? drive_dp : 1'b1);
	assign wires_out[0] = (en ? drive_dm : 1'b0);
	always @(*)
		if (~en)
			next_state = 2'b00;
		else if (cur_state == 2'b00)
			next_state = 2'b01;
		else if (cur_state == 2'b01)
			next_state = (is_eop ? 2'b10 : 2'b01);
		else if (cur_state == 2'b10)
			next_state = 2'b11;
		else
			next_state = 2'b00;
	always @(*)
		case (cur_state)
			2'b00:
				if (en) begin
					drive_dp = 1'sb0;
					drive_dm = 1'sb1;
				end
				else begin
					drive_dp = 1'sb1;
					drive_dm = 1'sb1;
				end
			2'b01:
				if (~is_eop) begin
					if (bit_in) begin
						drive_dp = 1'sb1;
						drive_dm = 1'sb0;
					end
					else begin
						drive_dp = 1'sb0;
						drive_dm = 1'sb1;
					end
				end
				else begin
					drive_dp = 1'sb0;
					drive_dm = 1'sb0;
				end
			2'b10: begin
				drive_dp = 1'sb0;
				drive_dm = 1'sb0;
			end
			2'b11: begin
				drive_dp = 1'sb1;
				drive_dm = 1'sb0;
			end
			default: begin
				drive_dp = 1'sb1;
				drive_dm = 1'sb1;
			end
		endcase
	always @(posedge clock or negedge reset_n)
		if (~reset_n)
			cur_state <= 2'b00;
		else
			cur_state <= (en ? next_state : cur_state);
endmodule