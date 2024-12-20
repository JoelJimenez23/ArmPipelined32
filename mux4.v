module mux4 (
	d0,
	d1,
	d2,
    d3,
	s,
	y
);
	parameter WIDTH = 8;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	input wire [WIDTH - 1:0] d2;
	input wire [WIDTH - 1:0] d3;
	input wire [1:0] s;
	output wire [WIDTH - 1:0] y;
	assign y =  (s == 2'b00) ? d0:
                (s == 2'b01) ? d1:
                (s == 2'b10) ? d2:
                d3;
endmodule
