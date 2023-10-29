module btnDebouncer(
	input btnSig,
	input clk,
	output reg debouncedSig
);
	reg [21:0] counter; // at 50 MHz it will be approximately 0.1 sec
	initial counter <= 22'd0;
	
	reg btnPressedFlag;
	initial btnPressedFlag <= 1'd0;
	
	always @(posedge clk) begin
		btnPressedFlag <= (~btnPressedFlag & btnSig) ? 1'd1 : counter == 22'b1111111111111111111111 ? 1'd0 : btnPressedFlag;
		counter <= btnPressedFlag ? counter + 1'd1 : counter;
		debouncedSig <= (counter == 22'b1111111111111111111111 & btnPressedFlag) ? 1'b1 : 1'b0;
	end
	
endmodule