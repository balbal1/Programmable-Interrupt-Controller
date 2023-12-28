module DataBusBuffer (DATABUS, direction, databus_output, command_word);

    inout [7:0] DATABUS;
    input direction;
    input [7:0] databus_output;
    output [7:0] command_word;

    assign DATABUS = direction ? databus_output : 8'hZZ;
    assign command_word = DATABUS;

endmodule