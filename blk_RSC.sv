`timescale 1ns / 1ps

module blk_RSC
    (
        //outputs
        output logic out1,
                     out2,
                     out3,
        //inputs
        input logic  data_in,
        input logic  enable,
                     switch,
                     clk,
                     rst_n
    );
logic t_in;
logic t_d1,t_d2,t_d3,t_d0;
logic t_state_rst;
logic x;
assign x = (switch)? data_in : t_in;
assign t_d0=x^t_d3^t_d2;

blk_dff ddf0(.q(t_in),.d(data_in),.enable(enable),.clk(clk),.rst_n(rst_n));
blk_dff dff1(.q(t_d1),.d(t_d0),.enable(enable),.clk(clk),.rst_n(rst_n));
blk_dff dff2(.q(t_d2),.d(t_d1),.enable(enable),.clk(clk),.rst_n(rst_n));
blk_dff dff3(.q(t_d3),.d(t_d2),.enable(enable),.clk(clk),.rst_n(rst_n));

assign out1=x;
assign out2=t_d3^t_d1^t_d0;    
assign out3=t_d3^t_d2;   
endmodule
