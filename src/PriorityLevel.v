module PriorityLevel (register, priority, level, highest);

    input [7:0] register;
    input [23:0] priority;
    output reg [2:0] level;
    output reg [7:0] highest;

    wire [2:0] v0, v1, v2, v3, v4, v5, v6, v7;
    reg [2:0] v0_1, v2_3, v4_5, v6_7, v0_3, v4_7, v0_7;
    assign v0 = {3{~register[0]}} | priority[2:0];
    assign v1 = {3{~register[1]}} | priority[5:3];
    assign v2 = {3{~register[2]}} | priority[8:6];
    assign v3 = {3{~register[3]}} | priority[11:9];
    assign v4 = {3{~register[4]}} | priority[14:12];
    assign v5 = {3{~register[5]}} | priority[17:15];
    assign v6 = {3{~register[6]}} | priority[20:18];
    assign v7 = {3{~register[7]}} | priority[23:21];

    always @(v0_7, priority, register) begin
        if (register == 8'h00) begin
            highest <= 8'h00;
        end else begin
            if (v0_7 == priority[2:0])
                highest <= 8'h01;
            else if (v0_7 == priority[5:3])
                highest <= 8'h02;
            else if (v0_7 == priority[8:6])
                highest <= 8'h04;
            else if (v0_7 == priority[11:9])
                highest <= 8'h08;
            else if (v0_7 == priority[14:12])
                highest <= 8'h10;
            else if (v0_7 == priority[17:15])
                highest <= 8'h20;
            else if (v0_7 == priority[20:18])
                highest <= 8'h40;
            else if (v0_7 == priority[23:21])
                highest <= 8'h80;
            else
                highest <= 8'b00;
        end
    end

    always @(highest) begin
        case (highest)
            8'h01: level <= priority[2:0];
            8'h02: level <= priority[5:3];
            8'h04: level <= priority[8:6];
            8'h08: level <= priority[11:9];
            8'h10: level <= priority[14:12];
            8'h20: level <= priority[17:15];
            8'h40: level <= priority[20:18];
            8'h80: level <= priority[23:21];
            default: level <= 3'b111;
        endcase
    end

    always @(v0, v1) begin
        if (v0 < v1)
            v0_1 <= v0;
        else
            v0_1 <= v1;
    end
    always @(v2, v3) begin
        if (v2 < v3)
            v2_3 <= v2;
        else
            v2_3 <= v3;
    end
    always @(v4, v5) begin
        if (v4 < v5)
            v4_5 <= v4;
        else
            v4_5 <= v5;
    end
    always @(v6, v7) begin
        if (v6 < v7)
            v6_7 <= v6;
        else
            v6_7 <= v7;    
    end
    always @(v0_1, v2_3) begin
         if (v0_1 < v2_3)
            v0_3 <= v0_1;
        else
            v0_3 <= v2_3;
    end
    always @(v4_5, v6_7) begin
        if (v4_5 < v6_7)
            v4_7 <= v4_5;
        else
            v4_7 <= v6_7;
    end
    always @(v0_3, v4_7) begin
        if (v0_3 < v4_7)
            v0_7 <= v0_3;
        else
            v0_7 <= v4_7;
    end

endmodule