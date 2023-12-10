module  IRR (IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, IMR, ISR, resetIRRbit, IRR);

    input IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, resetIRRbit;
    input [7:0] IMR, ISR;
    output reg [7:0] IRR;

    always @(posedge IR0 or posedge IR1 or posedge IR2 or posedge IR3 or posedge IR4 or posedge IR5 or posedge IR6 or posedge IR7 or resetIRRbit) begin
        if (resetIRRbit)
            IRR <= IRR & ~(ISR) ; 
        else
            IRR <= { IR7 & ~IMR[7], IR6 & ~IMR[6], IR5 & ~IMR[5], IR4 & ~IMR[4], IR3 & ~IMR[3], IR2 & ~IMR[2], IR1 & ~IMR[1], IR0 & ~IMR[0]};
    end

endmodule