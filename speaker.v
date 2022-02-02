module SPEAKER (
		input	[1:0]	HOURH,
		input [2:0]	MINH,
		input	[3:0]	HOURL,MINL,
		output	reg	ON
);

wire hh = 2'd0;
wire hl = 4'd0;
wire mh = 3'd0;
wire ml = 4'd1;

always @* begin
	if( (MINH == mh) && (MINL == ml) && (HOURH == hh) && (HOURL == hl) )
			ON = 1'b1;
	else
			ON = 1'b0;
end

endmodule
