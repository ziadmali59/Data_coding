`timescale 1ns / 1ps

module blk_mux4x1(
    //outputs
    output logic        out,
    input  logic        a,
                        b,
                        c,
                        d,
    //inputs
    input  logic [1:0]  sel
    );
    always_comb 
    begin
        case(sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 1'bx;
        endcase
    end
endmodule
