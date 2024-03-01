`timescale 1ns / 1ps

module blk_mux2x1 #(parameter WIDTH = 4)
(
    //outputs
    output logic [WIDTH-1:0]   out,
    //inputs
    input  logic [WIDTH-1:0]   input1,
                               input2,
    input  logic               select
);
    always_comb 
    begin
        if (select)
            out <= input2;
        else
            out <= input1;
    end
endmodule

