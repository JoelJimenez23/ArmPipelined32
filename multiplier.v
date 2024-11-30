// module multiplier(rn,rm,mul_op,mul_cmd,y,aux);
// 	input wire[31:0] rn,rm;
// 	input wire mul_op;
// 	input wire [2:0] mul_cmd;
// 	output wire [31:0] y;
// 	output wire [31:0] aux;

//     assign y = (mul_op == 1) ? rn*rm : rn;
//     assign aux = 32'b0;
// endmodule



module multiplier(
    input wire [31:0] rn,     // Operando Rn
    input wire [31:0] rm,     // Operando Rm
    input wire [31:0] ra,     // Operando adicional para acumulación
    input wire [31:0] rd,
    input wire mul_op,        // Activación del módulo
    input wire [2:0] mul_cmd, // Comando de operación (3 bits)
    output reg [31:0] y,      // Resultado de 32 bits
    output reg [31:0] aux     // Auxiliar (32 bits para extensiones largas o acumulación)
);

    // Variables internas
    reg [63:0] result_long;  // Resultado extendido para operaciones largas
    
    always @(*) begin
        if (mul_op == 1) begin
            case (mul_cmd)
                3'b000: begin // MUL: Multiplicación (baja 32 bits)
                    y = rn * rm;
                    aux = 32'bx; // No usa auxiliar
                end
                3'b001: begin // MLA: Multiplicación y acumulación (baja 32 bits)
                    y = (rn * rm) + ra;
                    aux = 32'bx; // No usa auxiliar
                end
                3'b100: begin // UMULL: Multiplicación larga sin signo
                    result_long = rn * rm; // Calcula todo el resultado (64 bits)
                    y = result_long[31:0]; // Parte baja
                    aux = result_long[63:32]; // Parte alta
                end
                3'b101: begin // UMLAL: Multiplicación larga sin signo y acumulación
                    result_long = (rn * rm) + {rd, ra}; // Acumula con el registro actual
                    y = result_long[31:0]; // Parte baja
                    aux = result_long[63:32]; // Parte alta
                end
                3'b110: begin // SMULL: Multiplicación larga con signo
                    result_long = $signed(rn) * $signed(rm); // Multiplicación con signo
                    y = result_long[31:0]; // Parte baja
                    aux = result_long[63:32]; // Parte alta
                end
                3'b111: begin // SMLAL: Multiplicación larga con signo y acumulación
                    result_long = $signed(rn) * $signed(rm) + {rd, ra}; // Acumulación
                    y = result_long[31:0]; // Parte baja
                    aux = result_long[63:32]; // Parte alta
                end
                default: begin // Operación no válida
                    y = 32'b0;
                    aux = 32'b0;
                end
            endcase
        end else begin
            y = rn;        // Si `mul_op` no está activado, salida es simplemente `rn`
            aux = 32'b0;   // Auxiliar en 0
        end
    end

endmodule
