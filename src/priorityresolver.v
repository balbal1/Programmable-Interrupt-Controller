module PriorityResolver (IRR, INTA, ISR, INT, resetIRRbit);

    input [7:0] IRR;
    input INTA;
    output reg [7:0] ISR ;
    output reg INT, resetIRRbit;

    reg [1:0] INTACOUNT = 0;

    always @(negedge INTA or posedge INTA) begin // TO Drive ISR and to drive INT 

        if (INTACOUNT == 2 && INTA == 1'b1)
            INTACOUNT <= 0;
        else if (INTACOUNT != 2 && INTA == 1'b0)
            INTACOUNT = INTACOUNT + 1;

        if (INTACOUNT == 2 && INTA == 1'b1) begin
            resetIRRbit <= 0;
            ISR <=0 ; //AEO 
        end else if(INTACOUNT == 1 && INTA == 1'b0) begin
            resetIRRbit <= 1 ;
            if (IRR[0] == 1) ISR <= 8'b00000001;
            else if (IRR[1] == 1) ISR <= 8'b00000010;
            else if (IRR[2] == 1) ISR <= 8'b00000100;
            else if (IRR[3] == 1) ISR <= 8'b00001000;
            else if (IRR[4] == 1) ISR <= 8'b00010000;
            else if (IRR[5] == 1) ISR <= 8'b00100000;
            else if (IRR[6] == 1) ISR <= 8'b01000000;
            else if (IRR[7] == 1) ISR <= 8'b10000000;     
        end
    end

    always @(posedge INTA or IRR) begin
        if (INTACOUNT == 0)
            INT <= |(IRR);
        else if (INTACOUNT == 2 && INTA==1)
            INT <= 0;
    end

endmodule