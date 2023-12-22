module InterruptController_tb ();
    
    reg INTA, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, A0, RD, WR, CS_master, CS_slave, SP_EN_master, SP_EN_slave;
    wire INT_master, INT_slave;
    wire [2:0] CAS;
    wire [7:0] DATABUS;

    reg [7:0] databus_drive;
    reg [8:0] commands [7:0];
    integer i = 0;

    assign DATABUS = databus_drive;

    InterruptController InterruptControllerMaster (INTA, INT_master, IR0, INT_slave, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS_master, DATABUS, CAS, SP_EN_master);
    InterruptController InterruptControllerSlave (INTA, INT_slave, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS_slave, DATABUS, CAS, SP_EN_slave);

    initial begin
        SP_EN_master = 1;
        SP_EN_slave = 0;
        WR = 1;
        RD = 1;
        INTA = 1;
        
        $readmemb("commands.txt", commands);

        CS_slave = 1;
        CS_master = 0;
        for (i = 0; i <= 3; i = i + 1) begin // To initialize master
            A0 = commands[i][8];
            databus_drive = commands[i][7:0];
            #5
            WR = 0;
            #5
            WR = 1;
        end

        CS_slave = 0;
        CS_master = 1;
        for (i = 4; i <= 7; i = i + 1) begin // To initialize slave
            A0 = commands[i][8];
            databus_drive = commands[i][7:0];
            #5
            WR = 0;
            #5
            WR = 1;
        end
        databus_drive = 8'bZZZZZZZZ;

        #5

        IR0 = 0;
        IR1 = 1; // do drive the input intrrupt of slave
        IR2 = 0;
        IR3 = 0;
        IR4 = 0;
        IR5 = 0;
        IR6 = 0;
        IR7 = 0;
        #5
        INTA = 1;
        #5
        INTA = 0;
        #5
        INTA = 1;
        #5
        INTA = 0;
        #5
        INTA = 1;
        IR1 = 0;
        #5
        
        $stop;
    end

endmodule