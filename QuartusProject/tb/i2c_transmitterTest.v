module i2c_transmitterTest(
	input clk,
	output SCL,
	output reg SDA,
	input writeWord [7:0] word
);
	assign SCL = clk;
	
	parameter START = 3'b0000;			// SDA 1->0 CLK = 1
	parameter SEND_CONTROL_BYTE = 3'b0001;	// FIRST BYTE TO SEND
	reg controlByte = 7'd157;
	
										// Goes in cycle ->
	parameter SEND_DATA_BYTE = 3'b0001;	// FIRST BYTE TO SEND
	parameter DATABIT_0 = 3'b0010;		// CLK = 1 SDA = X
	parameter DATABIT_1 = 3'b0011;		// CLK = 1 SDA = X
	parameter DATABIT_2 = 3'b0100;		// CLK = 1 SDA = X
	parameter DATABIT_3 = 3'b0101;		// CLK = 1 SDA = X
	parameter DATABIT_4 = 3'b0110;		// CLK = 1 SDA = X
	parameter DATABIT_5 = 3'b0111;		// CLK = 1 SDA = X
	parameter DATABIT_6 = 3'b1000;		// CLK = 1 SDA = X
	parameter DATABIT_7 = 3'b1001;		// CLK = 1 SDA = X
	parameter WAIT_FOR_ACK = 3'b1010;	// CLK = 1 SDA = WAIT FOR 1 ON SDA LINE
	
	parameter STOP = 3'b1011;			// SDA = 1 CLK = 1
		
	reg sendState = START;
	
	always @(posedge clk) begin
		if (sendState == START) begin /* START */
				
			end
				else if(sendState == CONTROL_BYTE) begin /* SEND CONTROL BYTE */
						
					end
						else begin /* SEND DATA BYTE */
						
							end
	end
	
endmodule