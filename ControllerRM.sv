module ControllerRM 
(
    input  logic clk, rst, enable,
    input  logic writeDummy_done,writeData_done,
    input  logic readData_done1, readData_done2,readData_done3,  
    input  logic RM_Valid,
    //input  logic ready, 
    input  logic [11:0] TBS,
    input  logic [11:0] G,
    input  logic [1:0]  Qm,
    input  logic [1:0] rv_idx,

    output logic writeDummy,writeData,
    output logic en_RAM,en_Buffer,weBuff,readRAM1,readRAM2,readRAM3,
    output logic [11:0] E,
    output logic [6:0]  R,
    output logic [11:0] Ko,
    output logic [11:0] D,
    output logic [11:0] k_pi,
    output logic [4:0]  dummy_position
);
logic [2:0] state;
parameter s0 = 3'b000;       // 1st state (sleep state)
parameter s1 = 3'b001;       // 2nd state (write dummy state)
parameter s2 = 3'b010;       // 3rd state (write into RAMs)
parameter s3 = 3'b011;       // 4th state read from RAM1
parameter s4 = 3'b100;       // 5th state read from RAM2
parameter s5 = 3'b101;       // 6th state read from RAM3
parameter s6 = 3'b110;       // 7th state (read from Buffer) 
//parameter s7 = 3'b111;     // separation state between write state and read state
logic [11:0] E_temp;
logic [6:0] R_temp;
logic [11:0] Ko_temp;
logic [4:0] dummy_position_temp;
logic [11:0] temp_D;
logic [11:0] temp_k_pi;

    ALU #(.CB(1), .NL(1), .C(32)) ALU_Cont
    (
        .TBS(TBS),
        .G(G),
        .Qm(Qm),
        .rv_idx(rv_idx),
        .E(E_temp),
        .Ko(Ko_temp),
        .k_pi(temp_k_pi),
        .D(temp_D),
        .dummy_position(dummy_position_temp),
        .no_ofRows(R_temp)
    );

always_ff @(posedge clk ) begin
            case (state)
                s0: if (rst) begin
                       state <= s1;  
                    end
                s1 : if ((writeDummy_done == 1)&& enable) begin
                        state <= s2;
                    end
                s2 : if (writeData_done) begin
                        state <= s3;
                    end
                s3 : if (readData_done1) begin
                        state <= s4;
                    end
                s4: if (readData_done2) begin
                    state <= s5;
                end
                s5: if (readData_done3) begin
                    state <= s6;
                end
                s6: if (RM_Valid) begin
                    state <= s0;
                end
                /*s7: if (ready) begin
                    state <= s3;
                end*/
                default: state <= s0;
            endcase
    
end

always_comb begin 
            case (state)
                s0: begin
                   E = 0; R =0; Ko =0; dummy_position=0;D=0; k_pi=0;
                   en_RAM = 0; en_Buffer=0; writeDummy=0 ; writeData =0 ;readRAM1=0;readRAM2=0;readRAM3=0;weBuff=0;
                end
                s1: begin
                   E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                   D= temp_D; k_pi = temp_k_pi;
                   en_RAM = 1; en_Buffer= 0; writeDummy =1; writeData=0;readRAM1=0;readRAM2=0;readRAM3=0;weBuff=0;
                   if (writeDummy_done) begin
                        writeDummy = 0;
                   end
                   else begin
                    writeDummy = 1;
                   end
                end
                s2: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM=1; en_Buffer=0; writeDummy=0; readRAM1=0;readRAM2=0;readRAM3=0;weBuff=0;
                    if (writeData_done) begin
                        writeData =0;
                    end
                    else begin
                        writeData = 1;
                    end
                end
                s3: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM =1; en_Buffer=1; writeDummy=0;writeData=0;readRAM1=1;readRAM2=0;readRAM3=0;weBuff=1;
                    if(readData_done1)begin
                        readRAM1 = 0;
                        readRAM2 = 1;
                    end
                    else begin
                        readRAM1 =1;
                    end
                end
                s4: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM =1; en_Buffer=1; writeDummy=0;writeData=0;readRAM1=0;readRAM2=1;readRAM3=0;weBuff=1;
                    if(readData_done2)begin
                        readRAM2 = 0;
                        readRAM3 = 1;
                    end
                    else begin
                        readRAM2 = 1;
                    end
                end
                s5: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM =1; en_Buffer=1; writeDummy=0;writeData=0;readRAM1=0;readRAM2=0;readRAM3=1;weBuff=1;
                    if (readData_done3) begin
                        readRAM3 = 0; 
                    end
                    else begin
                        readRAM3 =1;
                    end
                end
                s6: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM =1; en_Buffer=1; writeDummy=0;writeData=0;readRAM1=0;readRAM2=0;readRAM3=0;weBuff=0;
                end
                /*s7: begin
                    E= E_temp;R= R_temp;Ko = Ko_temp;dummy_position = dummy_position_temp;
                    D= temp_D; k_pi = temp_k_pi;
                    en_RAM =0; en_Buffer=0; writeDummy=0;writeData=0;readRAM1=0;readRAM2=0;readRAM3=0;weBuff=0;
                end*/
                default: begin
                    E = 0; R =0; Ko =0; dummy_position=0; D=0 ; k_pi=0;
                    en_RAM = 0; en_Buffer=0; writeDummy=0 ; writeData =0 ;readRAM1=0;readRAM2=0;readRAM3=0;weBuff<=0;
                end
            endcase 
    
end
endmodule