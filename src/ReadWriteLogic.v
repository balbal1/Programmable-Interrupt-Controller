module ReadWriteLogic (RD, WR, A0, CS, wr, rd, a0);

    input RD, WR, A0, CS;
    output rd, a0, wr;

    assign rd = (~CS) ? RD : 1;
    assign wr = (~CS) ? WR : 1;
    assign a0 = A0;

endmodule