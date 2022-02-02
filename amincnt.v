module AMINCNT(
	 input			CLK, RST,
	 input			CLR1, INC1,
	 output	reg	[2:0]	QH1,
	 output	reg	[3:0]	QL1
);

/*1分*/
always @(posedge CLK) begin
	if( CLR1 )
		QL1 <= 4'd0;
	else if( INC1==1'b1) begin
		if( QL1==4'd9 )
			QL1 <= 4'd0;
		else
			QL1 <= QL1 + 1'b1;
	end
end

/*10分*/
always @(posedge CLK) begin
	if( CLR1 )
		QH1 <= 3'd0;
	else if( INC1==1'b1 && QL1==4'd9) begin
		if( QH1==3'd5 )
			QH1 <= 3'd0;
		else
			QH1 <= QH1 + 1'b1;
	end
end

endmodule
