module condlogic (
	clk,
	reset,
	ALUFlags,
	CondE,
	FlagsE,
	FlagWriteE,
	BranchE,
	MemWriteE,
	RegWriteE,
	PCSrcE,
	FlagsNext,
	PCSrcMPrev,
	RegWriteMPrev,
	MemWriteMPrev,
	CarryE,
	NoWriteE
);
	input wire clk;
	input wire reset;
	input wire [3:0] ALUFlags;
	input wire [3:0] CondE;
	input wire [3:0] FlagsE;
	input wire [1:0] FlagWriteE;
	input wire BranchE;
	input wire MemWriteE;
	input wire RegWriteE;
	input wire PCSrcE;
	output wire [3:0] FlagsNext;
	output wire PCSrcMPrev;
	output wire RegWriteMPrev;
	output wire MemWriteMPrev;
	output wire CarryE;
	input wire NoWriteE;

	wire CondExE;
	wire [1:0] FlagWrite;


	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(FlagsNext[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(FlagsNext[1:0])
	);

	condcheck cc(
		.Cond(CondE),
		.Flags(FlagsNext),
		.CondEx(CondExE)
	);

	assign CarryE = FlagsNext[1];
	assign FlagWrite = FlagWriteE & {2 {CondExE}};
	assign PCSrcMPrev = ((PCSrcE && CondExE) || (BranchE && CondExE));
	assign RegWriteMPrev = (RegWriteE && CondExE && ~NoWriteE);
	assign MemWriteMPrev = (MemWriteE && CondExE);

endmodule
