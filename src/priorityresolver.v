module PriorityResolver (irr, INTA, isr, INT, reset_irr_bit, number_of_ack);

    input [7:0] irr;
    input INTA;
    output reg [7:0] isr;
    output reg INT, reset_irr_bit;
    output reg [1:0] number_of_ack = 0;

    always @(negedge INTA or posedge INTA) begin // TO Drive isr and to drive INT 

        if (number_of_ack == 2 && INTA == 1'b1)
            number_of_ack <= 0;
        else if (number_of_ack != 2 && INTA == 1'b0)
            number_of_ack = number_of_ack + 1;

        if (number_of_ack == 2 && INTA == 1'b1) begin
            reset_irr_bit <= 0;
            isr <= 0; //AEO 
        end else if(number_of_ack == 1 && INTA == 1'b0) begin
            reset_irr_bit <= 1;
            if (irr[0] == 1) isr <= 8'b00000001;
            else if (irr[1] == 1) isr <= 8'b00000010;
            else if (irr[2] == 1) isr <= 8'b00000100;
            else if (irr[3] == 1) isr <= 8'b00001000;
            else if (irr[4] == 1) isr <= 8'b00010000;
            else if (irr[5] == 1) isr <= 8'b00100000;
            else if (irr[6] == 1) isr <= 8'b01000000;
            else if (irr[7] == 1) isr <= 8'b10000000;     
        end
    end

    always @(posedge INTA or irr or number_of_ack) begin
        if (number_of_ack == 2 && INTA == 1)
            INT <= 0;
        else if (number_of_ack == 0)
            INT <= |(irr);
    end

endmodule