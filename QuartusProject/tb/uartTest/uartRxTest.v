module uartRxTest(
	output reg from_uart_ready, 			// should be 1 to read from uart (from_uart_ready = 1'd1)

	output reg clk,
	output reg clk_slow,
	output reg [7:0] from_uart_data,
	output reg from_uart_error,
	output reg from_uart_valid,
	
	output reg [7:0] signalNumber,
	output reg [31:0] adder,
	output reg [31:0] amplitude,
	
	output reg [7:0] readState
);
	// read state machine
	parameter UART_READY_READ 				= 8'd0; 	// SOM - Start of message
	parameter UART_READ_SOM 				= 8'd1; 	// SOM - Start of message 
	parameter UART_READ_SIGNAL_NUMBER 	= 8'd2;
	parameter UART_READ_ADDER_31_24	 	= 8'd3;
	parameter UART_READ_ADDER_23_16 		= 8'd4;
	parameter UART_READ_ADDER_15_8 		= 8'd5;
	parameter UART_READ_ADDER_7_0 		= 8'd6;
	parameter UART_READ_AMPL_31_24	 	= 8'd7;
	parameter UART_READ_AMPL_23_16 		= 8'd8;
	parameter UART_READ_AMPL_15_8 		= 8'd9;
	parameter UART_READ_AMPL_7_0 			= 8'd10;
	parameter UART_READ_EOM 				= 8'd11; // EOM - End of message
	
	parameter UART_SOM 						= 8'd153;
	parameter UART_EOM 						= 8'd235;
	
	// read state
	initial readState	<= UART_READY_READ;
	
	// ---------- SIMULATION ----------
	
	initial signalNumber = 8'd0;
	initial adder = 32'd1000000;
	initial amplitude = 32'd1000000;
	
	initial clk = 1'd0;
	always #10 clk = ~clk;
	
	//initial from_uart_data = 8'd255;
	initial from_uart_error = 1'd0;
	initial from_uart_valid = 1'd0;
	
	reg [7:0] msg [10:0];
	integer i = 32'd0;
	initial begin
		for(i = 0; i < 11; i = i + 1) begin
			case (i)
				0: msg[i] <= 8'd153;
				1:	msg[i] <= 8'd1;
				2: msg[i] <= 8'd2;
				3: msg[i] <= 8'd3;
				4: msg[i] <= 8'd4;
				5: msg[i] <= 8'd5;
				6: msg[i] <= 8'd6;
				7: msg[i] <= 8'd7;
				8: msg[i] <= 8'd8;
				9: msg[i] <= 8'd9;
				10: msg[i] <= 8'd235;
			endcase
		end
	end
	
	integer j = 32'd0;
	always @(posedge clk) begin
		from_uart_valid <= ~from_uart_valid;
		if (~from_uart_valid) begin
			j <= (j == 10) ? 0 : j + 1;
			from_uart_data <= msg[j];
		end
	end
	
	// --------------------------------
	
	always @(posedge clk) begin
		if (readState == UART_READY_READ) begin
				from_uart_ready <= 1'd1;
				readState <= UART_READ_SOM;
			end
				else if (from_uart_valid) begin
					from_uart_ready <= 1'd0; // processing input
					
					if (readState == UART_READ_SOM) begin
							readState <= (from_uart_data == UART_SOM) ? UART_READ_SIGNAL_NUMBER : UART_READY_READ; /* handle error */
						end
							else if (readState == UART_READ_SIGNAL_NUMBER) begin
								signalNumber <= from_uart_data;
								readState <= UART_READ_ADDER_31_24;
							end
								else if (readState == UART_READ_ADDER_31_24) begin
									adder <= (adder << 8) + from_uart_data;
									readState <= UART_READ_ADDER_23_16;
								end
									else if (readState == UART_READ_ADDER_23_16) begin
										adder <= (adder << 8) + from_uart_data;
										readState <= UART_READ_ADDER_15_8;
									end
										else if (readState == UART_READ_ADDER_15_8) begin
											adder <= (adder << 8) + from_uart_data;
											readState <= UART_READ_ADDER_7_0;
										end
											else if (readState == UART_READ_ADDER_7_0) begin
												adder <= (adder << 8) + from_uart_data;
												readState <= UART_READ_AMPL_31_24;
											end
												else if (readState == UART_READ_AMPL_31_24) begin
													amplitude <= (amplitude << 8) + from_uart_data;
													readState <= UART_READ_AMPL_23_16;
												end
													else if (readState == UART_READ_AMPL_23_16) begin
														amplitude <= (amplitude << 8) + from_uart_data;
														readState <= UART_READ_AMPL_15_8;
													end
														else if (readState == UART_READ_AMPL_15_8) begin
															amplitude <= (amplitude << 8) + from_uart_data;
															readState <= UART_READ_AMPL_7_0;
														end
															else if (readState == UART_READ_AMPL_7_0) begin
																amplitude <= (amplitude << 8) + from_uart_data;
																readState <= UART_READ_EOM;
															end
																else if (readState == UART_READ_EOM) begin
																	readState <= (from_uart_data == UART_EOM) ? UART_READY_READ: UART_READY_READ; /* handle error */
																	readState <= UART_READY_READ;
																end
																
					 from_uart_ready <= 1'd1; // ready to get new msg
				end
					else /* wait for valid msg */ ;
	end
	
endmodule