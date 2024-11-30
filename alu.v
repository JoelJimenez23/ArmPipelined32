module alu(preSrcA,preSrcB,ALUControl,ALUResult,ALUFlags,carryIn);
	input wire  [31:0] preSrcA;
	input wire  [31:0] preSrcB;
	input wire [3:0] ALUControl; 
	output wire [3:0] ALUFlags;
	output reg [31:0] ALUResult;
	input wire carryIn;


	wire neg,zero,carry,overflow;
	wire [31:0] condinvb;
	wire [32:0] sum;
	wire carry_sum;
	wire [31:0] SrcA,SrcB;

	assign SrcA = ALUControl[3] ? preSrcB: preSrcA; //reverse
	assign SrcB = ALUControl[3] ? preSrcA: preSrcB;

	assign carry_sum =  ALUControl[2] ? carryIn : ALUControl[0]; //carry
	assign condinvb = ALUControl[0] ? ~SrcB : SrcB; //~Src2
	assign sum = SrcA + condinvb + carry_sum;

	

	assign neg = ALUResult[31];
	assign zero = (ALUResult == 32'b0);
	assign carry = (ALUControl[1] == 1'b0) & sum[32];
	assign overflow = (ALUControl[1] == 1'b0) & ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) & (SrcB[31] ^ sum[31]);
	assign ALUFlags = {neg,zero,carry,overflow};

	always@(*)
		begin
			casex (ALUControl[1:0])
				4'b0000:ALUResult = sum; //add
				4'b0001:ALUResult = sum; //sub
				4'b0100:ALUResult = sum; //adc
				4'b0101:ALUResult = sum; //sbc
				4'b1001:ALUResult = sum; //rsb
				4'b1101:ALUResult = sum; //rsc
				4'b0010:ALUResult = SrcA && SrcB; //and
				4'b0110:ALUResult = SrcA && condinvb; //bic
				4'b1110:ALUResult = condinvb; //mvn
				4'b0011:ALUResult = SrcA || SrcB; // orr
				4'b1111:ALUResult = preSrcA ^ preSrcB; //xor
				default:ALUResult =  sum;
			endcase
		end
endmodule
