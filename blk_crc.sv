`timescale 1ns / 1ps

module blk_crc #(
    parameter                  TBS = 16,
    parameter                  POLY_WIDTH = 24,
    parameter                  COUNTER_SIZE= 8,
    parameter [POLY_WIDTH-1:0] POLY = 24'b100001100100110011111011,
    parameter                  INITIAL_VALUE = 1'b0,
    parameter  WIDTH =(TBS<=24 )? (2*POLY_WIDTH+1):(2*TBS +1)   

) 
(
    //outputs
    output logic [(POLY_WIDTH+TBS)-1:0]        o_data_crc,
    output logic                               o_valid_crc,
    //inputs
    input  logic [TBS-1:0]                     i_data_crc,
    input  logic                               i_start_crc,
                                               i_clk_crc,
                                               i_rst_crc
);

localparam  SHFT_REG_SIZE = WIDTH-POLY_WIDTH;

//internal signals
logic [WIDTH-1:0]         t_i_data_crc;
reg   [COUNTER_SIZE-1:0]  Cntr;
reg   [1:0]               t_check;
reg   [SHFT_REG_SIZE-1:0] ShiftReg;
logic [POLY_WIDTH-1:0]    o_Rem_crc;

assign t_i_data_crc = i_data_crc;

always @(posedge i_clk_crc, negedge i_rst_crc ) 
begin
    if (~i_rst_crc) 
    begin
       // t_i_data_crc <=  i_data_crc;
        ShiftReg     <=  'b0;
        Cntr         <=  'b0;
        t_check      <= 1'b0;
        o_Rem_crc    <=  'b0;
    end
    else if (i_start_crc) 
    begin
        Cntr      = 0;
        ShiftReg  = t_i_data_crc [SHFT_REG_SIZE-1:0];
        o_Rem_crc = t_i_data_crc [WIDTH-1:SHFT_REG_SIZE];    
    end
    else if (Cntr!=WIDTH-1)
    begin
        Cntr     = Cntr+1;
        ShiftReg = {ShiftReg[SHFT_REG_SIZE-2:0],INITIAL_VALUE};
        if (o_Rem_crc[POLY_WIDTH-1]) 
        begin
            o_Rem_crc = {o_Rem_crc[POLY_WIDTH-2:0],ShiftReg[SHFT_REG_SIZE-1]}^POLY;    
        end
        else
        begin
            o_Rem_crc = {o_Rem_crc[POLY_WIDTH-2:0],ShiftReg[SHFT_REG_SIZE-1]};    
        end
    end
    else if (Cntr == WIDTH-1 && t_check <= 2) 
    begin
        t_check <= t_check+1;
    end    
end

always @(*) 
begin
    o_data_crc={i_data_crc,o_Rem_crc};
    if (i_start_crc) 
    begin
        o_valid_crc  <= 1'b0;    
    end
    else if (Cntr==WIDTH-1 && t_check <= 2)
    begin
        o_valid_crc <= 1'b1;
    end
    else
    begin
        o_valid_crc <= 1'b0;
    end    
end
    
endmodule