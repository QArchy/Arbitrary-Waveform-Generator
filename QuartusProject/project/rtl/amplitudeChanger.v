module amplitudeChanger(
	input clk,
	input [7:0] amplitude,
	input [7:0] signal,
	output reg [7:0] amplSignal
);
	initial amplSignal <= 8'd0;
	
	wire [15:0] newSignal;
	mult_u8u8 mult_u8u8_inst(
		.dataa(amplitude),
		.datab(signal),
		.result(newSignal)
	);
	
	always @(posedge clk) begin
		amplSignal <= newSignal[15:8];
	end
	
endmodule