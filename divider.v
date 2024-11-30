module signed_div(rn,rm,y);
	input wire signed [31:0] rn,rm;
	output wire signed [31:0] y;
	assign y = rn/rm;	
endmodule

module absolute_value(value,abs_value);
	input wire signed [31:0] value;
	output wire [31:0] abs_value;
	assign abs_value = (value < 0) ? -value :value;
endmodule


module usigned_div(rn,rm,y);
	input wire [31:0] rn,rm;
	output wire [31:0] y;
	wire [31:0] abs_rn,abs_rm;

	absolute_value a_rn(rn,abs_rn);
	absolute_value a_rm(rm,abs_rm);

	assign y = (abs_rm != 0 && abs_rn != 0) ? (abs_rn / abs_rm) : 0;

endmodule


module divider(rn,rm,op,y);
	input wire [31:0] rn,rm;
	input wire op;
	output wire [31:0] y;

	wire [31:0] s_y,u_y;
	signed_div s(rn,rm,s_y);
	usigned_div u(rn,rm,u_y);
	
	assign y = (op == 1) ? u_y : s_y;

endmodule
