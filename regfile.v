module regfile (
	clk,
	we1,
	we4,
	we5,
	ra1,
	ra2,
	ra3,
	ra4,
	wa1,
	wa4,
	wa5,
	wd1,
	wd4,
	wd5,
	r15,
	rd1,
	rd2,
	rd3,
	rd4
);
	input wire clk;
	input wire we1;
	input wire we4;
	input wire we5;
	input wire [3:0] ra1;
	input wire [3:0] ra2;
	input wire [3:0] ra3;
	input wire [3:0] ra4;
	input wire [3:0] wa1;
	input wire [3:0] wa4;
	input wire [3:0] wa5;
	input wire [31:0] wd1;
	input wire [31:0] wd4;
	input wire [31:0] wd5;
	input wire [31:0] r15;
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	output wire [31:0] rd3;
	output wire [31:0] rd4;
	reg [31:0] rf [14:0];
	wire [31:0] r0;
	wire [31:0] r1;
	wire [31:0] r2;
	wire [31:0] r3;
	wire [31:0] r4;

	always @(posedge clk) begin
		if (we1)
			rf[wa1] <= wd1;
	end
	always @(posedge clk) begin
		if (we4)
			rf[wa4] <= wd4;
	end
	always @(posedge clk) begin
		if (we5)
			rf[wa5] <= wd5;
	end

	assign rd1 = (ra1 == 4'b1111 ? r15 : rf[ra1]);
	assign rd2 = (ra2 == 4'b1111 ? r15 : rf[ra2]);
	assign rd3 = (ra3 == 4'b1111 ? r15 : rf[ra3]);
	assign rd4 = (ra4 == 4'b1111 ? r15 : rf[ra4]);
	assign r0 = rf[0];
	assign r1 = rf[1];
	assign r2 = rf[2];
	assign r3 = rf[3];
	assign r4 = rf[4];
endmodule
