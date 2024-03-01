module CirBuffTest
 (
                input logic clk,en,
                input logic [1:0] RAM_Out,
                input logic [12:0] addrBuff,
                input logic weBuff,


                output logic [1:0] e_k

);

logic [1:0] Cir_Buff [0:7775];  // where 3*K_Pi = Ncb

always_ff @(posedge clk) begin
        if (en) begin
            if (weBuff) begin
                Cir_Buff[addrBuff] <= RAM_Out; 
            end
            else begin
                    e_k <= Cir_Buff[addrBuff];
            end
            end
end

endmodule
    