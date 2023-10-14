module uartWrapperTest(
	input clk,
	input UART_RXD,
	output UART_TXD,
	
	output [7:0] from_uart_data,
	output from_uart_error,
	output from_uart_valid,
	
	output to_uart_error,
	//output to_uart_valid,
	output to_uart_ready
);
	// PLL
	wire reset;
	assign reset = 1'd0;
	
	wire i2c_clk;
	wire uart_clk;
	wire clk_200MHz;
	
	wire pll_locked;
	
	uart_i2c_max_PLL uart_i2c_max_PLL_inst(
		.areset(reset),
		.inclk0(clk),
		.c0(i2c_clk),
		.c1(uart_clk),
		.c2(clk_200MHz),
		.locked(pll_locked)
	);
	
	// UART
	wire from_uart_ready;
	assign from_uart_ready = 1'd1;
	
	reg [7:0] to_uart_data;
	initial to_uart_data = 8'b10101010;
	
	wire to_uart_valid;
	assign to_uart_valid = 1'd1;
	
	uart uart_inst(
		.from_uart_ready(from_uart_ready), 	// input
		.from_uart_data(from_uart_data),		// output
		.from_uart_error(from_uart_error),	// output
		.from_uart_valid(from_uart_valid),	// output
		.to_uart_data(to_uart_data),			// input
		.to_uart_error(to_uart_error),		// input
		.to_uart_valid(to_uart_valid),		// input
		.to_uart_ready(to_uart_ready),		// output
		.clk(uart_clk),							// input
		.UART_RXD(UART_RXD),						// input
		.UART_TXD(UART_TXD),						// output
		.reset(reset)								// input
	);
	
	always @(posedge uart_clk) begin
		if (to_uart_ready) begin
			to_uart_data <= 8'b01110001;
		end
	end
	
endmodule