module ControlLogic (wr, rd, a0, send_vector_address, number_of_ack, command_word, irr, isr, isr_highest_bit, level_triggered, auto_eoi, direction, databus_output, icw3, ocw1, ocw2);

    input wr, rd, a0, send_vector_address;
    input [1:0] number_of_ack;
    input [7:0] command_word, irr, isr, isr_highest_bit;
    output level_triggered, auto_eoi;
    output reg direction;
    output [7:0] databus_output;
    output reg [7:0] icw3, ocw1 = 8'h00, ocw2 = 8'h40;
    
    reg [2:0] interrupt_address;
    wire [7:0] selected_register, vector_address;
    reg [7:0] icw1, icw2, icw4, ocw3 = 8'h08;

    //one hot coded states for ICW FSM 
    parameter idle = 5'b00001,
              ICW1 = 5'b00010,
              ICW2 = 5'b00100,
              ICW3 = 5'b01000,
              ICW4 = 5'b10000;
    reg [4:0] currentstate = idle, nextstate;

    assign auto_eoi = icw4[1];
    assign level_triggered = icw1[3];

    assign vector_address = {icw2[7:3], interrupt_address}; //concatinating number of interupt(out) with T7-T3
    assign selected_register = ocw3[0] ? isr : irr;
    assign databus_output = ocw3[1] ? selected_register : vector_address;

    always @(isr_highest_bit) begin
        case (isr_highest_bit)
            8'h01: interrupt_address <= 3'b000;
            8'h02: interrupt_address <= 3'b001;
            8'h04: interrupt_address <= 3'b010;
            8'h08: interrupt_address <= 3'b011;
            8'h10: interrupt_address <= 3'b100;
            8'h20: interrupt_address <= 3'b101;
            8'h40: interrupt_address <= 3'b110;
            8'h80: interrupt_address <= 3'b111;
            default: interrupt_address <= 3'b000;
        endcase
    end

    //  FSM to detect ICW
    always @(negedge wr) begin   // State memory 
        currentstate <= nextstate;
    end

    always@(currentstate, command_word, a0) begin // next state logic 
        case (currentstate)
            idle:
                if (command_word[4] == 1 && a0 == 0)  // to check if it is ICW or not
                    nextstate <= ICW1;
                else
                    nextstate <= idle;
            ICW1: nextstate <= ICW2;
            ICW2:
                if (icw1[1] == 0) // there is icw3
                    nextstate <= ICW3;
                else if (icw1[0] == 1) // there is icw4
                    nextstate <= ICW4;
                else // no icw3 and no icw4
                    nextstate <= idle;
            ICW3:
                if (icw1[0] == 1) // there is icw4
                    nextstate <= ICW4;
                else
                    nextstate <= idle;
            ICW4:
                if (command_word[4] == 1 && a0 == 0)  // to check if it is ICW or not
                    nextstate <= ICW1;
                else
                    nextstate <= idle;
        endcase
    end

    always@(currentstate) begin // output logic
        case (currentstate)
            ICW1: icw1 <= command_word;
            ICW2: icw2 <= command_word;
            ICW3: icw3 <= command_word;
            ICW4: icw4 <= command_word;
        endcase
    end

    always @(negedge wr) begin // to detect OCW 
        if (nextstate == idle) begin
            if (a0 == 1)
                ocw1 <= command_word;
            else if (command_word[3] == 0)
                ocw2 <= command_word;
            else
                ocw3 <= command_word;
        end
    end

    // to open the tri-state buffer when sending the vector address 
    always @(number_of_ack, send_vector_address, rd) begin   
        if (number_of_ack == 2 && send_vector_address || rd == 1'b0)
            direction = 1;
        else
            direction = 0;
    end
    
endmodule