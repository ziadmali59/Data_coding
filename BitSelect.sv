module BitSelect (
                input logic clk,rst,en,
                input logic [1:0] e_k,
                output logic ek
                //output logic [1:0] ek_dummy 
);
        
always_ff @( posedge clk) begin 
    if (!rst) begin
            ek <= 0;
    end
    else if (!en) begin
        if (e_k !== 2'b11)  begin 
            ek <= e_k[0];
         end
    end
end
endmodule