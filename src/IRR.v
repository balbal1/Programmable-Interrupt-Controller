module  IRR (IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, imr, isr, reset_irr_bit, irr);

    input IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, reset_irr_bit;
    input [7:0] imr, isr;
    output reg [7:0] irr;

    always @(posedge IR0 or posedge IR1 or posedge IR2 or posedge IR3 or posedge IR4 or posedge IR5 or posedge IR6 or posedge IR7 or reset_irr_bit) begin
        if (reset_irr_bit)
            irr <= irr & ~(isr) ; 
        else
            irr <= { IR7 & ~imr[7], IR6 & ~imr[6], IR5 & ~imr[5], IR4 & ~imr[4], IR3 & ~imr[3], IR2 & ~imr[2], IR1 & ~imr[1], IR0 & ~imr[0]};
    end

endmodule