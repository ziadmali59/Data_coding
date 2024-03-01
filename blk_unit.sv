`timescale 1ns / 1ps

module blk_unit
    (
        //outputs
        output logic [/*24*/16:0] x,
        //inputs
        input  logic [9:0]  i_Fsum,
                            f2,
        input  logic        ff_enable,
                            start,
                            clk,
                            rst_n
    );
    //internal signals
    logic [16:0] R1_o,R2_o;
    logic [16:0] R1_i,R2_i;
    logic [11:0] t_o1;
    logic [16:0] t_o2;
    logic [16:0] t_o3;
    logic [16:0] t_add1;

    logic [4:0] count;
    logic [11:0] t_f2;
    assign t_f2 = f2<<1;
    //internal instances
    blk_dff_wait     #(17) dff1(.q(R1_o),.d(R1_i),.enable(ff_enable),.clk(clk),.rst_n(rst_n));
    blk_dff_wait     #(17) dff2(.q(R2_o),.d(R2_i),.enable(ff_enable),.clk(clk),.rst_n(rst_n));

    blk_mux2x1  #(12) mux1(.out(t_o1),.input1(12'b0),.input2(t_f2),.select(start));
    blk_mux2x1  #(17) mux2(.out(t_o2),.input1(12'b0),.input2(R2_o),.select(start));

    assign t_add1={/*13*/5'b0,t_o1}+t_o2;

    blk_mux2x1 #(17) mux3(.out(R2_i),.input1({7'b0,i_Fsum}),.input2(t_add1),.select(start));

    blk_mux2x1 #(17) mux4(.out(t_o3),.input1({7'b0,i_Fsum}),.input2(R1_o),.select(start));
    
    assign R1_i = t_o3+t_add1;
    /*always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
           x <= 25'b0;
           count <= 5'b0;
        end
        else if (start)
        begin
            if (count <= 24) 
            begin
                x <= x;  
                count <= count+1;  
            end
            else if (count==25) 
            begin
                t_add1={13'b0,t_o1}+t_o2;
                R1_i = t_o3+t_add1;
                x = R1_o;
                count = 5'b0;    
            end
        end
    end*/
    assign x    = R1_o;

endmodule
