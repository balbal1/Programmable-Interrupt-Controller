module ISR (INTA, higher_priority, auto_eoi, number_of_ack, irr_highest_bit, isr_highest_bit, ocw2, isr);
    
    input INTA, higher_priority, auto_eoi;
    input [1:0] number_of_ack;
    input [7:0] irr_highest_bit, isr_highest_bit, ocw2;
    output reg [7:0] isr = 8'b00000000;
    
    always @(INTA, number_of_ack, ocw2) begin // To drive isr
        if (number_of_ack == 2 && INTA == 1'b1) begin
            if (auto_eoi == 1) // check on mode
                isr <= isr & (~isr_highest_bit);
        end else if (number_of_ack == 0 && auto_eoi == 0 && ocw2[5] == 1'b1) begin
            if (ocw2[6] == 1'b0) begin // check on non-specific EOI command
                isr <= isr & (~isr_highest_bit);
            end else begin // specific EOI command
                case (ocw2[2:0])
                    3'b000: isr[0] <= 0;
                    3'b001: isr[1] <= 0;
                    3'b010: isr[2] <= 0;
                    3'b011: isr[3] <= 0;
                    3'b100: isr[4] <= 0;
                    3'b101: isr[5] <= 0;
                    3'b110: isr[6] <= 0;
                    3'b111: isr[7] <= 0;
                endcase
            end
        end else if(number_of_ack == 1 && INTA == 1'b0  && higher_priority) begin
            isr <= isr | irr_highest_bit;
        end
    end

endmodule