module STATE(
	input	CLK, RST,
	input	SIG2HZ,
	input	MODE, SELECT, ADJUST,
	output	MINCLR, HOURCLR,
	output	MININC, HOURINC,
	output	MINON, HOURON
);

reg[1:0]cur, nxt;
localparam NORM=2'b00, SEC=2'b01,MIN=2'b10, HOUR=2'b11;

assign MINCLR  = (cur==MIN)  & ADJUST;
assign HOURCLR = (cur==HOUR) & ADJUST;

assign MININC  = (cur==MIN)  & SELECT;
assign HOURINC = (cur==HOUR) & SELECT;

assign MINON  = ~((cur==MIN)  & SIG2HZ);
assign HOURON = ~((cur==HOUR) & SIG2HZ);

always @(posedge CLK) begin
	cur <= nxt;
end

always @*begin
	case(cur)
		NORM:	if(MODE)
				nxt = MIN;
			else
				nxt = NORM;
		
		MIN:	if(MODE)
				nxt = HOUR;
			else
				nxt = MIN;
					
		HOUR:	if(MODE)
				nxt = NORM;
			else
				nxt = HOUR;
		default:nxt = NORM;
	endcase
end

endmodule
