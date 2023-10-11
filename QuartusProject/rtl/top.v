module top(
	input clk,
	input UART_RXD,
	output UART_TXD
);
	// ------------------------------------------- PLL CONFIG
	
	wire reset;
	assign reset = 1'd0;
	
	wire i2cPllFrequency;
	wire uartPllFrequency;
	wire maxClk;
	wire pllLocked;
	
	uart_i2c_max_PLL uart_i2c_max_PLL_inst(
		.areset(reset),
		.inclk0(clk),
		.c0(i2cPllFrequency), // 10KHz
		.c1(uartPllFrequency), // 10MHz
		.c2(maxClk), // 200MHz
		.locked(pllLocked)
	);
	
	// ------------------------------------------- UART CONFIG
	
	wire [7:0] signalNumber;
	wire [31:0] adder;
	wire [31:0] amplitude;
	wire [31:0] signal;

	uartRxTx uartRxTx_inst(
		.clk(uartPllFrequency),
		.UART_RXD(UART_RXD),
		.UART_TXD(UART_TXD),
		.signalNumber(signalNumber),
		.adder(adder),
		.amplitude(amplitude),
		.signal(signal)
	);
	
	// ------------------------------------------- SIGNAL GENERATOR CONFIG
	
	signalGenerator signalGenerator_inst(
		.clk(maxClk), 								// input
		.signalNumber(signalNumber), 			// input
		.adder(adder), 							// input
		.signal(signal) 							// output
	);
	
	// ------------------------------------------- I2C CONFIG
	
	//i2cDacTransmitter(
	//	.clk(i2cPllFrequency),
	//	// input signal[31:31-7]
	//);
	
endmodule