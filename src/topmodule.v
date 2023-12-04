module topmodule (INTA,INT,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,RD,WR,A0,CS,dataBus
);
input INTA,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,A0,RD,WR,CS;
input [7:0] dataBus;
output INT;
//inistantiations

wire [7:0] vector_address, instruction, IRR, ISR;
wire resetIRRbit, direction, WR_internal, RD_internal, A0_internal;
wire [7:0] IMR;
assign IMR = 8'h00;

IRR IR(.ISR(ISR), .IMR(IMR),.IRR(IRR),.resetIRRbit(resetIRRbit),.IR0(IR0),.IR1(IR1),.IR2(IR2),.IR3(IR3),.IR4(IR4),.IR5(IR5),.IR6(IR6),.IR7(IR7));
//DataBusBuffer buffer(.data(dataBus), .direction(direction), .Tx_data(vector_address), .Rx_data(instruction));
//control_logic control(.INTA(INTA), .ISR(ISR), .vector_address(vector_address), .dataBus(instruction), .WR(WR_internal), .RD(RD_internal), .A0(A0_internal), .Direction(direction));
PriorityResolver priority(.INTA(INTA), .IRR(IRR), .ISR(ISR), .resetIRRbit(resetIRRbit), .INT(INT));
//Read_write_logic read_write(.RD(RD), .WR(WR), .A0(A0), .CS(CS), .WR_out(WR_internal), .RD_out(RD_internal), .A0_out(A0_internal));


endmodule