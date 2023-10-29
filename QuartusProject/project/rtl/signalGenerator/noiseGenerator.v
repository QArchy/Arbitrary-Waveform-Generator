module noiseGenerator(
 	input clk,
	input reset,
	output reg [31:0] noise
);
	initial noise = 32'd1;
	always @(posedge clk or posedge reset)
			noise <= reset ? 32'd1 : ((((noise >> 31) ^ (noise >> 30) ^ (noise >> 29) ^ (noise >> 27) ^ (noise >> 25) ^ noise ) & 32'd1 ) << 31 ) | (noise >> 1);

endmodule
