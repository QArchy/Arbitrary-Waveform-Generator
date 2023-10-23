module pcf8591DAC_transmitter (
	input clk,
	output SCL,
	inout SDA,
	input [7:0] signal,
	input reset
);
	parameter BYTE_ADRESS = 8'b10010000 // 1001000 - adress, 0 - write mode
	parameter BYTE_CONTROL = 8'b01000000 // enable DAC
	
	reg [7:0] sig;
	initial sig <= 8'd0;
	
	wire readyTransmit;
	i2c_transmitter i2c_transmitter_inst(
		.clk(clk),
		.SCL(SCL),
		.SDA(SDA),
		.readyTransmit(readyTransmit),
		.writeWord(sig),
		.reset(reset)
	);
	
	parameter SEND_ADRESS_BYTE = 2'b00;
	parameter SEND_CONTROOL_BYTE = 2'b01;
	parameter SEND_DATA = 2'b10;
	
	reg [1:0] sendState;
	initial sendState <= SEND_ADRESS_BYTE;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
				sig <= 8'd0;
				sendState <= SEND_ADRESS_BYTE;
			end
				else if (sendState == SEND_ADRESS_BYTE) begin
						if (readyTransmit) begin
							sig <= BYTE_ADRESS;
							sendState <= SEND_CONTROOL_BYTE;
						end
							else;
					end
						else if (sendState == SEND_CONTROOL_BYTE) begin
								if (readyTransmit) begin
										sig <= BYTE_CONTROL;
										sendState <= SEND_DATA;
									end
										else;
							end
								else if (sendState == SEND_DATA) begin
										sig <= readyTransmit ? signal : 0;
									end
										else;
	end
	
endmodule