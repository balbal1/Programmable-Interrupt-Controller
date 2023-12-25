module InterruptController (INTA, INT, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS, DATABUS, CAS, SP_EN);

    input INTA, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, A0, RD, WR, CS, SP_EN;
    inout [2:0] CAS;
    inout [7:0] DATABUS;
    output INT;

    wire reset_irr_bit, direction, wr, rd, a0, send_vector_address, higher_priority, level_triggered, auto_eoi;
    wire [1:0] number_of_ack, read_register;
    wire [7:0] vector_address, command_word, irr, isr, imr, icw3, ocw1, ocw2, isr_highest_bit, irr_highest_bit;

    //inistantiations
    IRR IRR (
        .IR0(IR0),
        .IR1(IR1),
        .IR2(IR2),
        .IR3(IR3),
        .IR4(IR4),
        .IR5(IR5),
        .IR6(IR6),
        .IR7(IR7),
        .INTA(INTA),
        .reset_irr_bit(reset_irr_bit),
        .level_triggered(level_triggered),
        .number_of_ack(number_of_ack),
        .imr(imr),
        .irr_highest_bit(irr_highest_bit),
        .irr(irr)
    );
    
    PriorityResolver PriorityResolver (
        .INTA(INTA),
        .auto_eoi(auto_eoi),
        .irr(irr),
        .isr(isr),
        .ocw2(ocw2),
        .irr_highest_bit(irr_highest_bit),
        .isr_highest_bit(isr_highest_bit),
        .INT(INT),
        .reset_irr_bit(reset_irr_bit),
        .higher_priority(higher_priority),
        .number_of_ack(number_of_ack)
    );

    ISR ISR (
        .INTA(INTA),
        .higher_priority(higher_priority),
        .auto_eoi(auto_eoi),
        .number_of_ack(number_of_ack),
        .irr_highest_bit(irr_highest_bit),
        .isr_highest_bit(isr_highest_bit),
        .ocw2(ocw2),
        .isr(isr)
    );
    
    IMR IMR (
        .ocw1(ocw1),
        .imr(imr)
    );

    ControlLogic ControlLogic (
        .wr(wr),
        .rd(rd),
        .a0(a0),
        .send_vector_address(send_vector_address),
        .number_of_ack(number_of_ack),
        .command_word(command_word),
        .isr_highest_bit(isr_highest_bit),
        .level_triggered(level_triggered),
        .auto_eoi(auto_eoi),
        .direction(direction),
        .read_register(read_register),
        .vector_address(vector_address),
        .icw3(icw3),
        .ocw1(ocw1),
        .ocw2(ocw2)
    );
    
    DataBusBuffer DataBusBuffer (
        .DATABUS(DATABUS),
        .direction(direction),
        .read_register(read_register),
        .irr(irr),
        .isr(isr),
        .vector_address(vector_address),
        .command_word(command_word)
    );
    
    ReadWriteLogic ReadWriteLogic (
        .RD(RD),
        .WR(WR),
        .A0(A0),
        .CS(CS),
        .wr(wr),
        .rd(rd),
        .a0(a0)
    );

    Cascade Cascade(
        .CAS(CAS),
        .SP_EN(SP_EN),
        .isr(isr),
        .icw3(icw3),
        .send_vector_address(send_vector_address)
    );

endmodule