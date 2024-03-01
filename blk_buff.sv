`timescale 1ns / 1ps

module blk_buff #(TBS = 24)
    (
        //outputs
        output logic                      o_buff1,
                                          o_buff2,
        //inputs
        input logic [(TBS+24)-1:0]        i_buff,
        input logic [12:0]                index,
        input logic                       read_index,
        input logic                       start,
                                          enable,
                                          clk,
                                          rst_n
    );
    logic [(TBS+24)-1:0]       data2;
                               //data1;
    //logic [TBS+23:0]           mem;
    logic [$clog2(TBS+24)-1:0] reg_count;
   // logic [$clog2(TBS+24)-1:0] write_count;

    //assign mem=i_buff;

    always_ff @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            o_buff1       <= 0;
            o_buff2       <= 0;
            reg_count     <= 0;
           // write_count   <= 0;
        end
        else if (enable) 
        begin
        if (~start && reg_count<=(TBS+24) & read_index ) 
        begin
            //data1[reg_count] <= mem[reg_count];
            data2[reg_count] <= i_buff[index];
            if (reg_count < (TBS+24-1))
            begin
                reg_count <= reg_count+1;
            end
            else
            begin
                reg_count <= 0;
            end
        end 
        else if (start)
        begin
            o_buff1     <= i_buff[reg_count];
            o_buff2     <= data2[reg_count];
            if (reg_count < (TBS+24-1))
            begin
                reg_count <= reg_count+1;
            end
        end
    end
    end
endmodule
