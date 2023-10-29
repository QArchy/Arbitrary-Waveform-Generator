module uartRx(
	input clk,
	input reset,
	
	output reg from_uart_ready, 			// should be 1 to read from uart (from_uart_ready = 1'd1)
	input [7:0] from_uart_data,		
	input from_uart_error,				
	input from_uart_valid,				
	
	output reg [7:0] signalNumber,
	output reg [31:0] adder,
	output reg [31:0] amplitude
);
	// read state machine
	parameter UART_READY_READ 				= 8'd0; 	
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
	
	parameter UART_SOM 						= 8'b01110011; // 's'
	parameter UART_EOM 						= 8'b01100101; // 'e'
	
	// preset output values
	initial signalNumber <= 8'd0;
	initial adder <= 32'd214748;
	initial amplitude <= 32'd127;
	
	// read state
	reg [7:0] readState;
	initial readState	<= UART_READY_READ;
	
	always @(posedge clk) begin
		if (reset) begin
			signalNumber <= 8'd0;
			adder <= 32'd214748;
			amplitude <= 32'd255;
			readState	<= UART_READY_READ;
		end
			else if (readState == UART_READY_READ) begin
					from_uart_ready <= 1'd1;
					readState <= UART_READ_SOM;
				end
					else if (from_uart_valid) begin
						//from_uart_ready <= 1'd0; // processing input
						
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
																	
						//from_uart_ready <= 1'd1; // ready to get new msg
					end
						else /* wait for valid msg */ ;
	end
	
endmodule