`timescale 1ns / 1ps

module Raw_Addr_Gen #(parameter TBS = 16)
    (
        //outputs
        output logic        start_trellis,
        output logic [/*24*/16:0] x,
        output logic        trellis_enable,
        output logic        enable_rsc,
        output logic        enable_tre_sel,
        output logic        enable_valid,
        //inputs
        input  logic        enable,
                            init,
                            clk,
                            rst_n
    );
    //internal signals
    logic [9:0] t_o_Fsum,
                t_f1,
                t_f2;
    logic       t_start;
    logic       t_enable;
    //internal instances
    const_table #(TBS)  const_table_inst(.o_Fsum(t_o_Fsum),
                                                .f1(t_f1),
                                                .f2(t_f2),
                                                .enable(enable),
                                                .clk(clk),
                                                .rst_n(rst_n)
                                                );

    blk_counter  #(TBS)                  counter_inst(.start(t_start),
                                                .ff_enable(t_enable),
                                                .trellis_enable(trellis_enable),
                                                .enable_rsc(enable_rsc),
                                                .enable_tre_sel(enable_tre_sel),
                                                .enable_valid(enable_valid),
                                                .enable(enable),
                                                .init(init),
                                                .clk(clk),
                                                .rst_n(rst_n)
                                                );
                                               
    blk_unit                          unit_inst(.x(x),
                                                .i_Fsum(t_o_Fsum),
                                                .f2(t_f2),
                                                .ff_enable(t_enable),
                                                .start(t_start),
                                                .clk(clk),
                                                .rst_n(rst_n)
                                                );

assign start_trellis = t_start;
endmodule
