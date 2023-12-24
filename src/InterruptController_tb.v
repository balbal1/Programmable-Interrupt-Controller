module InterruptController_tb ();
    
    reg INTA, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, A0, RD, WR, CS_master, CS_slave, SP_EN_master, SP_EN_slave;
    wire INT_master, INT_slave;
    wire [2:0] CAS;
    wire [7:0] DATABUS;

    reg [7:0] databus_drive;
    reg [8:0] commands [7:0];
    integer i = 0;

    assign DATABUS = databus_drive;

    InterruptController InterruptController (INTA, INT_master, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS_master, DATABUS, CAS, SP_EN_master);

    task command_words(input [7:0] bus_value, input A0_value);
    begin
        databus_drive = bus_value;
        A0 = A0_value;
        #5s
        WR = 0;
        #5
        WR = 1;
        #5;
    end
    endtask

    task INTA_PULSE();
    begin
        INTA = 0;
        #5
        INTA = 1;
        #5 ;
    end
    endtask

    initial begin
        IR0 = 0;
        IR1 = 0;
        IR2 = 0;
        IR3 = 0;
        IR4 = 0;
        IR5 = 0;
        IR6 = 0;
        IR7 = 0;
        INTA = 1;
        WR = 1;
        RD = 1;
        CS_master = 0;
        SP_EN_master = 1;


        // Test Case 0: interrupt with higher priority occured during an interrupt (AEO)
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3
        
        IR5 = 1;
        INTA_PULSE();
        IR0 = 1;
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000000) begin
            $display("error_Case0");
        end
        IR0 = 0;
        INTA_PULSE();
        INTA_PULSE();
        #5
          if (DATABUS !=8'b00000101) begin
            $display("error_Case0");
        end
        IR5 = 0;
       


        //Test Case 0.1: two interrupts are raised at the same time (AEO)
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3
        IR5 = 1;
        IR0 = 1;
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000000) begin
            $display("error_Case0.1");
        end
        IR0 = 0;
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000101) begin
            $display("error_Case0.1");
        end
        IR5 = 0;

        //Test Case 0.2: two interrupts are raised at the same time but one of them is masked (AEO)
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00001000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3
        IR3 = 1;
        IR7 = 1; 
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000111) begin
            $display("error_Case0");
        end
        IR7 = 0;
        // IR3 is masked so it should not be acknowledged
        IR3=0;


        //Test Case 0.3: level triggered interrupt (AEO)
        command_words(8'b00011011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00001000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3
        IR0 = 1;
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000000) begin
            $display("error_Case0.3");
        end
        INTA_PULSE();
        INTA_PULSE();
        #5
        if (DATABUS !=8'b00000000) begin
            $display("error_Case0.3");
        end
        IR0=0;
        // it should be served twice

        // Test Case 1: Non-Specific EOI
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000001, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b00100000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3

        IR1 = 1;
        INTA_PULSE();
        INTA_PULSE();
        IR1 = 0;
        command_words(8'b00100000, 1'b0); //OCW2 end of interrupt
        #5
        if (ISR !=8'b00000000) begin //CHECK on internal register isr
            $display("error_Case1");
        end



        // Test Case 3: Automatic Rotation
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b10000000, 1'b0); //OCW2
        command_words(8'b00001011, 1'b0); //OCW3

        IR4 = 1;
        INTA_PULSE();
        INTA_PULSE();
        IR4 = 0;
        #5
        IR4=1;
        IR5=1;
        #5
        INTA_PULSE();
        INTA_PULSE();
        IR5=0;
        #5
        //IR5 should be served before IR4 
        if (DATABUS !=8'b00000101) begin
            $display("error_Case 3");
        end
        INTA_PULSE();
        INTA_PULSE();
        IR4=0;
        #5
        // IR4 SHOULD BE served
        if (DATABUS !=8'b00000100) begin
            $display("error_Case 3");
        end

        // Disable automatic mode
        command_words(8'b00000000, 1'b0); //OCW2

    
       
    end
endmodule
