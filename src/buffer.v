module DataBusBuffer (data, direction, Rx_data, Tx_data);

    inout [7:0] data; //internal bus when send ** output **  or bus from pc when read so **input** 
    input direction;  //1>>sending to pc
    output [7:0] Rx_data; //recieved data
    input [7:0] Tx_data; //sent data

    assign data = direction ? Tx_data : 8'hZZ;
    assign Rx_data = data;

endmodule