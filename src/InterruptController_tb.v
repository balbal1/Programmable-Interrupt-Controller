module InterruptController_tb ();
    
reg INTA, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, A0, RD, WR, CS;
wire INT;
wire [7:0] DATABUS;

reg [7:0] inout_drive;
wire [7:0] inout_recv;

assign DATABUS = inout_drive;
assign inout_recv = DATABUS;

InterruptController InterruptController (INTA, INT, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS, DATABUS);

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
    WR=1;

    #5
    WR=0;
    A0 = 0;
    #5
    inout_drive=8'b10111101;
    #5
    WR=1;
    #5
    WR=0;
    A0 = 1;
    #5
    inout_drive=8'b10111100;
    #5
    WR=1;
    #5
    WR=0;
    #5
    inout_drive=8'b00000000;
    #5
    WR=1;
    #5
    WR=0;
    #5
    inout_drive=8'b00000010;
    #5
    WR=1;
    #5
    inout_drive=8'bZZZZZZZZ;

    IR3 = 0;

    #5;

    IR3 = 1;
    #1;
    IR1 = 1;
    #1;

    #8;
    INTA = 0;
    #5;
    INTA = 1;
    #5;
    INTA = 0;
    #5;
    IR1 = 0;
    INTA = 1;

    #10;

    INTA = 0;
    #5;
    INTA = 1;
    #5;
    INTA = 0;
    #5;
    IR3 = 0;
    INTA = 1;



    #5;

    $stop;

end


endmodule

/*
    WR=1;
    #5
    WR=0;
    #5
    A0 = 0;
    inout_drive=8'b10111110;
    #5
    WR=1;
    #5
    WR=0;
    #5
    inout_drive=8'b10111100;
    #5
    WR=1;
    #5
    IR0 = 0;

    #5;

    IR0 = 1;
    IR1 = 0;
    IR2 = 0;
    IR3 = 0;
    IR4 = 0;
    IR5 = 0;
    IR6 = 0;
    IR7 = 0;
    INTA = 1;

    #10;


    INTA = 0;
    #5;
    INTA = 1;
    #5;
    INTA = 0;
    #5;
    INTA = 1;

    IR0 = 0;    

    $stop;
*/