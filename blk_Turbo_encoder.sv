`timescale 1ns / 1ps

module blk_Turbo_encoder #(
    parameter TBS = 16                     // Width of the input data
) 
( 
    //outputs
    output logic [(TBS+24+4)-1:0]         o_stream1_turbo,
                                          o_stream2_turbo,
                                          o_stream3_turbo,
    output logic                          o_valid_turbo,
                                          o_enable_P2S,
    //inputs
    input  logic  [(TBS+24)-1:0]          i_data_turbo,
    input  logic                          i_enable_turbo,
    input  logic                          i_start_turbo,
                                          i_clk_turbo,
                                          i_rst_turbo
);
//internal signals
logic [12:0]                        t_index_turbo;
logic                               t_o_buff1,t_o_buff2;
logic                               t_start_trellis;
logic                               t_RSC1_out1,t_RSC1_out2,t_RSC2_out1,t_RSC2_out2;
logic                               t_count_trellis;
logic [$clog2(TBS+24+4)-1:0] t_index;
logic [1:0]                         t_bit_selector;
logic                               t_fb1,t_fb2;
logic                               t_outmux1,t_outmux2;
logic                               t_trans_enable;
logic                               t_read_index;
logic                               t_enable_rsc;
logic                               t_enable_tre_sel;
logic                               t_enable_valid;
logic                               t_enable_P2S;
//internal instances
blk_interleaver     #(TBS)           blk_interleaver_inst(.y(t_index_turbo),
                                                                .read_y(t_read_index), 
                                                                .start_trellis(t_count_trellis),
                                                                .trellis_enable(t_start_trellis),
                                                                .enable_rsc(t_enable_rsc),
                                                                .enable_tre_sel(t_enable_tre_sel),
                                                                .enable_valid(t_enable_valid),
                                                                .enable(i_enable_turbo),
                                                                .init(i_start_turbo),
                                                                .clk(i_clk_turbo),
                                                                .rst_n(i_rst_turbo)
                                                                );
    
blk_buff            #(TBS)                 blk_buff_inst(.o_buff1(t_o_buff1),
                                                                .o_buff2(t_o_buff2),
                                                                .i_buff(i_data_turbo),
                                                                .read_index(t_read_index),
                                                                .index(t_index_turbo),
                                                                .start(t_enable_rsc),
                                                                .enable(i_enable_turbo),
                                                                .clk(i_clk_turbo),
                                                                .rst_n(i_rst_turbo)
                                                                );
    
blk_mux2x1          #(1)                        blk_mux2x1_inst(.out(t_outmux1),
                                                                .input1(t_o_buff1),
                                                                .input2(t_fb1),
                                                                .select(t_start_trellis)
                                                                );


blk_RSC                                            blk_RSC_inst(.out1(t_RSC1_out1),
                                                                .out2(t_RSC1_out2),
                                                                .out3(t_fb1),
                                                                .data_in(t_outmux1),
                                                                .enable(t_enable_rsc),
                                                                .switch(t_start_trellis),
                                                                .clk(i_clk_turbo),
                                                                .rst_n(i_rst_turbo)
                                                                );

blk_mux2x1           #(1)                       blk_mux2x1_inst1(.out(t_outmux2),
                                                                 .input1(t_o_buff2),
                                                                 .input2(t_fb2),
                                                                 .select(t_start_trellis)
                                                                 );
     
blk_RSC                                            blk_RSC_inst1(.out1(t_RSC2_out1),
                                                                 .out2(t_RSC2_out2),
                                                                 .out3(t_fb2),
                                                                 .data_in(t_outmux2),
                                                                 .enable(t_enable_rsc),
                                                                 .switch(t_start_trellis),
                                                                 .clk(i_clk_turbo),
                                                                 .rst_n(i_rst_turbo)
                                                                 );

blk_trellis_selector #(TBS)     blk_trellis_selector_inst(.index(t_index),
                                                                 .bit_selector(t_bit_selector),
                                                                 .o_trans_enable(t_trans_enable),
                                                                 .enable(i_enable_turbo),
                                                                 .i_enable_count(t_enable_tre_sel),
                                                                 .i_start_terllis(t_start_trellis),
                                                                 .i_clk_terllis(i_clk_turbo),
                                                                 .i_rst_n_terllis(i_rst_turbo)
                                                                 );

blk_trellis_term     #(TBS)          blk_trellis_term_inst(.o_stream1_trellis(o_stream1_turbo),
                                                                  .o_stream2_trellis(o_stream2_turbo),
                                                                  .o_stream3_trellis(o_stream3_turbo),
                                                                  .o_valid_trellis(o_valid_turbo),
                                                                  .o_enable_P2S(t_enable_P2S),
                                                                  .index(t_index),
                                                                  .bit_selector(t_bit_selector),
                                                                  .enable(i_enable_turbo),
                                                                  .enable_valid(t_enable_valid),
                                                                  .i_trans_enable(t_trans_enable),
                                                                  .i_RSC1_out1(t_RSC1_out1),
                                                                  .i_RSC1_out2(t_RSC1_out2),
                                                                  .i_RSC2_out1(t_fb2),
                                                                  .i_RSC2_out2(t_RSC2_out2),
                                                                  .i_start_terllis(t_start_trellis),
                                                                  .i_clk_terllis(i_clk_turbo),
                                                                  .i_rst_n_terllis(i_rst_turbo)
                                                                  );

assign  o_enable_P2S = t_enable_P2S;
endmodule
