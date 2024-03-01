`timescale 1ns / 1ps


module blk_div_cu
    (
        output logic start,
        input  logic valid,
                        clk,  
                        rst_n
    );
    logic [5:0] count;
    typedef enum logic [1:0] {IDLE,SET,WAIT,START } state;
    state current_state, next_state;
    logic flag;
    //assign flag =0;
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
          //  flag          <= 0;
            count         <= 0;
            current_state <= IDLE;
        end
        else
        begin
            if(count<=/*26*/18)
            begin
                count <= count+1;
            end            
            current_state <= next_state;
        end
    end

    always_comb
    begin
        case(current_state)
            IDLE:
            begin
                next_state = SET;
            end
            SET:
            begin
                if (count == 19)
                next_state = WAIT;
                else 
                next_state = SET;
            end
            WAIT:
            begin
                if(valid)
                begin
                next_state = START;
                end
                else
                begin
                next_state = WAIT;
                end
            end
            START:
            begin
                next_state = IDLE;
            end
            default:
            begin
                next_state = IDLE;
            end
        endcase
    end

    always_comb
    begin
               // flag = 0;
        case(current_state)
            IDLE:
            begin
                start = 0;
            end
            SET:
            begin
                flag = 0;
                if(count==19 && ~flag)
                begin
                    start=1;
                    flag=1;
                end
                else
                begin
                    start=0;
                end
            end
            WAIT:
            begin
                start = 0;
            end
            START:
            begin
                start = 1;
            end
            default:
            begin
                start = 0;
            end
        endcase
    end

   endmodule
