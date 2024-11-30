module arm (
	clk,
	reset,
	PCF,
	InstrF,
	MemWriteM,
	ALUOutM,
	WriteDataM,
	ReadDataM
);
	input wire clk;
	input wire reset;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire MemWriteM;
	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;

	wire [31:0] InstrD;
	wire [1:0] RegSrcD,ImmSrcD;
	wire ALUSrcE;
	wire [3:0] ALUControlE;
	wire MemtoRegE;
	wire RegWriteM;
	wire MemtoRegW;
	wire PCSrcW;
	wire RegWriteW;

	wire [3:0] ALUFlags;

	wire Match_1E_M;
	wire Match_2E_M;
	wire Match_1E_W;
	wire Match_2E_W;
	wire Match_3E_M;
	wire Match_3E_W;
	wire Match_4E_M;
	wire Match_4E_W;
	wire [1:0] ForwardAE;
	wire [1:0] ForwardBE;
	wire [1:0] ForwardCE;
	wire [1:0] ForwardDE;
	wire Match_1234D_E;
	wire StallF;
	wire StallD;
	wire FlushE;
	wire DivMulRegSrcD;
	wire CarryE;
	wire [1:0] ALUResultSrcE;
	wire ByteOpW;
	wire [3:0] InstrD_7_4;
	wire MulOpE;
	wire RegWriteMulTopW;
	wire MemIndexW;
	wire IndexOpW;

	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(InstrD[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrcD(RegSrcD),
		.ImmSrcD(ImmSrcD),
		.ALUSrcE(ALUSrcE),
		.ALUControlE(ALUControlE),
		.MemtoRegE(MemtoRegE),
		.MemWriteM(MemWriteM),
		.RegWriteM(RegWriteM),
		.PCSrcW(PCSrcW),
		.RegWriteW(RegWriteW),
		.MemtoRegW(MemtoRegW),
		.DivMulRegSrcD(DivMulRegSrcD),
		.CarryE(CarryE),
		.ALUResultSrcE(ALUResultSrcE),
		.ByteOpW(ByteOpW),
		.InstrD_7_4(InstrD[7:4]),
		.MulOpE(MulOpE),
		.RegWriteMulTopW(RegWriteMulTopW),
		.MemIndexW(MemIndexW),
		.IndexOpW(IndexOpW)
	);

	datapath dp(
		.clk(clk),
		.reset(reset),
		.InstrF(InstrF),
		.PCF(PCF),
		.InstrD(InstrD),
		.RegSrcD(RegSrcD),
		.ImmSrcD(ImmSrcD),
		.ALUSrcE(ALUSrcE),
		.ALUControlE(ALUControlE),
		.MemtoRegE(MemtoRegE),
		.ALUFlags(ALUFlags),
		.ALUOutM(ALUOutM),
		.WriteDataM(WriteDataM),
		.ReadDataM(ReadDataM),
		.PCSrcW(PCSrcW),
		.RegWriteW(RegWriteW),
		.MemtoRegW(MemtoRegW),
		.Match_1E_M(Match_1E_M),
		.Match_2E_M(Match_2E_M),
		.Match_1E_W(Match_1E_W),
		.Match_2E_W(Match_2E_W),
		.Match_3E_M(Match_3E_M),
		.Match_3E_W(Match_3E_W),
		.Match_4E_M(Match_4E_M),
		.Match_4E_W(Match_4E_W),
		.Match_1234D_E(Match_1234D_E),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.ForwardCE(ForwardCE),
		.ForwardDE(ForwardDE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE),
		.DivMulRegSrcD(DivMulRegSrcD),
		.CarryE(CarryE),
		.ALUResultSrcE(ALUResultSrcE),
		.ByteOpW(ByteOpW),
		.MulOpE(MulOpE),
		.RegWriteMulTopW(RegWriteMulTopW),
		.MemIndexW(MemIndexW),
		.IndexOpW(IndexOpW)
	);

	hazard hzd(
		.Match_1E_M(Match_1E_M),
		.Match_2E_M(Match_2E_M),
		.Match_1E_W(Match_1E_W),
		.Match_2E_W(Match_2E_W),
		.Match_3E_M(Match_3E_M),
		.Match_3E_W(Match_3E_W),
		.Match_4E_M(Match_4E_M),
		.Match_4E_W(Match_4E_W),
		.Match_1234D_E(Match_1234D_E),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.ForwardCE(ForwardCE),
		.ForwardDE(ForwardDE),
		.MemtoRegE(MemtoRegE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE)
	);

endmodule
