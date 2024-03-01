module RAMM (
                input logic  clk, 
                input logic  weDum,
                input logic  weData, 
                input logic en,
                input logic [11:0] addr, 
                input logic  di,
                output logic [1:0] dout
);

logic  [1:0] RAM [0:2591];


always_ff @(posedge clk) begin
        if (en) begin
            if (weDum) begin
                RAM[addr] <= 2'b11;
            end
            else if (weData) begin
                RAM[addr] <= {1'b0,di};
            end
            else
                dout <= RAM[addr];
         end
end

endmodule