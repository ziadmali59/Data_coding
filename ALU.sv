module ALU #(
          parameter CB = 1  , // Number of Coded blocks (equal to 1 in NB-IoT)
          parameter  NL = 1  , // Number of layer of transport block (equal to 1 in NB-IoT)
          parameter  C  = 32  // Number of columns  
)
(
        input logic [11:0]   TBS,   // Transport Block Size
        input logic [11:0]    G,   // Total number of bits available for transmission
        input logic [1:0]     Qm,   // Modulation Order (2 for QPSK || 4 for 16-QAM)
        input logic [1:0]    rv_idx,   // Redundancy Version Index (0 || 2)

        output logic [11:0]  E  ,    // Output Sequence of Rate Matching
        output logic [11:0]  Ko ,
        output logic [11:0] k_pi,
        output logic [11:0] D,
        output logic [4:0 ]  dummy_position,  //number of dummy bits to be filled into RAMs
        output logic [6:0 ]  no_ofRows       // number of rows of RAMs   
);

logic [11:0] g;
logic [11:0] D_temp;
logic [6:0] temp_rows;

assign D_temp         = TBS + 24 + 4;
assign temp_rows      = (D_temp >> 5)+1;
assign no_ofRows      = temp_rows;
assign dummy_position = (temp_rows << 5) - D_temp;
assign k_pi           = temp_rows << 5;
assign D              = D_temp; 


always_comb begin
        if(Qm == 2) begin
                g = G >> 1;
                E = g << 1;
        end
        else begin
                g = G >> 2;
                E = g << 2;
        end
        if (rv_idx==0) begin
                Ko = temp_rows << 0;
        end
        else begin 
                Ko = temp_rows << 6; 
        end
end

//assign Ko             = temp_rows * (24*rv_idx+2); 
//assign Ko             = temp_rows * (2* (((3*temp_rows*C)/(8*temp_rows))+1) * rv_idx + 2);
/*assign g              = (G/(NL*Qm)) ;
assign E              = NL * Qm * (g/CB);*/
endmodule