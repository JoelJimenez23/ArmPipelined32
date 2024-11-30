module hazard(
	Match_1E_M,
	Match_2E_M,
	Match_1E_W,
	Match_2E_W,
	Match_3E_M,
	Match_3E_W,
	Match_4E_M,
	Match_4E_W,
	Match_1234D_E,
	RegWriteM,
	RegWriteW,
	ForwardAE,
	ForwardBE,
	ForwardCE,
	ForwardDE,
	MemtoRegE,
	StallF,
	StallD,
	FlushE
);
	input wire Match_1E_M;
	input wire Match_2E_M;
	input wire Match_1E_W;
	input wire Match_2E_W;
	input wire Match_3E_M;
	input wire Match_3E_W;
	input wire Match_4E_M;
	input wire Match_4E_W;
	input wire Match_1234D_E;
	input wire RegWriteM;
	input wire RegWriteW;
	output wire [1:0] ForwardAE;
	output wire [1:0] ForwardBE;
	output wire [1:0] ForwardCE;
	output wire [1:0] ForwardDE;
	input wire MemtoRegE;
	output wire StallF;
	output wire StallD;
	output wire FlushE;
	
	assign ForwardAE = (Match_1E_M && RegWriteM) ? 2'b10:
										 (Match_1E_W && RegWriteW) ? 2'b01:
										 2'b00;

	assign ForwardBE = (Match_2E_M && RegWriteM) ? 2'b10:
										 (Match_2E_W && RegWriteW) ? 2'b01:
										 2'b00;

	assign ForwardCE = (Match_3E_M && RegWriteM) ? 2'b10:
										 (Match_3E_W && RegWriteW) ? 2'b01:
										 2'b00;

	assign ForwardDE = (Match_4E_M && RegWriteM) ? 2'b10:
										 (Match_4E_W && RegWriteW) ? 2'b01:
										 2'b00;


	assign FlushE = (Match_1234D_E && MemtoRegE);
	assign StallD = FlushE;
	assign StallF = StallD;


endmodule
