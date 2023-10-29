module btnDebouncer(
	//input btnSig,
	//input clk,
	output reg debouncedSig
);
	reg clk;
	initial clk <= 1'd0;
	always #20 clk <= ~clk;
	
	reg btnSig;
	initial btnSig <= 1'd0;
	always #10000 btnSig <= ~btnSig;
	
	reg [4:0] counter;
	initial counter <= 4'd0;
	
	reg btnPressedFlag;
	initial btnPressedFlag <= 1'd0;
	
	always @(posedge clk) begin
		btnPressedFlag <= (~btnPressedFlag & btnSig) ? 1'd1 : counter == 4'b1111 ? 1'd0 : btnPressedFlag;
		counter <= btnPressedFlag ? counter + 1'd1 : counter;
		debouncedSig <= (counter == 4'b1111 & btnPressedFlag) ? 1'b1 : 1'b0;
	end
	
endmodule