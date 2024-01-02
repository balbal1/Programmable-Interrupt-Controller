module InterruptController_tb ();
    
    reg INTA, IR0_master, IR1_master, IR3_master, IR4_master, IR5_master, IR6_master, IR7_master,
        IR0_slave, IR1_slave, IR2_slave, IR3_slave, IR4_slave, IR5_slave, IR6_slave, IR7_slave,
        A0, RD, WR, CS_master, CS_slave, SP_EN_master, SP_EN_slave;
    wire INT_master, INT_slave;
    wire [2:0] CAS;
    wire [7:0] DATABUS;

    reg [7:0] databus_drive;    

    assign DATABUS = databus_drive;

    InterruptController MasterInterruptController (INTA, INT_master, IR0_master, IR1_master, INT_slave, IR3_master, IR4_master, IR5_master, IR6_master, IR7_master, RD, WR, A0, CS_master, DATABUS, CAS, SP_EN_master);
    InterruptController SlaveInterruptController (INTA, INT_slave, IR0_slave, IR1_slave, IR2_slave, IR3_slave, IR4_slave, IR5_slave, IR6_slave, IR7_slave, RD, WR, A0, CS_slave, DATABUS, CAS, SP_EN_slave);

    task command_words(input [7:0] bus_value, input A0_value);
    begin
        databus_drive = bus_value;
        A0 = A0_value;
        #5
        WR = 0;
        #5
        WR = 1;
        #5;
        databus_drive = 8'hZZ;
    end
    endtask

    task INTA_PULSE(input check_bus, input [7:0] expected_value, input [3:0] test, input [2:0] test_case);
    begin
        #5
        INTA = 0;
        #2
        if (check_bus) begin
            if (DATABUS != expected_value || ^DATABUS == 1'bX)
                $display("Error in Case %d.%d", test, test_case);
        end
        #3
        INTA = 1;
        #5;
    end
    endtask

    initial begin
        IR0_master = 0;
        IR1_master = 0;
        IR3_master = 0;
        IR4_master = 0;
        IR5_master = 0;
        IR6_master = 0;
        IR7_master = 0;
        IR0_slave = 0;
        IR1_slave = 0;
        IR2_slave = 0;
        IR3_slave = 0;
        IR4_slave = 0;
        IR5_slave = 0;
        IR6_slave = 0;
        IR7_slave = 0;
        INTA = 1;
        WR = 1;
        RD = 1;
        CS_master = 1;
        CS_slave = 1;
        SP_EN_master = 1;
        SP_EN_slave = 0;

        // Test Case 1: interrupt with higher priority occured during an interrupt (AEO)
        CS_master = 0;
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        #5
        IR5_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        IR0_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000000, 1, 0);
        #5
        IR0_master = 0;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000101, 1, 1);
        #5
        IR5_master = 0;
       
        //Test Case 2: two interrupts are raised at the same time (AEO)
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        #5
        IR5_master = 1;
        IR0_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000000, 2, 0);
        #5
        IR0_master = 0;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000101, 2, 1);
        #5
        IR5_master = 0;

        //Test Case 3: two interrupts are raised at the same time but one of them is masked (AEO)
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00001000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        #5
        IR3_master = 1;
        IR7_master = 1; 
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000111, 3, 0);
        #5
        IR7_master = 0;
        // IR3 is masked so it should not be acknowledged
        IR3_master = 0;


        //Test Case 4: level triggered interrupt (AEO)
        command_words(8'b00011011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00001000, 1'b1); //OCW1
        command_words(8'b00000000, 1'b0); //OCW2
        #5
        IR0_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000000, 4, 0);
        #5
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000000, 4, 1);
        #5
        IR0_master = 0;
        // it should be served twice

        // Test Case 5: Non-Specific EOI
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000001, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        #5
        IR1_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        IR1_master = 0;
        #5
        command_words(8'b00100000, 1'b0); //OCW2 end of interrupt
        command_words(8'b00001011, 1'b0); //OCW3
        #5
        RD = 0;
        #2
        if (DATABUS != 8'b00000000) begin //CHECK on register isr read
            $display("Error in Case 5.0");
        end
        #3
        RD = 1;
        #5
        command_words(8'b00001000, 1'b0); //OCW3

        // Test Case 6: Automatic Rotation
        command_words(8'b00010011, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000011, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //OCW1
        command_words(8'b10000000, 1'b0); //OCW2
        #5
        IR4_master = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000100, 6, 0);
        IR4_master = 0;
        #5
        IR4_master = 1;
        IR5_master = 1;
        #5
        //IR5 should be served before IR4 
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000101, 6, 1);
        IR5_master = 0;
        #5
        // IR4 SHOULD BE served
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00000100, 6, 2);
        IR4_master = 0;
        #5
        // Disable automatic mode
        command_words(8'b00000000, 1'b0); //OCW2

        // Test Case 7: Master/Slave (AEOI)
        command_words(8'b11110101, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000100, 1'b1); //ICW4
        command_words(8'b00000010, 1'b1); //ICW4
        CS_master = 1;
        CS_slave = 0;
        command_words(8'b11110101, 1'b0); //ICW1
        command_words(8'b00001000, 1'b1); //ICW2
        command_words(8'b00000010, 1'b1); //ICW4
        command_words(8'b00000010, 1'b1); //ICW4
        #5
        IR6_slave = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00001110, 6, 0);
        #5
        IR6_slave = 0;

        // Test Case 8: Master/Slave Normal EOI
        CS_master = 0;
        CS_slave = 1;
        command_words(8'b11110101, 1'b0); //ICW1
        command_words(8'b00000000, 1'b1); //ICW2
        command_words(8'b00000100, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //ICW4
        CS_master = 1;
        CS_slave = 0;
        command_words(8'b11110101, 1'b0); //ICW1
        command_words(8'b00001000, 1'b1); //ICW2
        command_words(8'b00000010, 1'b1); //ICW4
        command_words(8'b00000000, 1'b1); //ICW4
        #5
        IR6_slave = 1;
        INTA_PULSE(1'b0, 8'h00, 0, 0);
        INTA_PULSE(1'b1, 8'b00001110, 6, 0);
        #5
        IR6_slave = 0;
        CS_master = 0;
        CS_slave = 1;
        command_words(8'b00100000, 1'b0); //OCW2 end of interrupt
        #5
        CS_master = 1;
        CS_slave = 0;
        command_words(8'b00100000, 1'b0); //OCW2 end of interrupt
        #5

        $stop;
       
    end
endmodule
