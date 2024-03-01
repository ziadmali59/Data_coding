`timescale 1ns / 1ps

module blk_dff #(parameter WIDTH = 1)
    (
        output logic [WIDTH-1:0] q,
        input logic  [WIDTH-1:0] d,
        input logic             enable,
                                clk,
                                rst_n
    );

    always_ff @(posedge clk, negedge rst_n)
    begin
        if (~rst_n)
        begin
            q<=0;
        end
        else if(enable)
        begin
            q<=d;
        end
    end
endmodule
