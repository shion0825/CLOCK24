module SECCNT(
	 input			CLK, RST,
	 input			EN, 
	 output	reg	[2:0]	QH,
	 output	reg	[3:0]	QL,
	 output			CA
);

/*1秒*/
always @(posedge CLK) begin
	if( EN==1'b1 ) begin
		if( QL==4'd9 )
			QL <= 4'd0;
		else 
			QL <= QL + 1'b1;
	end
end

/*10秒*/
always @(posedge CLK) begin
	if( EN==1'b1  && QL==4'd9) begin
		if( QH==3'd5 )
			QH <= 3'd0;
		else
			QH <= QH + 1'b1;
	end
end

/*CA*/
assign CA = (QH==3'd5 && QL==4'd9 && EN==1'b1 );

endmodule
