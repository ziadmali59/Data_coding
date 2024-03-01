module ControllerRAM #
(
        parameter C = 32,
        parameter OP_mode=1
)
(
    input logic clk,rst,
    input logic [4:0] dummyPosition,
    input logic [11:0] D,
    input logic [11:0] k_pi,
    input logic [6:0] R,

    input logic writeDum,
    input logic write_data,read_data,
    output logic writeDummy_done,
    output logic writeData_done,readData_done,//ready,
    output logic [11:0] addr

);

logic [4:0] P [0:31];
initial  begin
    P[0] = 0; P[1]=16 ; P[2]=8; P[3]=24 ; P[4]=4;  P[5]=20;P[6]=12; P[7]=28;
    P[8] = 2; P[9]=18 ; P[10]=10; P[11]=26 ; P[12]=6;  P[13]=22;P[14]=14;
    P[15]=30; P[16]=1 ; P[17]=17; P[18]=9  ; P[19]=25; P[20]=5; P[21]=21;
    P[22]=13; P[23]=29; P[24]=3 ; P[25]=19 ; P[26]=11; P[27] = 27; P[28] =7;
    P[29]=23; P[30]=15; P[31]=31;
end
logic [11:0] wait_count;
logic [11:0] data_count;
logic [4:0] dummy_count;
logic [7:0] row_count;
//logic [11:0] k;
logic [5:0] r;
logic [7:0] row_count1;
logic [5:0] r1;

always_ff @( posedge clk ) begin 
    if(!rst)begin
        writeDummy_done <= 0;
        writeData_done <= 0;
        readData_done <=0;
        addr <= 0;
        data_count <=0;
        dummy_count <= 0;
        row_count <=0;
        //k<=0;
        r<=0;
        row_count1 <=0 ;
        r1 <= 0;
    end
    else begin          
            data_count <= dummyPosition;
            if (writeDum && (writeDummy_done ==0)) begin
                if (dummy_count < dummyPosition) begin
                    addr <= {7'b0000000,dummy_count};  // filling dumy data
                    dummy_count <= dummy_count + 1;
                end
                else begin
                        writeDummy_done <=1;
                        dummy_count <= 0;
                        addr <= dummyPosition;
                end
            end
            if ((write_data ==1) && (writeDummy_done == 1) && (writeData_done ==0)) begin
                    if (data_count <= (D + dummyPosition)-1) begin
                        addr        <= data_count; 
                        data_count  <= data_count +1;
                    end
                    else begin
                        writeData_done <= 1; 
                        data_count <= 0;
                        if (OP_mode == 0) begin
                            addr <= 0;
                        end
                        else begin
                            addr <= 1;
                        end
                    end
            end
                
            if ((read_data ==1) && (writeData_done ==1) && (readData_done==0)) begin 
                if (OP_mode == 0) begin
                    if ((row_count != (R-1)) && (r<=31)) begin
                             addr <= addr +32;
                             row_count <= row_count +1; 
                        end
                    else begin
                    if ((row_count == (R-1))&& (r<=31)) begin
                        addr <= P[r+1];
                        r <= r +1;
                        row_count <= 0; 
                    end  
                    else begin
                        readData_done <=1; 
                    end
                    //end
                    end
                end

             else begin
                    if ((row_count1 != (R-1)) && (r1<=31)) begin
                        addr <= addr +32;
                        row_count1 <= row_count1 +1; 
                    end
                    else begin
                    if ((row_count1 == (R-1))&& (r1<=31)) begin
                        addr <= P[r1+1]+1;
                        r1 <= r1 +1;
                        row_count1 <= 0; 
                    end  
                    else begin
                        readData_done <=1; 
                    end
                    //end
                    end

               end
    end
end
end


endmodule

 /*if ((row_count != (R-1)) && (r<=31)) begin
                        if (row_count==0) begin
                            if (r == 0) begin
                                addr <= P[0];

                            end
                            else begin
                                row_count <= row_count + 1;
                            end
                        end 
                        else begin
                             addr <= addr +32;
                             row_count <= row_count +1;    
                            end  
                        end*/
                   /* if(k<k_pi) begin
                        
                    addr <= (P[k/R]+C*(k%R)+1)%k_pi;
                    k <= k +1;
                    end
                    else if(k == k_pi) begin
                        readData_done <=1;
                    end*/