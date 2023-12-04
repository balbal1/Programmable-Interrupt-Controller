module topmodule_tb ();
    
reg INTA,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,A0,RD,WR,CS;
reg [7:0] dataBus;
wire INT;
topmodule top (INTA,INT,IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,RD,WR,A0,CS,dataBus);

initial begin
    
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

    #5;
    IR1 = 1;
    
    #10;

    INTA = 0;
    #5;
    INTA = 1;
    #5;
    INTA = 0;
    #5;
    INTA = 1;
    IR1 = 0;
    #5;

    $stop;

end


endmodule