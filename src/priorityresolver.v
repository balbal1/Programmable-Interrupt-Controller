module PriorityResolver (IRR,INTA,ISR
);
input [7:0] IRR,
input INTA;
output  [7:0] ISR ;
output  [7:0] IMR ;
output INT;
output resetIRRbit ;


always @(negedge INTA) begin // TO Drive ISR and to drive INT 

    if(INTACOUNT==1)begin
        //resetIRRbit <=1 ;
        if(IRR[0]==1) begin ISR=8'b00000001;resetIRRbit=1;end
        else if(IRR[1]==1)begin ISR=8'b00000010;resetIRRbit=1;end
        else if(IRR[2]==1)begin  ISR=8'b00000100;resetIRRbit=1;end
        else if(IRR[3]==1)begin ISR=8'b00001000;resetIRRbit=1;end
        else if(IRR[4]==1)begin ISR=8'b00010000;resetIRRbit=1;end
        else if(IRR[5]==1)begin ISR=8'b00100000;resetIRRbit=1;end
        else if(IRR[6]==1)begin  ISR=8'b01000000;resetIRRbit=1;end
        else if(IRR[7]==1)begin  ISR=8'b10000000;resetIRRbit=1;end
        
end
 if (INTACOUNT!=2) 
    INTACOUNT<=INTACOUNT+1;
     INT=|(IRR) ;

 if (INTACOUNT==2) begin
    INTACOUNT<=0;
    INT<=0;
    ISR<=0 ; //AEO 
    end

end



    
endmodule