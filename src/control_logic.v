module control_logic (INTA, ISR, dataBus, WR, RD, A0, Direction, vector_address);

    input INTA, WR, RD, A0;
    input [7:0] ISR, dataBus;
    output reg Direction = 0;
    output reg [7:0] vector_address;

    reg[7:0] icw1, icw2, icw3, icw4; 
    wire [2:0] out ; // for encoder
    //one hot coded states for ICW FSM 
    parameter idle= 4'b0001,
              ICW2= 4'b0010,
              ICW3= 4'b0100,
              ICW4= 4'b1000;
    reg [3:0] currentstate, nextstate=idle ;

    integer numberOfAck = 0;

    encoder isr_encoder (.out(out), .in(ISR));

    //  FSM to detect ICW
    always@(negedge WR) begin   // State memory 
        currentstate <= nextstate;
    end

    always@(currentstate ,dataBus,A0 ) begin // next state logic 
        case (currentstate)
            idle: begin
                if (dataBus[4] == 1'b1 && A0 == 1'b0) begin  // to check if it is ICW or not
                    nextstate <= ICW2;
                end
                else nextstate <= idle;
            end
            ICW2: begin
                if (icw1[1] == 1 && icw1[0] == 0) // no icw3 and no icw4
                    begin nextstate <= idle; end
                else if (icw1[1] == 0) // there is icw3
                    nextstate <= ICW3;
                else if (icw1[0] == 1 && icw1[1] == 1) // there is icw4 and no icw3
                    nextstate <= ICW4;
            end
            ICW3: begin
                if(icw1[0]) // there is icw4
                    nextstate <= ICW4;
                else nextstate <= idle ;
            end
            ICW4: nextstate <= idle ; 
        endcase
    end

    always@(currentstate ,dataBus,A0) begin // output logic
        case(currentstate)
            idle: begin
                if (dataBus[4] == 1 && A0 == 0) begin
                    Direction = 0;
                    icw1 <= dataBus;
                end
            end
            ICW2: begin
                Direction = 0;
                icw2 <= dataBus;
            end
            ICW3: begin
                Direction = 0;
                icw3 <= dataBus;
            end
            ICW4: begin
                // Direction = 0;
                icw4 <= dataBus;
            end
        endcase
    end

    // to count number of INTA pusles and send ISR vector adress and 
    always @(negedge INTA) begin   
        if (numberOfAck != 2)
            numberOfAck = numberOfAck + 1;
        if (numberOfAck == 2) begin
            numberOfAck <= 0;
            Direction = 1;
            vector_address <= {icw2[7:3], out} ;//concatinating number of interupt(out) with T7-T3
        end
    end
    
endmodule