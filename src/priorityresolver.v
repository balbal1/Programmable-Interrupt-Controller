module PriorityResolver (IRR, INTA, ISR, INT, resetIRRbit);
input [7:0] IRR;
input INTA;
output reg [7:0] ISR ;
output reg INT;
output reg resetIRRbit ;

reg [1:0] INTACOUNT = 0;

always @(negedge INTA or posedge INTA) begin // TO Drive ISR and to drive INT 

    if(INTACOUNT==1 && INTA == 1'b0)begin
        resetIRRbit <=1 ;
        if(IRR[0]==1) ISR=8'b00000001;
        else if(IRR[1]==1) ISR=8'b00000010;
        else if(IRR[2]==1) ISR=8'b00000100;
        else if(IRR[3]==1) ISR=8'b00001000;
        else if(IRR[4]==1) ISR=8'b00010000;
        else if(IRR[5]==1) ISR=8'b00100000;
        else if(IRR[6]==1) ISR=8'b01000000;
        else if(IRR[7]==1) ISR=8'b10000000;     
    end

    if (INTACOUNT == 2 && INTA == 1'b1)
        resetIRRbit = 0;
end

always @(negedge INTA or posedge INTA) begin
    if (INTACOUNT==2 && INTA == 1'b1) begin
        INTACOUNT <=0;
        ISR <=0 ; //AEO 
    end
    if (INTACOUNT!==2 && INTA == 1'b0) begin
        INTACOUNT <= INTACOUNT+1;
    end
end

always @(posedge INTA or IRR) begin
    if (INTACOUNT !== 2) begin
        INT <= |(IRR);
    end
    else if ((INTACOUNT == 2 ) && (INTA==1) )
        INT <= 0;
end


    
endmodule