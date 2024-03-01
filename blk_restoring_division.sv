module blk_restoring_division #(parameter TBS = 16)
(
    input  logic          clk,
    input  logic          rst,
    input  logic          start,
    input  logic [/*24*/16:0]   X,
    output logic [12:0] modout,
    output logic         valid
);

logic [16:0] Y; 
logic [33:0] Z,next_Z,
             Z_temp,
             Z_temp1;
logic        next_state,
             pres_state;
logic [4:0] count,
             next_count;
logic        next_valid;
logic [16:0] quot,
             rem;
             

localparam  IDLE = 1'b0;
localparam  START = 1'b1;
assign Y    = TBS+24;
assign rem  = Z[33:17];
assign quot = Z[16:0];

always @ (posedge clk or negedge rst)
begin
if(!rst)
begin
  Z          <= 34'b0;
  valid      <= 1'b0;
  pres_state <= IDLE;
  count      <= 5'b0;
end
else
begin
  Z          <= next_Z;
  valid      <= next_valid;
  pres_state <= next_state;
  count      <= next_count;
end
end

always @ (*)
begin 
case(pres_state)
IDLE:
begin
    next_count = 5'b0;
    next_valid = 1'b0;
if(start)
begin
    next_state = START;
    next_Z     = {17'b0,X};
end
else
begin
    next_state = pres_state;
    next_Z     = 33'b0;
end
end

START:
begin
    next_count = count + 1'b1;
    Z_temp     = Z << 1;
    Z_temp1    = {Z_temp[33:17]-Y,Z_temp[16:0]};
    next_Z     = Z_temp1[33] ? {Z_temp[33:17],Z_temp[16:1],1'b0} : {Z_temp1[33:17],Z_temp[16:1],1'b1} ;
    next_valid = (count==16) ? 1'b1 : 1'b0; 
    next_state = (count==16) ? IDLE : pres_state;	
end
endcase
end
assign modout=(valid)? (X-quot*Y) :(X-quot*Y);
endmodule