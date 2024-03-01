`timescale 1ns / 1ps

module blk_trellis_term #(parameter TBS=16)
    (
        output logic  [(TBS+24+4)-1:0]              o_stream1_trellis,
                                                    o_stream2_trellis,
                                                    o_stream3_trellis,
        output logic                                o_valid_trellis,
                                                    o_enable_P2S,
        input  logic  [$clog2(TBS+24+4)-1:0] index,
        input  logic  [1:0]                         bit_selector,
        input  logic                                enable,
                                                    enable_valid,
                                                    i_trans_enable,
                                                    i_RSC1_out1,
                                                    i_RSC1_out2,
                                                    i_RSC2_out1,
                                                    i_RSC2_out2,

        input  logic                                i_start_terllis,
                                                    i_clk_terllis,
                                                    i_rst_n_terllis   
    );
    

    logic [3:0] t_x1,t_x2,t_x3,t_x4;
    logic temp1,temp2,temp3;
    always_ff @(posedge i_clk_terllis or negedge i_rst_n_terllis)
    begin
        if (~i_rst_n_terllis) 
        begin
            o_stream1_trellis <= 0;
            o_stream2_trellis <= 0;
            o_stream3_trellis <= 0;
            o_valid_trellis   <= 0;
            o_enable_P2S      <= 0;
            t_x1              <= 0;
            t_x2              <= 0;
            t_x3              <= 0;
            t_x4              <= 0;
        end
        else if (enable)
        begin
            if (~i_start_terllis) 
        begin
            if (index >= 4) 
                   begin
                        o_valid_trellis <= 1'b1; 
                   end
                   if (index == 5) 
                   begin
                        o_enable_P2S <= 1'b1; 
                   end
            o_stream1_trellis [index] <= i_RSC1_out1;
            o_stream2_trellis [index] <= i_RSC1_out2;
            o_stream3_trellis [index] <= i_RSC2_out2;
        end
        
       /* if (index == TBS+24)
        begin
            o_valid_trellis <= 1'b0;
        end*/
        else if (~i_trans_enable && index >= TBS+24) 
        begin
          /* if (index >= TBS+24+4-2) 
           begin
                o_valid_trellis <= 1'b1; 
           end
           if (index == TBS+24+4-1) 
           begin
                o_enable_P2S <= 1'b1; 
           end*/
            o_stream1_trellis [index] <= temp1;
            o_stream2_trellis [index] <= temp2;
            o_stream3_trellis [index] <= temp3;    
        end 
        else if (i_trans_enable)
        begin
        /*if (bit_selector == 3) 
        begin
            //o_valid_trellis <= 1'b1; 
        end
        else
        begin
            //o_valid_trellis <= 1'b0;
        end*/
            t_x1[bit_selector] <= i_RSC1_out1;
            t_x2[bit_selector] <= i_RSC1_out2;
            t_x3[bit_selector] <= i_RSC2_out2;
            t_x4[bit_selector] <= i_RSC2_out1;
        end
        
        end
          
    end
//assign o_valid_trellis = (index == (TBS+24+4)-2) ? 1'b1 : 1'b0;

    blk_mux4x1 blk_mux4x1_inst (.out(temp1),
                                .a(t_x1[0]),
                                .b(t_x2[1]),
                                .c(t_x4[0]),
                                .d(t_x3[1]),
                                .sel(bit_selector)
                                );
                                
    blk_mux4x1 blk_mux4x1_inst1 (.out(temp2),
                                .a(t_x2[0]),
                                .b(t_x1[2]),
                                .c(t_x3[0]),
                                .d(t_x4[2]),
                                .sel(bit_selector)
                                );

    blk_mux4x1 blk_mux4x1_inst2 (.out(temp3),
                                .a(t_x1[1]),
                                .b(t_x2[2]),
                                .c(t_x4[1]),
                                .d(t_x3[2]),
                                .sel(bit_selector)
                                );
                               
endmodule
