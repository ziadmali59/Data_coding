module CtrlBuff (
            input logic clk,rst,en,
            input logic [11:0] K_PI,
            input logic [11:0] Ko,
            input logic [11:0] E,
            input logic readRAM1,readRAM2,readRAM3,v_k_Valid,

            output logic [12:0] addrBuff,
            output logic RM_Valid
);

logic writeBuff_done, writeBuff_done1,writeBuff_done2,writeBuff_done3;
logic readBuff_done;
logic [12:0] index_Counter1, index_Counter2,index_Counter3,index_CounterR;
//logic [12:0] j;

always_ff @( posedge clk ) begin
            if (!rst || !en) begin
                RM_Valid <= 0;
                writeBuff_done <= 0;
                writeBuff_done1<=0;writeBuff_done2<=0;writeBuff_done3<=0;
                readBuff_done <= 0;
                index_Counter1 <= 0; index_Counter2<=0;index_Counter3<=0;
                index_CounterR <=0;
                //j <= 0;
            end
            else begin
                if ((index_Counter1 <= (K_PI-1)) && v_k_Valid && !writeBuff_done1  && readRAM1) begin
                        addrBuff<= index_Counter1 ;
                        index_Counter1 <= index_Counter1+1;
                    end
                if(index_Counter1 == (K_PI)) begin
                        writeBuff_done1 <= 1;
                        index_Counter1 <= 0;
                        //addrBuff <= K_PI;
                end
                if ((index_Counter2 <= (K_PI-1))&& !writeBuff_done2 && readRAM2) begin
                        addrBuff <= K_PI+(index_Counter2 << 1);
                        index_Counter2 <= index_Counter2 +1;
                end
                 if (index_Counter2 == (K_PI)) begin
                        writeBuff_done2 <=1 ;
                        index_Counter2 <= 0;
                        //addrBuff <= K_PI+1;
                end
                if ((index_Counter3 <= (K_PI-1)) && !writeBuff_done3 && readRAM3) begin
                        addrBuff <= K_PI+(index_Counter3 << 1)+1;
                        index_Counter3 <= index_Counter3 +1;
                end
                if(index_Counter3 == K_PI) begin
                        writeBuff_done3 <=1;
                        index_Counter3<=0;
                end
                if (writeBuff_done1 && writeBuff_done2 && writeBuff_done3) begin
                            writeBuff_done <= 1;
                end
                if ((writeBuff_done == 1) && (readBuff_done == 0)) begin
                        if ((index_CounterR < E) && (index_CounterR==0)) begin
                                RM_Valid <= 1;
                                addrBuff <= Ko ; 
                                index_CounterR <= index_CounterR +1;
                        end
                        else if ((index_CounterR !=0) && (index_CounterR< E)) begin
                                addrBuff <= addrBuff + 1;
                                index_CounterR <= index_CounterR + 1;
                                RM_Valid <= 1;
                        end
                        else  begin
                            readBuff_done <= 1;
                            RM_Valid <= 0;
                        end
                    end
            end
    
end

endmodule


                           /* addrBuff <= (Ko+j)%(3*K_PI);
                            index_CounterR <= index_CounterR +1;*/
                            //j <= j +1;
//Cir_Buff[(Ko+j)%(3*K_PI)] != 2'b11
//                   if (Cir_Buff[(Ko+j)%(3*K_PI)] != 2'b11) begin
                               /* e_k <= Cir_Buff[(Ko+j)%(3*K_PI)][1];
                                index_Counter  <= index_Counter + 1;
                            end*/