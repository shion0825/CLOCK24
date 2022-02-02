module CLOCK24(
	input  CLK, RST,
	input  [2:0] KEY,KEY1,
	output reg [6:0] HEX0,
	output reg [6:0] HEX1,
	output reg [3:0] DIG,
	output reg LED
);

wire	CASEC,  CAMIN;
wire	MODE,   SELECT, ADJUST;
wire	SECCLR, MININC, HOURINC;
wire	SECON,  MINON, HOURON;
wire	MODE1,   SELECT1, ADJUST1;
wire	MININC1, HOURINC1;
wire	MINON1, HOURON1;
wire	EN1HZ,  SIG2HZ;
wire	[3:0]   SECL, MINL, HOURL, MINL1, HOURL1;
wire	[2:0]   SECH, MINH, MINH1;
wire	[1:0]   HOURH, HOURH1;
reg	[1:0]   count;
reg	[10:0]	cnt;

function [6:0] SEG7DEC2(input [3:0]	DIN,input	EN);	
begin
	if(EN)
		case( DIN )
			4’h0:	SEG7DEC2 = 7'b1000000;
			4'h1:	SEG7DEC2 = 7'b1111001;
			4'h2:	SEG7DEC2 = 7'b0100100;
			4'h3:	SEG7DEC2 = 7'b0110000;
			4'h4:	SEG7DEC2 = 7'b0011001;
			4'h5:	SEG7DEC2 = 7'b0010010;
			4'h6:	SEG7DEC2 = 7'b0000010;
			4'h7:	SEG7DEC2 = 7'b1011000;
			4'h8:	SEG7DEC2 = 7'b0000000;
			4'h9:	SEG7DEC2 = 7'b0010000;
			default:	SEG7DEC2 = 7'b1111111;
		endcase
	else
		SEG7DEC2 = 7'b1111111;
end
endfunction

CNT1SEC CNT1SEC( .CLK(CLK), .RST(RST), .EN1HZ(EN1HZ), .SIG2HZ(SIG2HZ) );

BTN_IN  BTN_IN ( .CLK(CLK),  .RST(RST), .nBIN(KEY),
			.BOUT({MODE, SELECT, ADJUST}) );	
	 
SECCNT  SEC     ( .CLK(CLK),  .RST(RST), .EN(EN1HZ),
			.QH(SECH),  .QL(SECL),  .CA(CASEC) );

MINCNT  MIN     ( .CLK(CLK),  .RST(RST), .EN(CASEC), .CLR(MINCLR), .INC(MININC),
			.QH(MINH),  .QL(MINL), .CA(CAMIN) );

HOURCNT HOUR    ( .CLK(CLK),  .RST(RST), .EN(CAMIN), .CLR(HOURCLR), .INC(HOURINC),
			.QH(HOURH), .QL(HOURL) );

STATE   STATE     ( .CLK(CLK), .RST(RST), .SIG2HZ(SIG2HZ),
			.MODE(MODE),.SELECT(SELECT),.ADJUST(ADJUST),
			.MINCLR(MINCLR),.HOURCLR(HOURCLR),
			.MININC(MININC),.HOURINC(HOURINC),
			.MINON(MINON),.HOURON(HOURON) );

ABTN_IN  ABTN_IN ( .CLK(CLK),  .RST(RST), .nBIN1(KEY1),
			.BOUT1({MODE1, SELECT1, ADJUST1}) );

AMINCNT  AMIN     ( .CLK(CLK),  .RST(RST), .CLR1(MINCLR1), .INC1(MININC1),
			.QH1(MINH1),  .QL1(MINL1), );

AHOURCNT AHOUR    ( .CLK(CLK),  .RST(RST), .CLR1(HOURCLR1), .INC1(HOURINC1),
			.QH1(HOURH1), .QL1(HOURL1) );

ASTATE   ASTATE     ( .CLK(CLK), .RST(RST), .SIG2HZ(SIG2HZ),
			.MODE1(MODE1),.SELECT1(SELECT1),.ADJUST1(ADJUST1),
			.MINCLR1(MINCLR1),.HOURCLR1(HOURCLR1),
			.MININC1(MININC1),.HOURINC1(HOURINC1),
			.MINON1(MINON1),.HOURON1(HOURON1) );

always @(posedge CLK) begin
	cnt <= cnt + 11'b1;

	if( cnt == 11'd4799 ) begin
		cnt <= 11'b0;

	case( count )
		2'h0: begin
			DIG <= 4'b1000;
			HEX0 <= SEG7DEC2( MINL , MINON );
			HEX1 <= SEG7DEC2( MINL1 , MINON1 );
		end
		2'h1: begin
			DIG <= 4'b0100; 
			HEX0 <= SEG7DEC2( MINH , MINON );
			HEX1 <= SEG7DEC2( MINH1 , MINON1 );
		end
		2'h2: begin
			DIG <= 4'b0010;
			HEX0 <= SEG7DEC2( HOURL , HOURON );
			HEX1 <= SEG7DEC2( HOURL1 , HOURON1 );
		end
		2'h3: begin
			DIG <= 4'b0001;
			HEX0 <= SEG7DEC2( HOURH , HOURON );
			HEX1 <= SEG7DEC2( HOURH1 , HOURON1 );
		end
		default: begin
			count <= 2'b00;
			DIG <= 4'b0001;
			HEX0 <= 7'b1010101;
			HEX1 <= 7'b1010101;
		end
	endcase	
		
	if ( count == 2'b11 )
		count <= 2'b00;
	else
		count <= count + 2'b01;
	end

	if( (MINH == MINH1) && (MINL == MINL1) && (HOURH == HOURH1) && (HOURL == HOURL1) )
		LED = 1'b1;
	else
		LED = 1'b0;
end
endmodule

