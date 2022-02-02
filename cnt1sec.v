module CNT1SEC(
	input	CLK, RST,
	output	EN1HZ,
	output   reg SIG2HZ
);

reg[25:0] cnt;

always @( posedge CLK )begin
	if( EN1HZ==1'b1 )
		cnt <= 26'b0;
	else
		cnt <= cnt + 26'b1;
end

assign EN1HZ = (cnt==26'd47999999);

wire cnt37499999 = (cnt==26'd35999999);
wire cnt24999999 = (cnt==26'd23999999);
wire cnt12499999 = (cnt==26'd11999999);

always @(posedge CLK) begin
	if(cnt12499999 | cnt24999999 | cnt37499999 | EN1HZ)
		SIG2HZ <= ~SIG2HZ;
end

endmodule
