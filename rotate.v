module rotate(ExtImm,rot,ExtImm_rot);
	input wire [31:0] ExtImm;
	input wire [3:0] rot;
	output wire [31:0] ExtImm_rot;
	assign ExtImm_rot = (ExtImm >> rot) | (ExtImm << (32 - rot));
endmodule