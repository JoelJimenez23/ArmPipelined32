module lsl(rm,shift_offset,lsl_value);
    input wire [31:0] rm;
	input wire [31:0] shift_offset;
	output wire [31:0] lsl_value;

	assign lsl_value = rm << shift_offset;

endmodule

module lsr(rm,shift_offset,lsr_value);
	input wire [31:0] rm;
	input wire [31:0] shift_offset;
	output wire [31:0] lsr_value;

	assign lsr_value = rm >> shift_offset;

endmodule

module asr(rm,shift_offset,asr_value);
	input wire [31:0] rm;
	input wire [31:0] shift_offset;
	output wire [31:0] asr_value;

	assign asr_value = rm >> shift_offset;

endmodule

module mux_shift(rs,shamt5,op,op1,value2shift);
	input wire [31:0] rs;
	input wire [4:0] shamt5;
	input wire op,op1;
	output wire [31:0] value2shift;

	assign value2shift = (op == 0) ? {27'b0,shamt5}  : 
						(op == 1 && op1 == 1) ? 32'b0:
						rs;

endmodule

module shifter(rs,shamt5,sh,op,op1,rmi,isImm,rm,y);
	input wire [31:0] rs;
	input wire [4:0] shamt5;
	input wire [1:0] sh;
	input wire op,op1;
	input wire [3:0] rmi;
	input wire isImm;
	input wire [31:0] rm;
	output wire [31:0] y;
	
	wire [31:0] shift_offset,lsl_shift,lsr_shift,asr_shift;

	mux_shift mx_sh(rs,shamt5,op,op1,shift_offset);
	lsl l(rm,shift_offset,lsl_shift);
	lsr r(rm,shift_offset,lsr_shift);
	asr a(rm,shift_offset,asr_shift);
	
	assign y = (isImm) ? {20'b0,shamt5,sh,op,rmi}:
		(sh == 2'b00 && isImm == 0) ? lsl_shift :
		(sh == 2'b01 && isImm == 0) ? lsr_shift :
		(sh == 2'b10 && isImm == 0) ? asr_shift :
		{32'b0} ;

endmodule