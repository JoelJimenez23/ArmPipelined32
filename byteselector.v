module byteselector(
    ReadDataW,
    ALUResultW,
    ByteOp,
    ReadDataWPost
);
    input wire [31:0] ReadDataW;
    input wire [31:0] ALUResultW;
    input wire ByteOp;
    output wire [31:0] ReadDataWPost;

    assign ReadDataWPost =  (ByteOp == 1 && ALUResultW[1:0] == 2'b00) ? {24'b0,ReadDataW[7:0]} :
                            (ByteOp == 1 && ALUResultW[1:0] == 2'b01) ? {24'b0,ReadDataW[15:8]}:
                            (ByteOp == 1 && ALUResultW[1:0] == 2'b10) ? {24'b0,ReadDataW[23:15]}:
                            (ByteOp == 1 && ALUResultW[1:0] == 2'b11) ? {24'b0,ReadDataW[31:16]}:
                            (ByteOp == 0) ? ReadDataW : ReadDataW;

endmodule