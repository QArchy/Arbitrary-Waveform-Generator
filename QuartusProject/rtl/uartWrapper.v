module uartWrapper(
	input clk,
	input reset,
	input UART_RXD,
	output UART_TXD,
	// Read from uart
	input from_uart_ready, 			// should be 1 to read from uart (from_uart_ready = 1'd1)
	output [7:0] from_uart_data,
	output from_uart_error,
	output from_uart_valid,
	// Write to uart
	input [7:0] to_uart_data,
	input to_uart_error,
	input to_uart_valid, 			// should be 1 to write to uart (to_uart_valid = 1'd1)
	output to_uart_ready 			// when uart is ready to receive data we write new data to "to_uart_data"
);
	uart uart_inst(
		.from_uart_ready(from_uart_ready), 	// input
		.from_uart_data(from_uart_data),		// output
		.from_uart_error(from_uart_error),	// output
		.from_uart_valid(from_uart_valid),	// output
		.to_uart_data(to_uart_data),			// input
		.to_uart_error(to_uart_error),		// input
		.to_uart_valid(to_uart_valid),		// input
		.to_uart_ready(to_uart_ready),		// output
		.clk(clk),									// input
		.UART_RXD(UART_RXD),						// input
		.UART_TXD(UART_TXD),						// output
		.reset(reset)								// input
	);
endmodule