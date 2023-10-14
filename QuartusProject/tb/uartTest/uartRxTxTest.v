module uartRxTxTest(
	input clk,
	//input reset,
	input UART_RXD,
	output UART_TXD,
	
	// Output signal parameters
	output reg [7:0] signalNumber,
	output reg [31:0] adder,
	output reg [31:0] amplitude,
	
	// Output signal data
	input [31:0] signal
);
	// Read from uart
	wire from_uart_ready;
	wire [7:0] from_uart_data;
	wire from_uart_error;
	wire from_uart_valid;
	// Write to uart
	wire [7:0] to_uart_data;
	wire to_uart_error;
	wire to_uart_valid;
	wire to_uart_ready;
	
	uartWrapper uartWrapper_inst(
		.clk(clk),							// input	
		.reset(reset),								// input	
		.UART_RXD(UART_RXD),						// input	
		.UART_TXD(UART_TXD),						// output	
		// Read from uart			
		.from_uart_ready(from_uart_ready), 	// input		// should be 1 to read from uart (from_uart_ready = 1'd1)
		.from_uart_data(from_uart_data),		// output	
		.from_uart_error(from_uart_error),	// output	
		.from_uart_valid(from_uart_valid),	// output	
		// Write to uart			
		.to_uart_data(to_uart_data),			// input	
		.to_uart_error(to_uart_error),		// input	
		.to_uart_valid(to_uart_valid), 		// input		// should be 1 to write to uart (to_uart_valid = 1'd1)
		.to_uart_ready(to_uart_ready) 		// output	// when uart is ready to receive data we write new data to "to_uart_data"
	);
	
endmodule