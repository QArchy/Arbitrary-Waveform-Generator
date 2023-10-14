module signalGenerator(
	input clk,
	input [2:0] signalNumber,
	input [31:0] adder,
	output reg [31:0] signal,
	output reg [31:31-7] signal_8bit
);
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