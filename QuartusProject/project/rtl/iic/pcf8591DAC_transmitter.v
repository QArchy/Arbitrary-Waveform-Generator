module pcf8591DAC_transmitter (
	input clk,
	output SCL,
	inout SDA,
	input [7:0] signal
);
	
	reg [7:0] sig;
	initial sig <= {7'h47, 1'd0 /* write mode (DAC) */ }; // adress and io mode
	
	wire byteSent;
	
	i2c_transmitter i2c_transmitter_inst(
		.clk(clk),
		.SCL(SCL),
		.SDA(SDA),
		.byteSent(byteSent),
		.writeWord(signal)
	);
	
	parameter SEND_ADRESS_BYTE = 2'b00;
	parameter SEND_CONTROOL_BYTE = 2'b01;
	parameter SEND_DATA = 2'b10;
	
	reg [1:0] sendState;
	initial sendState <= SEND_ADRESS_BYTE;
	
	always @(posedge clk) begin
		if (sendState == SEND_ADRESS_BYTE) begin
				if (byteSent) begin
						sig <= 8'b00000000;
						sendState <= SEND_CONTROOL_BYTE;
					end
						else;
			end
				else if (sendState == SEND_CONTROOL_BYTE) begin
						if (byteSent) begin
								sig <= signal;
								sendState <= SEND_DATA;
							end
								else;
					end
						else if (sendState == SEND_DATA) begin
								if (byteSent) begin
										sig <= signal;
									end
										else;
							end
								else;
	end
	
endmodule