`timescale 1ns / 1ps

module blk_controller
    (
        //outputs
        output logic o_enable,
        //inputs
        input  logic i_valid,
                     i_clk,
                     i_rst
    );

    typedef enum logic { IDLE, TURBO_EN} state;

    state next_state, current_state;
    always_ff @(posedge i_clk or negedge i_rst)
    begin
        if(~i_rst)
        begin
            current_state <= IDLE;
        end
        else
        begin
            current_state <= next_state;
        end
    end

    always_comb
    begin
        case(current_state)
            IDLE: 
            begin
                next_state  <= i_valid ? TURBO_EN : IDLE;
            end
            TURBO_EN: 
            begin
                next_state  <= TURBO_EN;
            end
            default: 
            begin
                next_state  <= current_state;
            end
        endcase
    end
    
    assign o_enable = (current_state == TURBO_EN) ? 1'b1 : 1'b0;
endmodule
