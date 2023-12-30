module  IRR (IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, INTA, reset_irr_bit, level_triggered, number_of_ack, imr, irr_highest_bit, irr);

    input IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, INTA, reset_irr_bit, level_triggered;
    input [1:0] number_of_ack;
    input [7:0] imr, irr_highest_bit;
    output reg [7:0] irr = 8'b00000000;

    wire clear_ir0, clear_ir1, clear_ir2, clear_ir3, clear_ir4, clear_ir5, clear_ir6, clear_ir7;
    reg ir0 = 0, ir1 = 0, ir2 = 0, ir3 = 0, ir4 = 0, ir5 = 0, ir6 = 0, ir7 = 0;

    assign clear_ir0 = reset_irr_bit & irr_highest_bit == 8'h01;
    assign clear_ir1 = reset_irr_bit & irr_highest_bit == 8'h02;
    assign clear_ir2 = reset_irr_bit & irr_highest_bit == 8'h04;
    assign clear_ir3 = reset_irr_bit & irr_highest_bit == 8'h08;
    assign clear_ir4 = reset_irr_bit & irr_highest_bit == 8'h10;
    assign clear_ir5 = reset_irr_bit & irr_highest_bit == 8'h20;
    assign clear_ir6 = reset_irr_bit & irr_highest_bit == 8'h40;
    assign clear_ir7 = reset_irr_bit & irr_highest_bit == 8'h80;

    always @(IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, ir0, ir1, ir2, ir3, ir4, ir5, ir6, ir7, reset_irr_bit, number_of_ack) begin
        if (!level_triggered)
            irr = {ir7, ir6, ir5, ir4, ir3, ir2, ir1, ir0};
        else begin
            if (reset_irr_bit)
                irr = irr & ~irr_highest_bit;
            else
                irr = {IR7, IR6, IR5, IR4, IR3, IR2, IR1, IR0} & ~imr;
        end
    end

    always @(posedge IR0, posedge clear_ir0) begin
        if (clear_ir0)
            ir0 = 0;
        else
            ir0 = 1 & ~imr[0];
    end

    always @(posedge IR1, posedge clear_ir1) begin
        if (clear_ir1)
            ir1 = 0;
        else
            ir1 = 1 & ~imr[1];
    end

    always @(posedge IR2, posedge clear_ir2) begin
        if (clear_ir2)
            ir2 = 0;
        else
            ir2 = 1 & ~imr[2];
    end

    always @(posedge IR3, posedge clear_ir3) begin
        if (clear_ir3)
            ir3 = 0;
        else
            ir3 = 1 & ~imr[3];
    end
    
    always @(posedge IR4, posedge clear_ir4) begin
        if (clear_ir4)
            ir4 = 0;
        else
            ir4 = 1 & ~imr[4];
    end
    
    always @(posedge IR5, posedge clear_ir5) begin
        if (clear_ir5)
            ir5 = 0;
        else
            ir5 = 1 & ~imr[5];
    end
    
    always @(posedge IR6, posedge clear_ir6) begin
        if (clear_ir6)
            ir6 = 0;
        else
            ir6 = 1 & ~imr[6];
    end
    
    always @(posedge IR7, posedge clear_ir7) begin
        if (clear_ir7)
            ir7 = 0;
        else
            ir7 = 1 & ~imr[7];
    end

endmodule