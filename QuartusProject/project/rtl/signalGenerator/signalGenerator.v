module signalGenerator(
	input clk,
	input reset,
	input [2:0] signalNumber,
	input [31:0] adder,
	output reg [31:0] signal
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
		.reset(reset),
		.noise(noise_out)
	);
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
				accumulator = 32'd0;
				signal <= 32'd0;
			end else begin
					case (signalNumber)
						3'b000: signal <= {sin_out, 23'd0};
						3'b001: signal <= noise_out;
						3'b010: signal <= tri_out;
						3'b011: signal <= square_out;
						3'b100: signal <= saw_out;
						3'b101: signal <= ramp_out;
					endcase
					accumulator <= accumulator + adder;
				end
	end
	
endmodule