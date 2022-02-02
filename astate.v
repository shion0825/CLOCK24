module ASTATE(
	input CLK, RST,
	input SIG2HZ,
	input MODE1, SELECT1, ADJUST1,
	output MINCLR1, HOURCLR1,
	output MININC1, HOURINC1,
	output MINON1, HOURON1
);

reg[1:0]cur, nxt;
localparam NORM=2'b00, SEC=2'b01,MIN=2'b10, HOUR=2'b11;

assign MINCLR1  = (cur==MIN)  & ADJUST1;
assign HOURCLR1 = (cur==HOUR) & ADJUST1;

assign MININC1  = (cur==MIN)  & SELECT1;
assign HOURINC1 = (cur==HOUR) & SELECT1;

assign MINON1  = ~((cur==MIN)  & SIG2HZ);
assign HOURON1 = ~((cur==HOUR) & SIG2HZ);

always @(posedge CLK) begin
	cur <= nxt;
end

always @*begin
	case(cur)
		NORM:	if(MODE1)
				nxt = MIN;
			else
				nxt = NORM;
		
		MIN:	if(MODE1)
				nxt = HOUR;
			else
				nxt = MIN;
					
		HOUR:	if(MODE1)
				nxt = NORM;
			else
				nxt = HOUR;

		default:nxt = NORM;
	endcase
end

endmodule
