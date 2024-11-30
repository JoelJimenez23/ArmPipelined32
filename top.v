module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWrite
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWrite;
	wire [31:0] PCF;
	wire [31:0] InstrF;
	wire [31:0] ReadData;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PCF(PCF),
		.InstrF(InstrF),
		.MemWriteM(MemWrite),
		.ALUOutM(DataAdr),
		.WriteDataM(WriteData),
		.ReadDataM(ReadData)
	);
	imem imem(
		.a(PCF),
		.rd(InstrF)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule
