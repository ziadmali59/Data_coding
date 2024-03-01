`timescale 1ns / 1ps

module blk_dff_wait #(parameter WIDTH = 1)
    (
        output logic [WIDTH-1:0] q,
        input logic  [WIDTH-1:0] d,
        input logic             enable,
                                clk,
                                rst_n
    );

    logic [4:0] counter;

    always_ff @(posedge clk, negedge rst_n)
    begin
        if (~rst_n)
        begin
            q <= 0;
            counter <= 0;
        end
        else if (enable)
        begin
            if (counter == 18)
            begin
                q <= d;
                counter <=0;
            end
            else
            begin
                q <= q;
           counter <= counter + 1;
            end
            
        end
    end
endmodule
