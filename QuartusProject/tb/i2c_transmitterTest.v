module i2c_transmitterTest(
	//input clk,
	output reg SCL,
	output reg SDA,
	//input writeWord [7:0] word
);
	// ------------ Simulation ------------
	
	reg clk;
	initial clk <= 1'd1;
	always #5 clk <= ~clk;
	
	reg writeWord;
	initial writeWord <= 8'd157;
	always #100 writeWord <= writeWord + 1'd1;
	
	// ------------ Simulation ------------
	
	initial SCL <= 1'd1;
	initial SDA <= 1'd1;
	
	// ------------ Transmission state machine ------------
	
	parameter START = 4'b0000;			// SDA 1->0 SCL = 1
	
										// Goes in cycle ->
	parameter DATABIT_0 = 4'b0001;		// SCL = 1 SDA = X
	parameter DATABIT_1 = 4'b0010;		// SCL = 1 SDA = X
	parameter DATABIT_2 = 4'b0011;		// SCL = 1 SDA = X
	parameter DATABIT_3 = 4'b0100;		// SCL = 1 SDA = X
	parameter DATABIT_4 = 4'b0101;		// SCL = 1 SDA = X
	parameter DATABIT_5 = 4'b0110;		// SCL = 1 SDA = X
	parameter DATABIT_6 = 4'b0111;		// SCL = 1 SDA = X
	parameter DATABIT_7 = 4'b1000;		// SCL = 1 SDA = X
	parameter SEND_ACK_WAIT = 4'b1001;	// SCL = 1 SDA = X
	parameter WAIT_FOR_ACK = 4'b1010;	// SCL = 1 SDA = X
	
	// state machine reg
	reg sendState = START;
	
	// switch
	reg switch;
	initial switch <= 1'd1;
	
	always @(posedge clk) begin
		if (switch) begin
			// set SCL, SDA
			if (sendState == START) begin /* START */
					SDA <= 1'd0;
					SCL <= 1'd0;
					sendState <= DATABIT_0;
				end
					else if(sendState == DATABIT_0) begin /* SEND DATA BYTE */
							SDA <= writeWord[7];
							SCL <= 1'd1;
							sendState <= DATABIT_1;
						end
							else if(sendState == DATABIT_1) begin
									SDA <= writeWord[6];
									SCL <= 1'd1;
									sendState <= DATABIT_2;
								end
									else if(sendState == DATABIT_2) begin
											SDA <= writeWord[5];
											SCL <= 1'd1;
											sendState <= DATABIT_3;
										end
											else if(sendState == DATABIT_3) begin
													SDA <= writeWord[4];
													SCL <= 1'd1;
													sendState <= DATABIT_4;
												end
													else if(sendState == DATABIT_4) begin
															SDA <= writeWord[3];
															SCL <= 1'd1;
															sendState <= DATABIT_5;
														end
															else if(sendState == DATABIT_5) begin
																	SDA <= writeWord[2];
																	SCL <= 1'd1;
																	sendState <= DATABIT_6;
																end
																	else if(sendState == DATABIT_6) begin
																			SDA <= writeWord[1];
																			SCL <= 1'd1;
																			sendState <= DATABIT_7;
																		end
																			else if(sendState == DATABIT_7) begin
																					SDA <= writeWord[0];
																					SCL <= 1'd1;
																					sendState <= SEND_ACK_WAIT;
																				end
																					else if(sendState == SEND_ACK_WAIT) begin
																							SDA <= 1'd0;
																							SCL <= 1'd1;
																							sendState <= WAIT_FOR_ACK;
																						end
																							else if(sendState == WAIT_FOR_ACK) begin
																									SCL <= 1'd0;
																									if (SDA) begin
																											sendState <= DATABIT_0;
																										end
																											else /* sim */ begin
																													SDA <= 1'd1;
																												end /* sim */
																								end
			end
				else begin
						// reset SCL, SDA
						if (sendState != WAIT_FOR_ACK) begin
								SDA <= 1'd0;
							end
								else;
						SCL <= 1'd0;
					end
		switch = ~switch;
	end
	
endmodule