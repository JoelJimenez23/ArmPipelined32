module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrcD,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemtoRegE,
	MemWriteM,
	RegWriteM,
	PCSrcW,
	RegWriteW,
	MemtoRegW,
	DivMulRegSrcD,
	CarryE,
	ALUResultSrcE,
	ByteOpW,
	InstrD_7_4,
	MulOpE,
	RegWriteMulTopW,
	MemIndexW,
	IndexOpW	
);

	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	output wire [1:0] RegSrcD;
	output wire [1:0] ImmSrcD;
	output wire ALUSrcE;
	output wire [3:0] ALUControlE;
	output wire MemtoRegE;
	output wire MemWriteM;
	output wire RegWriteM;
	output wire PCSrcW;
	output wire RegWriteW;
	output wire MemtoRegW;

	output wire DivMulRegSrcD;
	output wire CarryE;
	output wire [1:0] ALUResultSrcE;
	output wire ByteOpW;
	input wire [3:0] InstrD_7_4;
	output wire MulOpE;
	output wire RegWriteMulTopW;
	output wire MemIndexW;
	output wire IndexOpW;

	//DECODE
	wire PCSrcD;
	wire RegWriteD;
	wire MemtoRegD;
	wire MemWriteD;
	wire [3:0] ALUControlD;
	wire BranchD;
	wire ALUSrcD;
	wire [1:0] FlagWriteD;
	wire RegWriteMulTopD;
	wire [1:0] ALUResultSrcD;
	wire ByteOpD;
	wire MemIndexD;
	wire IndexOpD;
	wire MulOpD;
	wire NoWriteD;
	//EXECUTE
	wire PCSrcE;
	wire RegWriteE;
	wire MemWriteE;
	wire BranchE;
	wire [1:0] FlagWriteE;
	wire [3:0] CondE;
	wire [3:0] FlagsE;
	wire NoWriteE;

	wire RegWriteMulTopE;
	wire ByteOpE;
	wire MemIndexE;
	wire IndexOpE;
	//MEMORY
	wire RegWriteMulTopM;
	wire PCSrcM;
	wire MemtoRegM;
	wire MemWriteMPrev;
	wire RegWriteMemoryM;
	wire ByteOpM;
	wire MemIndexM;
	wire IndexOpM;
	//AUX
	wire [3:0] FlagsNext;

	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagWriteD(FlagWriteD),
		.RegSrcD(RegSrcD),//muere aqui
		.ImmSrcD(ImmSrcD),//muere aqui
		.ALUSrcD(ALUSrcD),
		.ALUControlD(ALUControlD),
		.MemWriteD(MemWriteD),
		.BranchD(BranchD),
		.MemtoRegD(MemtoRegD),
		.PCSrcD(PCSrcD),
		.RegWriteD(RegWriteD),
		.DivMulRegSrcD(DivMulRegSrcD),
		.IndexOpD(IndexOpD),
		.RegWriteMulTopD(RegWriteMulTopD),
		.ALUResultSrcD(ALUResultSrcD),
		.ByteOpD(ByteOpD),
		.InstrD_7_4(InstrD_7_4),
		.MemIndexD(MemIndexD),
		.MulOpD(MulOpD),
		.NoWriteD(NoWriteD)
	);

	flopr #(1) NoWriteDReg(
		.clk(clk),
		.reset(reset),
		.d(NoWriteD),
		.q(NoWriteE)
	);

	flopr #(1) IndexOpDReg(
		.clk(clk),
		.reset(reset),
		.d(IndexOpD),
		.q(IndexOpE)
	);


	flopr #(1) PCSrcDReg(
		.clk(clk),
		.reset(reset),
		.d(PCSrcD),
		.q(PCSrcE)
	);

	flopr #(1) RegWriteDReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteD),
		.q(RegWriteE)
	);
	
	flopr #(1) MemtoRegDReg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegD),
		.q(MemtoRegE)
	);
	
	flopr #(1) MemWriteDReg(
		.clk(clk),
		.reset(reset),
		.d(MemWriteD),
		.q(MemWriteE)
	);

	flopr #(4) ALUControlDReg(
		.clk(clk),
		.reset(reset),
		.d(ALUControlD),
		.q(ALUControlE)
	);

	flopr #(1) BranchDReg(
		.clk(clk),
		.reset(reset),
		.d(BranchD),
		.q(BranchE)
	);

	flopr #(1) ALUSrcDReg(
		.clk(clk),
		.reset(reset),
		.d(ALUSrcD),
		.q(ALUSrcE)
	);

	flopr #(2) FlagWriteDReg(
		.clk(clk),
		.reset(reset),
		.d(FlagWriteD),
		.q(FlagWriteE)
	);

	flopr #(4) CondDReg(
		.clk(clk),
		.reset(reset),
		.d(Instr[31:28]),
		.q(CondE)
	);
	flopr #(4) FlagSReg(
		.clk(clk),
		.reset(reset),
		.d(FlagsNext),
		.q(FlagsE)
	);

	flopr #(2) ALUResultSrcDReg(
		.clk(clk),
		.reset(reset),
		.d(ALUResultSrcD),
		.q(ALUResultSrcE)
	);

	flopr #(1) RegWriteMemoryDReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMemoryD),
		.q(RegWriteMemoryE)
	);

	flopr #(1) ByteOpDReg(
		.clk(clk),
		.reset(reset),
		.d(ByteOpD),
		.q(ByteOpE)
	);

	flopr #(1) WriteMulTopDReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMulTopD),
		.q(RegWriteMulTopE)
	);

	flopr #(1) MemIndexDReg(
		.clk(clk),
		.reset(reset),
		.d(MemIndexD),
		.q(MemIndexE)
	);

	flopr #(1) MulOpDReg(
		.clk(clk),
		.reset(reset),
		.d(MulOpD),
		.q(MulOpE)
	);
	////////////////////////////////////////////

	condlogic cl(
		.clk(clk),
		.reset(reset),
		.ALUFlags(ALUFlags),
		.CondE(CondE),
		.FlagsE(FlagsE),
		.FlagWriteE(FlagWriteE),
		.BranchE(BranchE),
		.MemWriteE(MemWriteE),
		.RegWriteE(RegWriteE),
		.PCSrcE(PCSrcE),
		.FlagsNext(FlagsNext),//////outputs
		.PCSrcMPrev(PCSrcMPrev),
		.RegWriteMPrev(RegWriteMPrev),
		.MemWriteMPrev(MemWriteMPrev),
		.CarryE(CarryE),
		.NoWriteE(NoWriteE)
	);


	flopr #(1) PCSrcEReg(
		.clk(clk),
		.reset(reset),
		.d(PCSrcMPrev),
		.q(PCSrcM)
	);

	flopr #(1) RegWriteEReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMPrev),
		.q(RegWriteM)
	);

	flopr #(1) MemtoRegEReg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegE),
		.q(MemtoRegM)
	);

	flopr #(1) MemWriteEReg(
		.clk(clk),
		.reset(reset),
		.d(MemWriteMPrev),
		.q(MemWriteM)
	);


	flopr #(1) RegWriteMemoryEReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMemoryE),
		.q(RegWriteMemoryM)
	);

	flopr #(1) ByteOpEReg(
		.clk(clk),
		.reset(reset),
		.d(ByteOpE),
		.q(ByteOpM)
	);


	flopr #(1) IndexOpEReg(
		.clk(clk),
		.reset(reset),
		.d(IndexOpE),
		.q(IndexOpM)
	);

	flopr #(1) WriteMulTopEReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMulTopE),
		.q(RegWriteMulTopM)
	);

	flopr #(1) MemIndexEReg(
		.clk(clk),
		.reset(reset),
		.d(MemIndexE),
		.q(MemIndexM)
	);
	/////////////////////////////////////////////

	flopr #(1) PCSrcMReg(
		.clk(clk),
		.reset(reset),
		.d(PCSrcM),
		.q(PCSrcW)
	);

	flopr #(1) RegWriteMReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteM),
		.q(RegWriteW)
	);

	flopr #(1) MemtoRegMReg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegM),
		.q(MemtoRegW)
	);


	flopr #(1) RegWriteMemoryMReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMemoryM)
	);

	flopr #(1) ByteOpMReg(
		.clk(clk),
		.reset(reset),
		.d(ByteOpM),
		.q(ByteOpW)
	);

	flopr #(1) IndexOpMReg(
		.clk(clk),
		.reset(reset),
		.d(IndexOpM),
		.q(IndexOpW)
	);

	flopr #(1) WriteMulTopMReg(
		.clk(clk),
		.reset(reset),
		.d(RegWriteMulTopM),
		.q(RegWriteMulTopW)
	);

	flopr #(1) MemIndexMReg(
		.clk(clk),
		.reset(reset),
		.d(MemIndexM),
		.q(MemIndexW)
	);

endmodule
