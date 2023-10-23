module i2c_transmitter(
	input clk,
	output reg SCL,
	inout SDA,
	output reg byteSent,
	input [7:0] writeWord
);
	initial SCL <= 1'd1;
	
	reg SDA_out;
	initial SDA_out <= 1'd1;
	
	reg SDA_io;
	initial SDA_io <= 1'b1; // write
	assign SDA = SDA_io ? SDA_out : 1'bz;
	
	wire SDA_in;
	assign SDA_in = SDA;
	
	initial byteSent <= 1'd0;
	
	// -------------- Transmission state machine --------------
	
				 // Goes in cycle ->
	parameter START				= 4'd0;
	parameter SEND_BYTE			= 4'd1;
	parameter SEND_ACK_WAIT 	= 4'd2;
	parameter WAIT_FOR_ACK 		= 4'd3;
	
	// state machine reg
	reg [3:0] sendState;
	initial sendState = START;
	
	// frequency divider
	reg [2:0] counter;
	initial counter <= 8'd1;
	
	// bit to send
	reg [2:0] sendBitCounter; // max = 3'b000
	initial sendBitCounter <= 3'b111;
	
	always @(posedge clk) begin
		if(sendState == START) begin
			if(counter == 3'b100) begin
					SDA_out <= 1'b0;
				end
					else if(counter == 3'b111) begin
							SCL <= 1'b0;
							sendState <= SEND_BYTE;
						end
		end
			else if (counter == 3'd0) begin // SDA SET/RESET
				if(sendState == SEND_BYTE) begin
						if (sendBitCounter == 3'b000) begin
							sendBitCounter <= 3'b111;
							byteSent <= 1'd1;
							sendState <= SEND_ACK_WAIT;
						end
						SDA_out <= writeWord[sendBitCounter];
						sendBitCounter <= sendBitCounter - 1'b1;
					end
						else if(sendState == SEND_ACK_WAIT) begin
								SDA_io <= 1'b0; // read
								byteSent <= 1'd0;
								sendState <= WAIT_FOR_ACK;
							end
								else if(sendState == WAIT_FOR_ACK) begin
										if (SDA_in) begin
												sendState <= SEND_BYTE;
												SDA_io <= 1'b1; // write
											end
												else;
									end
				end
					else if(counter == 3'd2) begin // SCL SET
							if(sendState != WAIT_FOR_ACK)
								SCL <= 1'd1;
						end
							else if (counter == 3'd5) begin // SCL RESET
									SCL <= 1'd0;
								end
									else;
		counter = counter + 1'd1;
	end
	
endmodule