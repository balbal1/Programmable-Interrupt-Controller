module PriorityResolver (INTA, auto_eoi, irr, isr, ocw2, irr_highest_bit, isr_highest_bit, INT, reset_irr_bit, higher_priority, number_of_ack);

    input INTA, auto_eoi;
    input [7:0] irr, isr, ocw2;
    output higher_priority;
    output [7:0] irr_highest_bit, isr_highest_bit;
    output reg INT, reset_irr_bit = 0;
    output reg [1:0] number_of_ack = 0;

    reg clear_reset;
    wire reset_number_of_ack, reset_interrupt;
    wire [2:0] irr_level, isr_level;
    reg [23:0] priority = 24'b111110101100011010001000;

    assign higher_priority = irr_level <= isr_level;
    assign reset_number_of_ack = number_of_ack == 1 && irr_level < isr_level;
    assign reset_interrupt = number_of_ack == 2 && INTA == 1;

    PriorityLevel irrhigh(.register(irr), .priority(priority), .level(irr_level), .highest(irr_highest_bit));
    PriorityLevel isrhigh(.register(isr), .priority(priority), .level(isr_level), .highest(isr_highest_bit));

    always @(ocw2, INTA) begin
        if (ocw2[7] == 1'b1) begin  // check on rotation
            if (ocw2[6] == 1'b0 && number_of_ack == 2 && INTA == 1'b1) begin // check on automatic rotation
                case (isr_highest_bit)
                    8'h01: priority <= 24'b110101100011010001000111;
                    8'h02: priority <= 24'b101100011010001000111110;
                    8'h04: priority <= 24'b100011010001000111110101;
                    8'h08: priority <= 24'b011010001000111110101100;
                    8'h10: priority <= 24'b010001000111110101100011;
                    8'h20: priority <= 24'b001000111110101100011010;
                    8'h40: priority <= 24'b000111110101100011010001;
                    8'h80: priority <= 24'b111110101100011010001000;
                    default: priority <= 24'b111110101100011010001000;
                endcase
            end else if (ocw2[6] == 3'b1) begin // check on specific rotation
                case (ocw2[2:0])
                    3'b000: priority <= 24'b110101100011010001000111;
                    3'b001: priority <= 24'b101100011010001000111110;
                    3'b010: priority <= 24'b100011010001000111110101;
                    3'b011: priority <= 24'b011010001000111110101100;
                    3'b100: priority <= 24'b010001000111110101100011;
                    3'b101: priority <= 24'b001000111110101100011010;
                    3'b110: priority <= 24'b000111110101100011010001;
                    3'b111: priority <= 24'b111110101100011010001000;
                endcase
            end
        end
    end

    always @(INTA, reset_number_of_ack) begin
        if ((number_of_ack == 2 && INTA == 1'b1) || reset_number_of_ack) begin
            number_of_ack <= 0;
        end
        else if (number_of_ack != 2 && INTA == 1'b0)
            number_of_ack = number_of_ack + 1;
    end
    
    always @(irr, higher_priority, reset_interrupt) begin
        if (reset_interrupt) begin
            if (auto_eoi == 1'b0 && isr == isr_highest_bit && irr == 8'h00)
                INT <= 0;
            else
                INT <= |(irr) | |(isr-isr_highest_bit);
        end else if (number_of_ack == 1 && higher_priority && !reset_irr_bit && irr_level != 7) begin
            INT = 0;
            if (~INT)
                INT <= 1;
        end else if (auto_eoi == 1'b1 || number_of_ack != 0)
            INT <= |(irr) | |(isr);
        else
            INT <= |(irr) | |(isr-isr_highest_bit);
    end
    
    always @(number_of_ack, irr) begin
        if (clear_reset)
            reset_irr_bit <= 0;
        else if(number_of_ack == 1 && INTA == 1'b0 && irr != 8'h00 && higher_priority)
            reset_irr_bit <= 1;
    end

    always @(reset_irr_bit) begin
        if (reset_irr_bit)
            clear_reset = 1;
        else
            clear_reset <= 0;
    end

endmodule