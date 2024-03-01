`timescale 1ns / 1ps

module blk_crc_lfsr #(parameter TBS = 40)
    (
        output  logic  [TBS+24-1:0] o_data_crc,
        output logic                o_valid_crc,
        input  logic                i_data_crc,
       // input  logic                i_start_crc,
        input  logic                i_clk_crc,
        input  logic                i_rst_crc

    );
    logic [23:0] t;
    logic t_data_out;
    logic t_i_data_crc;
    logic [$clog2(TBS+25)-1:0] count;
    logic t_q0, t_q1, t_q2, t_q3,
          t_q4, t_q5, t_q6, t_q7, 
          t_q8, t_q9, t_q10, t_q11,
          t_q12, t_q13, t_q14, t_q15,
          t_q16, t_q17, t_q18, t_q19,
          t_q20, t_q21, t_q22, t_q23,t_q24;
    //assign x=t_q23^i_data_crc;  //1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1

    blk_dff dff23(.q(t_q23),.d(t_q22^t_q23),.clk(i_clk_crc), .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff22(.q(t_q22),.d(t_q21),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff21(.q(t_q21),.d(t_q20),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff20(.q(t_q20),.d(t_q19),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff19(.q(t_q19),.d(t_q18),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff18(.q(t_q18),.d(t_q17^t_q23),.clk(i_clk_crc), .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff17(.q(t_q17),.d(t_q16^t_q23),.clk(i_clk_crc), .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff16(.q(t_q16),.d(t_q15),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff15(.q(t_q15),.d(t_q14),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff14(.q(t_q14),.d(t_q13^t_q23),.clk(i_clk_crc), .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff13(.q(t_q13),.d(t_q12),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff12(.q(t_q12),.d(t_q11),.clk(i_clk_crc),       .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff11(.q(t_q11),.d(t_q10^t_q23),.clk(i_clk_crc), .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff10(.q(t_q10),.d(t_q9^t_q23),.clk(i_clk_crc),  .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff9(.q(t_q9),.d(t_q8),.clk(i_clk_crc),          .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff8(.q(t_q8),.d(t_q7),.clk(i_clk_crc),          .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff7(.q(t_q7),.d(t_q6^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff6(.q(t_q6),.d(t_q5^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff5(.q(t_q5),.d(t_q4^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff4(.q(t_q4),.d(t_q3^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff3(.q(t_q3),.d(t_q2^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff2(.q(t_q2),.d(t_q1),.clk(i_clk_crc),          .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff1(.q(t_q1),.d(t_q0^t_q23),.clk(i_clk_crc),    .rst_n(i_rst_crc),.enable(1'b1));
    blk_dff dff0(.q(t_q0),.d(i_data_crc^t_q23),.clk(i_clk_crc),.rst_n(i_rst_crc),.enable(1'b1));

assign t = {t_q23,t_q22,t_q21,t_q20,t_q19,t_q18,t_q17,t_q16,t_q15,t_q14,t_q13,t_q12,t_q11,t_q10,t_q9,t_q8,t_q7,t_q6,t_q5,t_q4,t_q3,t_q2,t_q1,t_q0};
  
  always_ff @(posedge i_clk_crc, negedge i_rst_crc )
    begin
        if (~i_rst_crc)
        begin
            count <= 0;
            o_data_crc <= 0;
            o_valid_crc <= 0;
        end
        else
        begin
            if (count<=TBS-1) 
            begin
               o_data_crc[TBS+24-1-count] <= i_data_crc;
                o_valid_crc <= 0;
            end 
            else if (count == TBS+24) 
            begin
                o_data_crc[23:0] <= t;
                o_valid_crc <= 1;
            end
            else if (count == TBS+25)
            begin
                o_valid_crc <= 1;
            end
            else
            begin
                o_valid_crc <= 0;
            end
            if(count <= TBS+26)
            begin
                count <= count + 1;
            end
        end
    end











endmodule
