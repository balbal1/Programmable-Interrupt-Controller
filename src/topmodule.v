module topmodule (INTA,INT,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,RD,WR,A0,CS,dataBus
);
input INTA,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,A0,RD,WR,CS;
inout dataBus;
output INT; 
//inistantiations
IRR IR(.ISR(ISR),.resetIRRbit(resetIRRbit),.IR0(IR0),.IR1(IR1),.IR2(IR2),.IR3(IR3),.IR4(IR4),.IR5(IR5),.IR6(IR6),.IR7(IR7));



    
endmodule