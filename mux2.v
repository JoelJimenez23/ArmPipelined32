module mux2 (
	d0,
	d1,
	s,
	y
);
	parameter WIDTH = 8;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	input wire s;
	output wire [WIDTH - 1:0] y;
	assign y = (s ? d1 : d0);
endmodule



module mux21 (
	d0,
	d1,
	s,
    x,
	y
);
	parameter WIDTH = 8;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	input wire s;
    input wire x;
	output wire [WIDTH - 1:0] y;
	assign y =  (s == 1 && x == 0) ? d1: 
                (s == 0 && x == 0) ? d0: 
                (s == 1 && x == 1) ? d0:
                (s == 0 && x == 1) ? d1:
                d0;
endmodule