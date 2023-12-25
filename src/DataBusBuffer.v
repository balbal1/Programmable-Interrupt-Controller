module DataBusBuffer (DATABUS, direction, read_register, irr, isr, vector_address, command_word);

    inout [7:0] DATABUS;
    input direction;
    input [1:0] read_register;
    input [7:0] irr, isr, vector_address;
    output [7:0] command_word;

    wire [7:0] selected_register, databus_output;

    assign selected_register = read_register[0] ? isr : irr;
    assign databus_output = read_register[1] ? selected_register : vector_address;

    assign DATABUS = direction ? databus_output : 8'hZZ;
    assign command_word = DATABUS;

endmodule