module RateMatcher (
    input logic clk_RM,rst_RM,en_RM,
    input logic [11:0] TBS,
    input logic [11:0] G,
    input logic [1:0] Qm,
    input logic [1:0] rv_indx,
    input logic d_k0, d_k1,d_k2,

    output logic e_k,
    output logic RM_Valid 

);

logic temp_writeDummy_done,temp_writeDummy_done1,temp_writeDummy_done2,temp_writeDummy_done3;
logic temp_writeData_done,temp_writeData_done1,temp_writeData_done2,temp_writeData_done3;
logic temp_readData_done1,temp_readData_done2,temp_readData_done3;
logic temp_RM_Valid;
logic temp_writeDummy;
logic temp_writeData;
logic temp_en_RAM;
logic temp_en_buffer;
logic temp_weBuff;
logic [11:0] temp_E; 
logic [11:0] temp_D; 
logic [11:0] temp_k_pi;
logic [6:0]  temp_R;
logic [11:0] temp_Ko;
logic [4:0] temp_dummy_position;
logic [11:0] temp1_addr,temp2_addr,temp3_addr;
logic [1:0] v_k,v_k0,v_k1,v_k2;
logic temp_readRAM1,temp_readRAM2,temp_readRAM3;
logic [12:0] temp_addrBuff;
logic temp_v_k_Valid;
logic [1:0] temp_e_k;
logic       temp_wait_enable;
//logic temp_ready, temp_ready2,temp_ready3;

ControllerRM ControllerRM
(
    .clk(clk_RM),
    .rst(rst_RM),
    .enable(en_RM),
    .writeDummy_done(temp_writeDummy_done),
    .writeData_done(temp_writeData_done),
    .readData_done1(temp_readData_done1),
    .readData_done2(temp_readData_done2),
    .readData_done3(temp_readData_done3),
    .RM_Valid(temp_RM_Valid),
    //.ready(temp_ready),
    .TBS(TBS),
    .G(G),
    .Qm(Qm),
    .rv_idx(rv_indx),
    .writeDummy(temp_writeDummy),
    .writeData(temp_writeData),
    .en_RAM(temp_en_RAM),
    .en_Buffer(temp_en_buffer),
    .weBuff(temp_weBuff),
    .readRAM1(temp_readRAM1),
    .readRAM2(temp_readRAM2),
    .readRAM3(temp_readRAM3),
    .E(temp_E),
    .R(temp_R),
    .Ko(temp_Ko),
    .D(temp_D),
    .k_pi(temp_k_pi),
    .dummy_position(temp_dummy_position)
);

ControllerRAM #(.C(32), .OP_mode(0)) CtrlRAM1
(
    .clk(clk_RM),
    .rst(rst_RM),
    .dummyPosition(temp_dummy_position),
    .D(temp_D),
    .k_pi(temp_k_pi),
    .R(temp_R),
    .writeDum(temp_writeDummy),
    .write_data(temp_writeData),
    .read_data(temp_readRAM1),
    .writeDummy_done(temp_writeDummy_done1),
    .writeData_done(temp_writeData_done1),
    .readData_done(temp_readData_done1),
    //.ready(temp_ready),
    .addr(temp1_addr)
    
); 


RAMM RAM1
(
    .clk(clk_RM),
    .weDum(temp_writeDummy),
    .weData(temp_writeData),
    .en(temp_en_RAM),
    .addr(temp1_addr),
    .di(d_k0),
    .dout(v_k0)
);

ControllerRAM #(.C(32), .OP_mode(0)) CtrlRAM2
(
    .clk(clk_RM),
    .rst(rst_RM),
    .dummyPosition(temp_dummy_position),
    .D(temp_D),
    .k_pi(temp_k_pi),
    .R(temp_R),
    .writeDum(temp_writeDummy),
    .write_data(temp_writeData),
    .read_data(temp_readRAM2),
    .writeDummy_done(temp_writeDummy_done2),
    .writeData_done(temp_writeData_done2),
    .readData_done(temp_readData_done2),
    //.ready(temp_ready2),
    .addr(temp2_addr)
); 


RAMM RAM2
(
    .clk(clk_RM),
    .weDum(temp_writeDummy),
    .weData(temp_writeData),
    .en(temp_en_RAM),
    .addr(temp2_addr),
    .di(d_k1),
    .dout(v_k1)
);

ControllerRAM #(.C(32), .OP_mode(1)) CtrlRAM3
(
    .clk(clk_RM),
    .rst(rst_RM),
    .dummyPosition(temp_dummy_position),
    .D(temp_D),
    .k_pi(temp_k_pi),
    .R(temp_R),
    .writeDum(temp_writeDummy),
    .write_data(temp_writeData),
    .read_data(temp_readRAM3),
    .writeDummy_done(temp_writeDummy_done3),
    .writeData_done(temp_writeData_done3),
    .readData_done(temp_readData_done3),
    //.ready(temp_ready3),
    .addr(temp3_addr)
); 

RAMM RAM3
(
    .clk(clk_RM),
    .weDum(temp_writeDummy),
    .weData(temp_writeData),
    .en(temp_en_RAM),
    .addr(temp3_addr),
    .di(d_k2),
    .dout(v_k2)
);

assign temp_writeDummy_done = temp_writeDummy_done1;
assign temp_writeData_done = temp_writeData_done1 ;
//assign temp_readData_done = temp_readData_done1 ;

CtrlBuff CtrlBuffer 
(
    .clk(clk_RM),
    .rst(rst_RM),
    .en(temp_en_buffer),
    .K_PI(temp_k_pi),
    .Ko(temp_Ko),
    .E(temp_E),
    .readRAM1(temp_readRAM1),
    .readRAM2(temp_readRAM2),
    .readRAM3(temp_readRAM3),
    .v_k_Valid(temp_v_k_Valid),
    .addrBuff(temp_addrBuff),
    .RM_Valid(RM_Valid)
);

CHB choiceBlock
(
    .clk(clk_RM),
    .en(temp_en_buffer),
    .rst(rst_RM),
    .v_k0(v_k0),
    .v_k1(v_k1),
    .v_k2(v_k2),
    .readRAM1(temp_readRAM1),
    .readRAM2(temp_readRAM2),
    .readRAM3(temp_readRAM3),
    .v_k(v_k),
    .v_k_Valid(temp_v_k_Valid)
);

CirBuffTest CircBuffer
(
    .clk(clk_RM),
    .en(temp_en_buffer),
    .RAM_Out(v_k),
    .addrBuff(temp_addrBuff),
    .weBuff(temp_weBuff),
    .e_k(temp_e_k)
); 


BitSelect BitSelect
(
    .clk(clk_RM),
    .rst(rst_RM),
    .en(temp_weBuff),
    .e_k(temp_e_k),
    .ek(e_k)

);

endmodule