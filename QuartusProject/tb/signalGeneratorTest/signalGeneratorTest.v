`timescale 1 ps / 1 ps

module signalGenerator(
	// input clk,
	//input [2:0] signalNumber,
	//input [31:0] adder,
	output reg [31:0] signal,
	output reg [31:31-7] signal_8bit
);
	// --------- SIMULATION PARAMETERS ---------
	
	reg clk = 0;
	always #20 clk = ~clk;
	
	reg [2:0] signalNumber = 3'd0;
	always @(posedge clk) #2000000 signalNumber <= signalNumber + 1'd1;
	
	integer i = 0;
	reg [31:0] array_of_adders [9:0]; // 10 32-bit adder values
	initial begin
		for (i = 0; i < 10; i = i + 1) begin
			array_of_adders[i] = (i + 100) * 32'd16229317;
		end
	end
	
	integer counter = 32'd0;
	reg [31:0] adder = 32'd1000000;
	always @(posedge clk) begin
		if (counter == 9) begin
				counter <= 1'd0;
			end
		adder <= (adder == array_of_adders[counter]) ? adder : array_of_adders[counter];
	end
	
	always @(posedge clk) #200000 counter <= counter + 1'd1;
	
	// --------- SIMULATION PARAMETERS ---------
	
	reg [31:0] accumulator = 32'd0;
	
	wire [31:0] saw_out = accumulator[31:0];
	wire [31:0] ramp_out = -saw_out;
	wire [31:0] square_out = (saw_out > 2147483647) ? 4294967295 : 0;
	wire [31:0] tri_out = (saw_out > 2147483647 /*saw_out[31]*/) ? -saw_out : saw_out;
	
	wire [7:0] sin_out;
	sinRom sinRom_inst(
		.address(accumulator[31:31-7]),
		.clock(clk),
		.q(sin_out)
	);
	
	wire [31:0] noise_out;
	noiseGenerator noiseGenerator_inst(
		.clk(clk),
		.noise(noise_out)
	);
	
	always @(posedge clk) begin
		if (signalNumber == 3'b101) begin
			signalNumber = 3'b000;
		end
		case (signalNumber)
			3'b000: signal <= {sin_out, 23'd0};
			3'b001: signal <= noise_out;
			3'b010: signal <= tri_out;
			3'b011: signal <= square_out;
			3'b100: signal <= saw_out;
			3'b101: signal <= ramp_out;
		endcase
		case (signalNumber)
			3'b000: signal_8bit <= sin_out;
			3'b001: signal_8bit <= noise_out[31:31-7];
			3'b010: signal_8bit <= tri_out[31:31-7];
			3'b011: signal_8bit <= square_out[31:31-7];
			3'b100: signal_8bit <= saw_out[31:31-7];
			3'b101: signal_8bit <= ramp_out[31:31-7];
		endcase
		accumulator <= accumulator + adder;
	end
	
endmodule