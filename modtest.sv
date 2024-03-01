`timescale 1ns / 1ps

module modtest
    (
        //outputs
        output logic  [37:0]    out1,
                                out2,
        //inputs
        input  logic  [37:0]    x,
                                z
    );

    logic        t_sel;
    logic [37:0] mux_out;

    always @(*) 
    begin
        if (x>=z) 
        begin
            t_sel = 0;    
        end
        else
        begin
            t_sel = 1;
        end    
    end
    blk_mux2x1 #(38) blk_mux2x1_inst (.out(mux_out),
                                      .input1(z) ,
                                      .input2(38'b0),
                                      .select(t_sel));
    assign out1 = x-mux_out;
    
    assign out2 = z>>1;
endmodule
