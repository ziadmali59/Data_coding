`timescale 1ns / 1ps


module blk_trellis_selector #(parameter TBS=16)
    (
        //outputs
        output logic [$clog2(TBS+24+4)-1:0]  index,
        output logic [1:0]                          bit_selector,
        output logic                                o_trans_enable,
        //inputs
        input  logic                                enable,
                                                    i_start_terllis,
                                                    i_enable_count,
                                                    i_clk_terllis,
                                                    i_rst_n_terllis
    );
    logic [2:0]  trans_count;
    //logic        flag;
    always_ff @(posedge i_clk_terllis or negedge i_rst_n_terllis)
    begin
        if (~i_rst_n_terllis) 
        begin
           // flag           <= 0;
            index          <= 0;
            bit_selector   <= 0;
            trans_count    <= 0;
            o_trans_enable <= 1;
        end
        else if (enable)
        begin
            if (~i_start_terllis) 
        begin
            if(~i_enable_count)
            begin
                index<=0;
            end
            else if(index < TBS+24+-1)
            begin
                index <= index+1;
            end
        end
        else if (i_start_terllis )
        begin
            
            if (trans_count>'b11) 
            begin
                if (index < TBS+24+4-1)
                begin
                    index        <= index+1;
                    bit_selector <= bit_selector+1;
                                  
                end
            end
            else if (trans_count <='b11) 
            begin
                if (trans_count==2'b11) 
                begin
                    o_trans_enable <= 0;
                end
                if (bit_selector<2'b11) 
                begin
                    bit_selector <= bit_selector+1;
                end
            end
            if (trans_count < 3'b111) 
            begin
                trans_count <= trans_count+1;
            end
        end
        end
    end 
    
    //assign feedback = (index>=TBS+24-1)? 1'b1:1'b0;
endmodule
///////////////////////////////////////////////////////////////////////////////


/*
    localparam         IDLE =0,
                 INDEX_GEN = 1,
               TRELLIS_GEN = 2;

    reg [1:0] current_state,next_state;

    reg [1:0] state_count;

    always_ff @(posedge i_clk_terllis , negedge i_rst_n_terllis)
    begin
        if (~i_rst_n_terllis) 
        begin
            current_state <= IDLE;
        end
        else
        begin
            current_state <= next_state;
        end
    end

    always_comb 
    begin
        case(current_state)
            IDLE:
            begin
                if(~i_start_terllis && i_enable_count)
                begin
                    next_state = INDEX_GEN;
                end
                else
                begin
                    next_state = IDLE;
                end
            end
            INDEX_GEN:
            begin
                if (i_start_terllis && ~i_enable_count) 
                begin
                    next_state = TRELLIS_GEN;    
                end
                else
                begin
                    next_state = INDEX_GEN;
                end
            end
            TRELLIS_GEN:
            begin
                if (state_count==2'b11) 
                begin
                    next_state = INDEX_GEN;    
                end
                else
                begin
                    next_state = TRELLIS_GEN;
                end    
            end
            default: next_state = current_state;
        endcase          
    end

    always_comb 
    begin
        case(current_state)
            IDLE:
            begin
                index <= 0;
                bit_selector <= 0;
                state_count <= 0;
            end
            INDEX_GEN:
            begin
                index <= index+1;
            end
            TRELLIS_GEN:
            begin
                bit_selector <= bit_selector+1;
                state_count <= state_count+1;
            end
            default: 
            begin
                index <=index;
                bit_selector <= bit_selector;
                state_count <= state_count;
            end
        endcase
    end
    */