`timescale 1ns / 1ps

module const_table #(
    parameter TBS = 40                   // Width of the input data
) 
(
    //outputs
    output  logic  [9:0] o_Fsum,
                         f1,
                         f2,
    //inputs
    input   logic        enable,clk,rst_n
);
integer f1_values [1:8]={ 3, 7,19, 7, 7,11, 5,11};          //todo: change to table values 1: Specs
integer f2_values [1:8]={10,12,42,16,18,20,22,24};
integer index=(((TBS+24)-40)>>>3)+1;

always @(posedge clk, negedge rst_n)
    begin
        if (~rst_n)
        begin
            f1 <= 0;
            f2 <= 0;
        end
        else if (enable)
        begin
            f1 <= f1_values[index];
            f2 <= f2_values[index];
        end
    end
assign o_Fsum=f1+f2;
endmodule