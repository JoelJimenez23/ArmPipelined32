module datapath (
	clk,
	reset,
	InstrF,
	PCF,
	InstrD,
	RegSrcD,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemtoRegE,
	ALUFlags,
	ALUOutM,
	WriteDataM,
	ReadDataM,
	PCSrcW,
	RegWriteW,
	MemtoRegW,
	Match_1E_M,
	Match_2E_M,
	Match_1E_W,
	Match_2E_W,
	Match_3E_M,
	Match_3E_W,
	Match_4E_M,
	Match_4E_W,
	Match_1234D_E,
	ForwardAE,
	ForwardBE,
	ForwardCE,
	ForwardDE,
	StallF,
	StallD,
	FlushE,
	DivMulRegSrcD,
	CarryE,
	ALUResultSrcE,
	ByteOpW,
	MulOpE,
	RegWriteMulTopW,
	MemIndexW,
	IndexOpW
);

	input wire clk;
	input wire reset;
	input wire [31:0] InstrF;
	output wire [31:0] PCF;
	
	output wire [31:0] InstrD;
	input wire [1:0] RegSrcD;
	input wire [1:0] ImmSrcD;
	
	input wire ALUSrcE;
	input wire [3:0] ALUControlE;
	input wire MemtoRegE;
	output wire [3:0] ALUFlags;

	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
	input wire PCSrcW;
	input wire RegWriteW;
	input wire MemtoRegW;

	output wire Match_1E_M;
	output wire Match_2E_M;
	output wire Match_1E_W;
	output wire Match_2E_W;
	output wire Match_3E_M;
	output wire Match_3E_W;
	output wire Match_4E_M;
	output wire Match_4E_W;
	output wire Match_1234D_E;

	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire [1:0] ForwardCE;
	input wire [1:0] ForwardDE;
	input wire StallF;
	input wire StallD;
	input wire FlushE;

	input wire DivMulRegSrcD;
	input wire CarryE;
	input wire [1:0] ALUResultSrcE;
	input wire ByteOpW;
	input wire MulOpE;
	input wire RegWriteMulTopW;
	input wire MemIndexW;
	input wire IndexOpW;



	assign Match_1E_M = (RA1E == WA4M);
	assign Match_2E_M = (RA2E == WA4M);
	assign Match_1E_W = (RA1E == WA4W);
	assign Match_2E_W = (RA2E == WA4W);
	assign Match_3E_M = (RA3E == WA4M);
	assign Match_3E_W = (RA3E == WA4W);
	assign Match_4E_M = (WA4E == WA4M);
	assign Match_4E_W = (WA4E == WA4W);

	wire ra1d_wa3e;
	wire ra2d_wa3e;
	wire ra3d_wa3e;
	wire ra4d_wa3e;
	wire ra1d_wa3e_x;
	wire ra2d_wa3e_x;
	wire ra3d_wa3e_x;
	wire ra4d_wa3e_x;

	assign ra1d_wa3e = (RA1D == WA4E);
	assign ra2d_wa3e = (RA2D == WA4E);
	assign ra3d_wa3e = (InstrD[11:8] == WA4E);
	assign ra4d_wa3e = (WA4D == WA4E);

	assign ra1d_wa3e_x = (ra1d_wa3e === 1'bx) ? 0: ra1d_wa3e;
	assign ra2d_wa3e_x = (ra2d_wa3e === 1'bx) ? 0: ra2d_wa3e;
	assign ra3d_wa3e_x = (ra3d_wa3e === 1'bx) ? 0: ra3d_wa3e;
	assign ra4d_wa3e_x = (ra4d_wa3e === 1'bx) ? 0: ra4d_wa3e;

	assign Match_1234D_E = (ra1d_wa3e_x || ra2d_wa3e_x  || ra3d_wa3e_x || ra4d_wa3e_x); 



	wire [31:0] PCNext;
	///FETCH
	wire [31:0] PCPlus4F;
	///DECODE
	wire [3:0] preRA1D;
	wire [3:0] RA1D;
	wire [3:0] RA2D;
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] RD3D;
	wire [31:0] RD4D;
	wire [3:0] WA4D;
	wire [31:0] ExtImmD;
	wire [31:0] ExtImmD_rot;
	wire [7:0] ShiftInstrD;

	///EXECUTE
	wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] RD3E;
	wire [31:0] RD4E;
	wire [3:0] RA1E;
	wire [3:0] RA2E;
	wire [3:0] RA3E;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	wire [31:0] WriteDataEShifted;
	wire [3:0] 	WA4E;
	wire [31:0] ExtImmE;
	wire [31:0] ALUResultE;
	wire [7:0] ShiftInstrE;
	wire [31:0] MulHalfTopE;
	wire [31:0] SrcAEMulE;
	wire [31:0] RD3Ehz;
	wire [31:0] RD4Ehz;
	wire [31:0] SrcAEDivE;
	wire [3:0] MULAuxE;
	wire [31:0] ALUResultEPost;

	wire [2:0] MulInstrE;
	wire DivInstrE;

	///MEMORY
	wire [3:0] WA4M;
	wire [31:0] MulHalfTopM;
	wire [31:0] ALUResultM;
	wire [3:0] MULAuxM;
	wire [3:0] RA1M;
	///WRITE
	wire [31:0] ResultW;
	wire [31:0] ALUOutW;
	wire [31:0] ReadDataW;
	wire [3:0] WA4W;
	wire [31:0] MulHalfTopW;
	wire [31:0] ALUResultW;
	wire [3:0] MULAuxW;
	wire [31:0] ReadDataWPost;
	wire [31:0] ALUResultWIndex;
	wire [3:0] RA1W;


	mux2 #(32) pcmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCNext)
	);
	
	flopenr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.en(~StallF),
		.d(PCNext),
		.q(PCF)
	);

	adder #(32) pcadd1(
		.a(PCF),
		.b(32'b100),
		.y(PCPlus4F)
	);

	flopenr #(32) InstrReg(
		.clk(clk),
		.reset(reset),
		.en(~StallD),
		.d(InstrF),
		.q(InstrD)
	);
///////////////////////////////
	mux2 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(preRA1D) ///
	);


	mux2 #(4) ra3mux(
		.d0(preRA1D),
		.d1(InstrD[3:0]),
		.s(DivMulRegSrcD),
		.y(RA1D)
	);

	
	mux21 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.s(RegSrcD[1]),
		.x(DivMulRegSrcD),
		.y(RA2D)
	);


	mux2 #(4) ra4mux(
		.d0(InstrD[15:12]),
		.d1(InstrD[19:16]),
		.s(DivMulRegSrcD),
		.y(WA4D)
	);

	regfile rf(
		.clk(~clk),
		.we1(IndexOpW),
		.we4(RegWriteW),
		.we5(RegWriteMulTopW),
		.ra1(RA1D),
		.ra2(RA2D),
		.ra3(InstrD[11:8]),
		.ra4(WA4D),
		.wa1(RA1W),
		.wa4(WA4W),
		.wa5(MULAuxW),
		.wd1(ALUResultWIndex),
		.wd4(ResultW),
		.wd5(MulHalfTopW), ////
		.r15(PCPlus4F), //PCPlus8D
		.rd1(RD1D),
		.rd2(RD2D),
		.rd3(RD3D),
		.rd4(RD4D)
	);

	floprc #(4) RA1DReg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(RA1D),
		.q(RA1E)
	);

	floprc #(4) RA2DReg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(RA2D),
		.q(RA2E)
	);

	floprc #(4) RA3DReg(
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(InstrD[11:8]),
		.q(RA3E)
	);


	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImmD)
	);

	floprc #(4) MulAuxDReg(
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(InstrD[15:12]),
		.q(MULAuxE)
	);

	floprc #(3) MulInstrDReg(
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(InstrD[23:21]),
		.q(MulInstrE)
	);

	floprc #(1) DivInstrDReg(
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(InstrD[21]),
		.q(DivInstrE)	
	);

	floprc #(32) RD1Reg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(RD1D),
		.q(RD1E) 
	);


	mux3 #(32) ForwardAEMux(
		.d0(RD1E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);


	floprc #(32) RD2Reg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(RD2D),
		.q(RD2E)
	);

	mux3 #(32) ForwardBEMux(
		.d0(RD2E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardBE),
		.y(WriteDataE)
	);

	floprc #(32) RD3Reg(
		.clk(clk),
		.reset(reset),
		.clear(clear),
		.d(RD3D),
		.q(RD3E)
	);

	mux3 #(32) ForwardCEMux(
		.d0(RD3E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardCE),
		.y(RD3Ehz)
	);

	floprc #(32) RA4DReg(
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(RD4D),
		.q(RD4E)
	);

	mux3 #(32) ForwardDEMux(
		.d0(RD4E),
		.d1(ResultW),
		.d2(ALUOutW),
		.s(ForwardDE),
		.y(RD4Ehz)
	);

	floprc #(4) WA4DReg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(WA4D),
		.q(WA4E)
	);

	floprc #(8) ShiftInstrDReg(
		.clk(clk),
		.reset(reset),
		.clear(clear),
		.d(InstrD[11:4]),
		.q(ShiftInstrE)
	);

	rotate rot(
		.ExtImm(ExtImmD),
		.rot(InstrD[11:8]),
		.ExtImm_rot(ExtImmD_rot)
	);

	floprc #(32) ExtReg( ///
		.clk(clk),
		.reset(reset),
		.clear(FlushE),
		.d(ExtImmD_rot),
		.q(ExtImmE)
	);
	
/////////////////////////

	shifter shift(
		.rs(RD3Ehz),
		.shamt5(ShiftInstrE[7:3]),
		.sh(ShiftInstrE[2:1]),
		.op(ShiftInstrE[0]),
		.op1(ShiftInstrE[3]),
		.rm(WriteDataE),
		.y(WriteDataEShifted)
	);


	mux2 #(32) SrcBMux(
		.d0(WriteDataEShifted),
		.d1(ExtImmE),
		.s(ALUSrcE),
		.y(SrcBE)
	);


	multiplier mult(
		.rn(SrcAE),
		.rm(RD3Ehz),
		.ra(SrcBE),
		.rd(RD4Ehz),
		.mul_op(MulOpE),
		.mul_cmd(MulInstrE),
		.y(SrcAEMulE),
		.aux(MulHalfTopE)
	);


	divider div(
		.rn(SrcAE),
		.rm(RD3Ehz),
		.op(DivInstrE),
		.y(SrcAEDivE)
	);


	alu al(
		.preSrcA(SrcAEMulE),
		.preSrcB(SrcBE),
		.ALUControl(ALUControlE),
		.ALUResult(ALUResultE),
		.ALUFlags(ALUFlags),
		.carryIn(CarryE)
	);


	mux4 #(32) ALUResultEPostMux(
		.d0(ALUResultE),
		.d1(SrcBE),
		.d2(SrcAEMulE),
		.d3(SrcAEDivE),
		.s(ALUResultSrcE),
		.y(ALUResultEPost)
	);

	flopr #(32) ALUPreOutReg(
		.clk(clk),
		.reset(reset),
		.d(ALUResultEPost),
		.q(ALUOutM)
	);

	flopr #(32) ALUResultEReg(
		.clk(clk),
		.reset(reset),
		.d(ALUResultE),
		.q(ALUResultM)
	);

	flopr #(32) MulHalfTopEReg(
		.clk(clk),
		.reset(reset),
		.d(MulHalfTopE),
		.q(MulHalfTopM)
	);

	flopr #(32) WriteDataReg(
		.clk(clk),
		.reset(reset),
		.d(WriteDataEShifted),
		.q(WriteDataM)
	);


	flopr #(4) WA4EReg(
		.clk(clk),
		.reset(reset),
		.d(WA4E),
		.q(WA4M)
	);

	flopr #(4) MulAuxEReg(
		.clk(clk),
		.reset(reset),
		.d(MULAuxE),
		.q(MULAuxM)
	);

	flopr #(4) RA1EReg( 
		.clk(clk),
		.reset(reset),
		.d(RA1E),
		.q(RA1M)
	);


/////////////////////////////
	
	flopr #(32) ReadDataReg(
		.clk(clk),
		.reset(reset),
		.d(ReadDataM),
		.q(ReadDataW)
	);
	flopr #(32) ALUOutReg(
		.clk(clk),
		.reset(reset),
		.d(ALUOutM),
		.q(ALUOutW)
	);
	flopr #(4) WA4MReg(
		.clk(clk),
		.reset(reset),
		.d(WA4M),
		.q(WA4W)
	);

	flopr #(32) MulHalfTopMReg(
		.clk(clk),
		.reset(reset),
		.d(MulHalfTopM),
		.q(MulHalfTopW)
	);

	flopr #(32) ALUResultMReg(
		.clk(clk),
		.reset(reset),
		.d(ALUResultM),
		.q(ALUResultW)
	);


	flopr #(4) MulAuxMReg(
		.clk(clk),
		.reset(reset),
		.d(MULAuxM),
		.q(MULAuxW)
	);


	flopr #(4) RA1MReg( 
		.clk(clk),
		.reset(reset),
		.d(RA1M),
		.q(RA1W)
	);


/////////////////////////////
	
	byteselector bso(
		.ReadDataW(ReadDataW),
		.ALUResultW(ALUResultW),
		.ByteOp(ByteOpW),
		.ReadDataWPost(ReadDataWPost)
	);

	mux2 #(32) MemIndexRegMux(
		.d0(ALUResultW),
		.d1(ALUOutW),
		.s(MemIndexW),
		.y(ALUResultWIndex)
	);


	mux2 #(32) MemtoRegMux(
		.d0(ALUOutW),
		.d1(ReadDataWPost),
		.s(MemtoRegW),
		.y(ResultW)
	);


endmodule


