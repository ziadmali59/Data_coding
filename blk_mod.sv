`timescale 1ns / 1ps


module blk_mod #(parameter TBS = 16)
    (
      //outputs
      output logic  [12:0]  y,
      //inputs 
      input  logic  [24:0]  x
    );
    //internal signals
    
    logic [37:0] t_x;
    logic [12:0] z;
    logic [37:0] t_z;

    logic [37:0] temp1 [0:25];
    logic [37:0] temp2 [0:25];

   
assign t_x      = {13'b0,x};
assign z        = TBS+'d24;
assign t_z      = {z,25'b0};
assign temp1[0] = t_x;
assign temp2[0] = t_z;

generate
    genvar i;
    for (i =0 ;i<25 ;i=i+1 ) 
    begin : blk_submod_inst
        blk_modunit inst(.out1(temp1[i+1]),
                        .out2(temp2[i+1]),
                        .x(temp1[i]),
                        .z(temp2[i])
                        );
    end
endgenerate

always @(*)
begin
    if (temp1[25] >= temp2[25])
    begin
        y = temp1[25]-temp2[25];
    end
    else
    begin
        y = temp1[25];
    end
end 
endmodule
