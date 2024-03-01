`timescale 1ns / 1ps

module blk_counter #(parameter TBS=16)
    (
        //outputs 
        output logic    start,
                        ff_enable,
                        trellis_enable,
                        enable_rsc,
                        enable_tre_sel,
                        enable_valid,
        //inputs
        input  logic    enable,
                        init,
                        clk,
                        rst_n
    );
    //internal signals
    reg   [14:0] reg_count;
    logic       t_reset;
   
    always_ff @(posedge clk, negedge rst_n)
    begin
        if (~rst_n) 
        begin
            enable_valid   <= 0;
            enable_tre_sel <= 0;
            enable_rsc     <= 0;
            reg_count      <= 0;
            t_reset        <= 0;
            trellis_enable <= 0;
            ff_enable      <= 1;
        end
        else if (enable)
        begin    
        reg_count <= reg_count+1;
        if(reg_count ==(TBS+24)*19)
        begin
            enable_valid <= 1;
        end
        if(reg_count ==(TBS+24)*19+2)
        begin
            enable_tre_sel <= 1;
        end
        if (reg_count<=(TBS+24)*19 && ~init)
        begin
            if(reg_count==(TBS+24)*19)
            begin
                enable_rsc <= 1;
                ff_enable <= 0;
            end
            if(reg_count< 21)
            begin
                t_reset   <= 0;
            end
            else
            begin
                t_reset <= 1;
            end
        end
        else if (reg_count>((TBS+24)*19)+(TBS+24)+1)
        begin
            trellis_enable <= 1;
            t_reset        <= 0;
        end
        end
    end
   assign start = t_reset||init;
endmodule
