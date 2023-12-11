module ControlLogic (INTA, isr, command_word, wr, rd, a0, direction, vector_address, number_of_ack);

    input INTA, wr, rd, a0;
    input [7:0] isr, command_word;
    input [1:0] number_of_ack;
    output reg direction = 0;
    output [7:0] vector_address;

    reg[7:0] icw1, icw2, icw3, icw4; 
    wire [2:0] out ; // for encoder
    //one hot coded states for ICW FSM 
    parameter idle = 4'b0001,
              ICW2 = 4'b0010,
              ICW3 = 4'b0100,
              ICW4 = 4'b1000;
    reg [3:0] currentstate = idle, nextstate = idle;

    Encoder Encoder (.out(out), .in(isr));

    //  FSM to detect ICW
    always @(negedge wr) begin   // State memory 
        currentstate <= nextstate;
    end

    always@(currentstate, command_word, a0) begin // next state logic 
        case (currentstate)
            idle: begin
                if (command_word[4] == 1'b1 && a0 == 1'b0)  // to check if it is ICW or not
                    nextstate <= ICW2;
                else
                    nextstate <= idle;
            end
            ICW2: begin
                if (icw1[1] == 1 && icw1[0] == 0) // no icw3 and no icw4
                    nextstate <= idle;
                else if (icw1[1] == 0) // there is icw3
                    nextstate <= ICW3;
                else if (icw1[0] == 1 && icw1[1] == 1) // there is icw4 and no icw3
                    nextstate <= ICW4;
            end
            ICW3: begin
                if (icw1[0]) // there is icw4
                    nextstate <= ICW4;
                else
                    nextstate <= idle;
            end
            ICW4: nextstate <= idle; 
        endcase
    end

    always@(currentstate, command_word, a0) begin // output logic
        case(currentstate)
            idle: begin
                if (command_word[4] == 1 && a0 == 0) begin
                    direction = 0;
                    icw1 <= command_word;
                end
            end
            ICW2: begin
                direction = 0;
                icw2 <= command_word;
            end
            ICW3: begin
                direction = 0;
                icw3 <= command_word;
            end
            ICW4: begin
                direction = 0;
                icw4 <= command_word;
            end
        endcase
    end

    assign vector_address = {icw2[7:3], out}; //concatinating number of interupt(out) with T7-T3

    // to count number of INTA pusles and send isr vector adress and 
    always @(number_of_ack) begin   
        if (number_of_ack == 2)
            direction = 1;
        else
            direction = 0;
    end
    
endmodule