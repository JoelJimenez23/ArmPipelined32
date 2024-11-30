module decode (
	Op,
	Funct,
	Rd,
	FlagWriteD,
	RegSrcD,
	ImmSrcD,
	ALUSrcD,
	ALUControlD,
	MemWriteD,
	BranchD,
	MemtoRegD,
	PCSrcD,
	RegWriteD,
	DivMulRegSrcD,
	IndexOpD,
	RegWriteMulTopD,
	ALUResultSrcD,
	ByteOpD,
	InstrD_7_4,
	MemIndexD,
	MulOpD,
	NoWriteD
);

	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagWriteD;
	output wire [1:0] RegSrcD;
	output wire [1:0] ImmSrcD;
	output wire ALUSrcD;
	output reg [3:0] ALUControlD;
	output wire MemWriteD;
	output wire BranchD;
	output wire MemtoRegD;
	output wire PCSrcD;
	output wire RegWriteD;
	///
	output wire DivMulRegSrcD;
	output wire IndexOpD;
	output wire RegWriteMulTopD;
	output wire [1:0] ALUResultSrcD;
	output wire ByteOpD;
	input wire [3:0] InstrD_7_4;
	output wire MemIndexD;
	output wire MulOpD;
	output reg NoWriteD;

	reg DivMulRegSrcD_;
	reg IndexOpD_;
	reg RegWriteMulTopD_;
	reg [1:0] ALUResultSrcD_;
	reg MemIndexD_;
	reg MulOpD_;

	reg [10:0] controls;
	wire Branch;
	wire ALUOp;
	
	always @(*)
		casex (Op)
			2'b00: begin
				if (Funct[5])begin
					if(Funct[4:1] == 4'b1101) begin
						if(InstrD_7_4 == 4'b1001)
							controls = 11'b00000010000; /// desactivar aluop
						else 
							controls = 11'b00000010010;						
					end
					else begin
						if(InstrD_7_4 == 4'b1001)
							controls = 11'b00001010000; /// desactivar aluop
						else 
							controls = 11'b00001010010;
					end
				end
				else
					if(InstrD_7_4 == 4'b1001)
						controls = 11'b00000010000;/// desactivar aluop
					else 
						controls = 11'b00000010010;
			end
			2'b01: begin
				if (Funct[0]) begin
					if (Funct[2]) begin
						if(Funct[5]) begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b00010010001;
							else
								controls = 11'b00010110001;
						end
						else begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b00011010001;
							else
								controls = 11'b00011110001;
						end
					end
					else begin
						if(Funct[5]) begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b00010010000;
							else 
								controls = 11'b00010110000;
						end
						else begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b00011010000;
							else
								controls = 11'b00011110000;
						end
					end
				end
				else begin
					if (Funct[2]) begin
						if(Funct[5]) begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b10010001001;
							else 
								controls = 11'b10010101001;
						end
						else begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b10011001001;
							else
								controls = 11'b10011101001;
						end
					end
					else begin
						if(Funct[5]) begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b10010001000;
							else
								controls = 11'b10010101000;
						end
						else begin
							if(InstrD_7_4 == 4'b0001)
								controls = 11'b10011001000;
							else
								controls = 11'b10011101000;
						end
					end
				end
			end
			2'b10: controls = 11'b01101000100;
			default: controls = 11'bxxxxxxxxxxx;
		endcase
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOp, ByteOpD} = controls;

	always @(*)
		casex (Op)
			2'b00: begin
				RegWriteMulTopD_ = 0;
				IndexOpD_ = 0;
				MemIndexD_ = 0;
				if(Funct[4:1] == 4'b1101) begin
					ALUResultSrcD_ = 2'b01; //shift
					DivMulRegSrcD_ = 0;
					MulOpD_  = 0;
				end
				else begin
					if(InstrD_7_4 == 4'b1001 && Funct[5:4] == 2'b00)begin //mulop agregar
						DivMulRegSrcD_ = 1;
						MulOpD_ = 1;
						if(Funct[3:1] == 3'b001 || Funct[3:1] == 3'b000)begin
							ALUResultSrcD_ = 2'b10; //mla mul
							RegWriteMulTopD_ = 0;
						end
						else begin
							ALUResultSrcD_ = 2'b10;
							RegWriteMulTopD_ = 1;
						end
					end
					else begin
						ALUResultSrcD_ = 2'b00;
						DivMulRegSrcD_ = 0;
						MulOpD_  = 0;
					end
				end
			end
			2'b01:  begin
				RegWriteMulTopD_ = 0;
				MemIndexD_ = 0;
				IndexOpD_ = 0;
				if(Funct[1] == 0 && Funct[4] == 0) begin
					IndexOpD_ = 1;
					MemIndexD_ = 0;
					ALUResultSrcD_ = 2'b10; //post index
					DivMulRegSrcD_ = 0;
					MulOpD_  = 0;
				end
				else begin 
					if(Funct[1] == 1 && Funct[4] == 1 && Rd != 4'b1111 && InstrD_7_4 != 4'b0001)begin
						IndexOpD_ = 1;
						MemIndexD_ = 1;
						ALUResultSrcD_ = 2'b00; // preindex
						DivMulRegSrcD_ = 0;
						MulOpD_  = 0;
					end
					else begin
						if(Funct[5:2] == 4'b1100 && Funct[0] == 1'b1 && Rd == 4'b1111 && InstrD_7_4 == 4'b0001)begin
							DivMulRegSrcD_ = 1;
							ALUResultSrcD_ = 2'b11; //div op agregar
							MulOpD_  = 0;
						end
						else begin
							DivMulRegSrcD_ = 0;
							MulOpD_  = 0;
						end
					end
				end
			end
		endcase

	assign ALUResultSrcD = ALUResultSrcD_; 
	assign DivMulRegSrcD = DivMulRegSrcD_;
	assign IndexOpD = IndexOpD_;
	assign RegWriteMulTopD = RegWriteMulTopD_;
	assign MemIndexD = MemIndexD_;
	assign MulOpD = MulOpD_;



	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0000: begin ALUControlD = 4'b0010; NoWriteD = 0; end//and
				4'b0001: begin ALUControlD = 4'b1111; NoWriteD = 0; end//xor
				4'b0010: begin ALUControlD = 4'b0001; NoWriteD = 0; end//sub
				4'b0011: begin ALUControlD = 4'b1001; NoWriteD = 0; end//rsb
				4'b0100: begin ALUControlD = 4'b0000; NoWriteD = 0; end//add
				4'b0101: begin ALUControlD = 4'b0100; NoWriteD = 0; end//adc add carry
				4'b0110: begin ALUControlD = 4'b0101; NoWriteD = 0; end//sbc sub carry
				4'b0111: begin ALUControlD = 4'b1101; NoWriteD = 0; end//rsc reverse sub carry
				4'b1000: begin ALUControlD = 4'b0010; NoWriteD = 1; end//tst and
				4'b1001: begin ALUControlD = 4'b1111; NoWriteD = 1; end//teq xor
				4'b1010: begin ALUControlD = 4'b0001; NoWriteD = 1; end//cmp sub
				4'b1011: begin ALUControlD = 4'b0000; NoWriteD = 1; end//cmn add
				4'b1100: begin ALUControlD = 4'b0011; NoWriteD = 0; end//or
				4'b1101: begin ALUControlD = 4'bxxxx; NoWriteD = 0; end//shifts
				4'b1110: begin ALUControlD = 4'b0110; NoWriteD = 0; end //bic rn & ~src2
				4'b1111: begin ALUControlD = 4'b1110; NoWriteD = 0; end // rd <- ~rn
				default: begin ALUControlD = 4'b0000; NoWriteD = 0; end
			endcase
			FlagWriteD[1] = Funct[0];
			FlagWriteD[0] = Funct[0] & ((ALUControlD == 4'b0000) | (ALUControlD == 4'b0001));
			NoWriteD = 0;
		end
		else begin
			ALUControlD = (Op == 2'b01 && Funct[3] == 0) ? 4'b0001 : 4'b0000;
			FlagWriteD = 2'b00;
		end
	assign PCSrcD = ((Rd == 4'b1111) & RegWriteD) | BranchD;
endmodule
