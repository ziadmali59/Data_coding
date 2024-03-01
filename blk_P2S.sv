`timescale 1ns / 1ps


module blk_P2S #(parameter TBS = 16)
    (
        //outputs
        output logic d_k0,
                     d_k1,
                     d_k2,
        //inputs
        input logic [(TBS+24+4)-1:0] i_stream1_turbo,
                                     i_stream2_turbo,
                                     i_stream3_turbo,
        input logic                  i_valid,
                                     i_clk_turbo,
                                     i_rst_turbo
    );
    //internal signals
    logic [$clog2(TBS+24+4)-1:0] count;

    always_ff @(posedge i_clk_turbo, negedge i_rst_turbo)
    begin
        if (~i_rst_turbo) 
        begin
            d_k0   <= 0;
            d_k1   <= 0;
            d_k2   <= 0;
            count  <= 0;
        end
        else if (i_valid)
        begin
            d_k0  <= i_stream1_turbo[count];
            d_k1  <= i_stream2_turbo[count];
            d_k2  <= i_stream3_turbo[count];
            if(count != TBS+24+4-1)
            begin
                count <= count+1;
            end
        end
    end












endmodule
