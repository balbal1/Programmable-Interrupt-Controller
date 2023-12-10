module DataBusBuffer (DATABUS, direction, command_word, vector_address);

    inout [7:0] DATABUS; //internal bus when send ** output **  or bus from pc when read so **input** 
    input direction;  //1>>sending to pc
    output [7:0] command_word; //recieved data
    input [7:0] vector_address; //sent data

    assign DATABUS = direction ? vector_address : 8'hZZ;
    assign command_word = DATABUS;

endmodule