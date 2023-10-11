module uartTx(
	input clk,
	
	// Write to uart
	output reg [7:0] to_uart_data,	
	output reg to_uart_error,		
	output reg to_uart_valid,			// should be 1 to write to uart (to_uart_valid = 1'd1)
	input to_uart_ready,					// when uart is ready to receive data we write new data to "to_uart_data"
	
	// transmit signal data
	input [31:0] signal
);
	// write state machine
	parameter UART_WRITE_SOM 				= 8'd0; // SOM - Start of message
	parameter UART_WRITE_SIGNAL_31_24	= 8'd1;
	parameter UART_WRITE_SIGNAL_23_16 	= 8'd2;
	parameter UART_WRITE_SIGNAL_15_8 	= 8'd3;
	parameter UART_WRITE_SIGNAL_7_0 		= 8'd4;
	parameter UART_WRITE_EOM		 		= 8'd5; // EOM - End of message
	
	parameter UART_SOM 						= 8'b01110011; // 's'
	parameter UART_EOM 						= 8'b01100101; // 'e'
	
	initial to_uart_data <= 8'd0;
	initial to_uart_error <= 1'd0;
	initial to_uart_valid <= 1'd0;
	
	reg [7:0] writeState;
	initial writeState <= UART_WRITE_SOM;
	
	reg posedge_to_uart_ready;
	initial posedge_to_uart_ready <= 1'd0;
	reg prev_to_uart_ready;
	initial prev_to_uart_ready <= 1'd0;
	
	always @(posedge clk) begin
		posedge_to_uart_ready <= ~prev_to_uart_ready & to_uart_ready;
		
		if (posedge_to_uart_ready) begin
			to_uart_valid <= 1'd1; // if to_uart_ready data always valid
			
			if (writeState == UART_WRITE_SOM) begin
				to_uart_data <= UART_SOM;
				writeState <= UART_WRITE_SIGNAL_31_24;
			end	
				else if (writeState == UART_WRITE_SIGNAL_31_24) begin
						to_uart_data <= signal[31:24];
						writeState <= UART_WRITE_SIGNAL_23_16;
					end
						else if (writeState == UART_WRITE_SIGNAL_23_16) begin	
							to_uart_data <= signal[23:16];
							writeState <= UART_WRITE_SIGNAL_15_8;
						end
							else if (writeState == UART_WRITE_SIGNAL_15_8) begin
								to_uart_data <= signal[15:8];
								writeState <= UART_WRITE_SIGNAL_7_0;
							end
								else if (writeState == UART_WRITE_SIGNAL_7_0) begin
									to_uart_data <= signal[7:0];
									writeState <= UART_WRITE_EOM;
								end
									else if (writeState == UART_WRITE_EOM) begin
											to_uart_data <= UART_EOM;
											writeState <= UART_WRITE_SOM;
										end
										
		end
			else;
			
		//if (~prev_to_uart_ready) begin	
		//    to_uart_valid <= 1'd0;   ??????????????????????????
		//end
		
		prev_to_uart_ready <= to_uart_ready;
		
	end
	
endmodule
