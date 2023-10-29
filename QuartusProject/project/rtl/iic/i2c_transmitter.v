module i2c_transmitter(
	input clk,
	input [7:0] writeWord,
	input reset,
	output reg readyTransmit,
	output reg SCL,
	inout SDA
);
	initial SCL <= 1'b1;
	
	initial readyTransmit <= 1'b0;
	
	reg internalReadyTransmitFlag;
	initial internalReadyTransmitFlag <= 1'd0;
	
	reg internalAckReceivedFlag;
	initial internalAckReceivedFlag <= 1'd0;
	
	// -------------- INOUT SDA declaration --------------
	
	reg SDA_io; // bus direction
	initial SDA_io <= 1'b1; // write direction
	assign SDA = SDA_io ? SDA_out : 1'bz;
	
	reg SDA_out; // to PCF8591
	initial SDA_out <= 1'b1;
	
	wire SDA_in; // from PCF8591
	assign SDA_in = SDA;
	
	// -------------- Transmission state machine --------------
	
		// Goes in cycle ->
	parameter START				= 2'b00; /* SDA to low -> wait for (t_scl / 2) -> SCL to low -> wait for (t_scl / 2) -> SEND_BYTE */
	parameter SEND_BYTE			= 2'b01;
	parameter GET_ACK		 	= 2'b10;
	
	// state machine reg
	reg [1:0] sendState;
	initial sendState <= START;
	
	// -------------- Counters --------------
	
	/* frequency divider
		SCL time:
			set high on counter = 2
			set low on counter = 6
			read SDA_in on counter = 4 (center of SCL)
	*/
	reg [2:0] freqDivider; // full cycle from 0 to 7 is t_scl
	initial freqDivider <= 3'b000;
	
	// bit to send
	reg [2:0] sendBitCounter; // max = 3'b111 = 8
	initial sendBitCounter <= 3'b111; // MSB first
	
	// -------------- Always block --------------
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
				SCL <= 1'b1;
				readyTransmit <= 1'b0;
				internalReadyTransmitFlag <= 1'd0;
				internalAckReceivedFlag <= 1'd0;
				SDA_io <= 1'b1;
				SDA_out <= 1'b1;
				sendState <= START;
				freqDivider <= 3'b000;
				sendBitCounter <= 3'b111;
			end
				else begin
					if (sendState == START) begin // START
							if (freqDivider == 3'b000) begin
									SDA_out <= 1'b0;
								end
									else if (freqDivider == 3'b100) begin
											SCL <= 1'b0;
										end
											else if (freqDivider == 3'b111) begin
													sendState <= SEND_BYTE;
												end
						end
							else if (sendState == SEND_BYTE) begin // TRANSMISSION
									readyTransmit <= 1'b0;
									if (freqDivider == 3'b000) begin
											SDA_out <= writeWord[sendBitCounter];
											if (sendBitCounter == 3'b000) begin
													sendBitCounter <= 3'b111;
													readyTransmit <= 1'b1;
													internalReadyTransmitFlag <= 1'b1;
												end
													else sendBitCounter <= sendBitCounter - 1'b1;
										end
											else if (freqDivider == 3'b010) begin
													SCL <= 1'b1;
												end
													else if (freqDivider == 3'b110) begin
															SCL <= 1'b0;
														end
															else if (freqDivider == 3'b111) begin
																	if (internalReadyTransmitFlag) begin
																			internalReadyTransmitFlag <= ~internalReadyTransmitFlag;
																			sendState <= GET_ACK;
																			SDA_io <= 1'b0; // read
																		end
																			else;
																end
									end
										else if (sendState == GET_ACK) begin
												if (freqDivider == 3'b010) begin
														SCL <= 1'b1;
													end
														else if (freqDivider == 3'b100) begin
																if (SDA_in == 1'b0) begin
																		internalAckReceivedFlag <= 1'b1;
																	end
															end
																else if (freqDivider == 3'b110) begin
																		SCL <= 1'b0;
																	end
																		else if (freqDivider == 3'b111) begin
																				if (internalAckReceivedFlag) begin
																						internalAckReceivedFlag <= ~internalAckReceivedFlag;
																						sendState <= SEND_BYTE;
																						SDA_io <= 1'b1; // write
																					end
																						else; // ??? ERROR
																			end
												end
													else;
					freqDivider <= freqDivider + 1'b1;
				end
	end
	
endmodule
