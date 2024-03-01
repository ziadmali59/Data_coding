`timescale 1ns / 1ps


module blk_interleaver #(parameter  TBS=16)
    (   
        output logic [12:0] y,
        output logic        read_y,
        output logic        start_trellis,
        output logic        trellis_enable,
//        output logic        t_valid,
        output logic        enable_rsc,
        output logic        enable_tre_sel,
        output logic        enable_valid,
        input logic         enable,
                            init,
                            clk,
                            rst_n
    );
    logic [16/*24*/:0] t_x;
    logic        t_start,
                 t_valid_div;
    Raw_Addr_Gen    #(TBS)         Raw_Addr_Gen_inst (.start_trellis(start_trellis),
                                                      .x(t_x),
                                                      .trellis_enable(trellis_enable),
                                                      .enable_rsc(enable_rsc),
                                                      .enable_tre_sel(enable_tre_sel),
                                                      .enable_valid(enable_valid),
                                                      .enable(enable),
                                                      .init(init),
                                                      .clk(clk),
                                                      .rst_n(rst_n));
    
    blk_div_cu                      blk_div_cu_inst (.start(t_start),
                                                    .valid(t_valid_div),
                                                    .clk(clk),
                                                    .rst_n(rst_n));

    blk_restoring_division #(TBS)       blk_restoring_division_inst (.clk(clk),
                                                                    .rst(rst_n),
                                                                    .start(t_start),
                                                                    .X(t_x),
                                                                    .modout(y),
                                                                    .valid(t_valid_div));
                                                                    
    assign read_y = t_valid_div;
endmodule
