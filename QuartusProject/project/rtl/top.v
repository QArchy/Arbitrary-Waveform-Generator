module top(
	input clk,
	input UART_RXD,
	output UART_TXD,
	output [7:0] signal_8bit,
	output SCL,
	inout SDA,
	input resetN
);
	wire reset;
	
	btnDebouncer btnDebouncer_inst(
		.btnSig(~resetN),
		.clk(clk),
		.debouncedSig(reset)
	);

	// ------------------------------------------- PLL CONFIG
	
	wire i2cPllFrequency;
	wire uartPllFrequency;
	wire maxClk;
	wire pllLocked;
	
	pll pll_inst(
		.areset(),
		.inclk0(clk),
		.c0(i2cPllFrequency), 	// 900KHz
		.c1(uartPllFrequency), 	// 10MHz
		.c2(maxClk), 				// 200MHz
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
		.signal(signal),
		.reset(reset)
	);
	
	// ------------------------------------------- SIGNAL GENERATOR CONFIG
	
	signalGenerator signalGenerator_inst(
		.clk(maxClk),								// input
		.reset(reset),								// input
		.signalNumber(signalNumber), 			// input
		.adder(adder), 							// input
		.signal(signal) 							// output
	);
	
	amplitudeChanger amplitudeChanger_inst(
		.clk(maxClk),
		.amplitude(amplitude[7:0]),
		.signal(signal[31:24]),
		.amplSignal(signal_8bit)
	);
		
	// ------------------------------------------- PCF8591 I2C CONFIG
	
	pcf8591DAC_transmitter pcf8591DAC_transmitter_inst(
		.clk(i2cPllFrequency),
		.SCL(SCL),
		.SDA(SDA),
		.signal(signal_8bit),
		.reset(reset)
	);
	
endmodule