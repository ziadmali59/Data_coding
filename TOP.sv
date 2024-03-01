`timescale 1ns / 1ps

module TOP #(parameter TBS = 16 , parameter G = 132, parameter Qm = 2, parameter rv_indx = 0)
    (
        //outputs
        output logic                  e_k,
        output logic                  RM_Valid,
        //inputs
        input logic   /*[TBS-1:0]*/   i_data_crc,
        input logic                   /*i_start_crc,*/
                                      i_clk_crc,
                                      i_rst_crc
    );
    //internal signals
    logic [(TBS+24)-1:0]   t_data_crc;
    logic                  t_valid_crc;
    logic                  t_enable_turbo;
    logic [(TBS+24+4)-1:0] t_o_stream1_turbo,
                           t_o_stream2_turbo,
                           t_o_stream3_turbo;
   logic                   t_o_valid_turbo;
   logic                   t_dk0,
                           t_dk1,
                           t_dk2;
    logic                   t_enable_P2S;
    //internal instances
    blk_crc_lfsr #(.TBS(TBS))                    blk_crc_lfsr_inst(.o_data_crc(t_data_crc),
                                                                    .o_valid_crc(t_valid_crc),
                                                                    .i_data_crc(i_data_crc),
                                                                    .i_clk_crc(i_clk_crc),
                                                                    .i_rst_crc(i_rst_crc)
                                                                     );

    blk_controller                                blk_controller_inst(.o_enable(t_enable_turbo),
                                                                      .i_valid(t_valid_crc),
                                                                      .i_clk(i_clk_crc),
                                                                      .i_rst(i_rst_crc)
                                                                      );
                                                             
    blk_Turbo_encoder #(.TBS(TBS))                 blk_Turbo_encoder_inst(.o_stream1_turbo(t_o_stream1_turbo),
                                                                       .o_stream2_turbo(t_o_stream2_turbo),
                                                                       .o_stream3_turbo(t_o_stream3_turbo),
                                                                       .o_valid_turbo(t_o_valid_turbo),
                                                                        .o_enable_P2S(t_enable_P2S),
                                                                       .i_data_turbo(t_data_crc),
                                                                       .i_enable_turbo(t_enable_turbo),
                                                                       .i_start_turbo(t_valid_crc),
                                                                       .i_clk_turbo(i_clk_crc),
                                                                       .i_rst_turbo(i_rst_crc)
                                                                       );
    blk_P2S         #(TBS)                         blk_P2S_inst(.d_k0(t_dk0),
                                                                .d_k1(t_dk1),
                                                                .d_k2(t_dk2),
                                                                .i_stream1_turbo(t_o_stream1_turbo),
                                                                .i_stream2_turbo(t_o_stream2_turbo),
                                                                .i_stream3_turbo(t_o_stream3_turbo),
                                                                .i_valid(t_enable_P2S),
                                                                .i_clk_turbo(i_clk_crc),
                                                                .i_rst_turbo(i_rst_crc)
                                                                );    
                                                                                                                             
    RateMatcher                                         RateMatcher_inst(.clk_RM(i_clk_crc),
                                                                         .rst_RM(i_rst_crc),
                                                                         .en_RM(t_o_valid_turbo),
                                                                         .TBS(TBS),
                                                                         .G(G),
                                                                         .Qm(Qm),
                                                                         .rv_indx(rv_indx),
                                                                         .d_k0(t_dk0),
                                                                         .d_k1(t_dk1),
                                                                         .d_k2(t_dk2),
                                                                         .e_k(e_k),
                                                                         .RM_Valid(RM_Valid)
                                                                        );
endmodule
