module Cascade (CAS, SP_EN, isr, icw3, icw4, send_vector_address);
    
    inout [2:0] CAS;
    input SP_EN;
    input [7:0] isr, icw3, icw4;
    output reg send_vector_address;

    wire [2:0] cas_read;
    reg [2:0] cas_write;

    assign CAS = SP_EN ? cas_write : 3'hZ;
    assign cas_read = CAS;

    always @(*) begin
        if (icw4[3] == 0) begin // not in buffered mode
            if (SP_EN) begin
                case (icw3 & isr)
                    8'h01: begin
                        cas_write <= 3'b000;
                        send_vector_address <= 0;
                    end
                    8'h02: begin
                        cas_write <= 3'b001;
                        send_vector_address <= 0;
                    end
                    8'h04: begin
                        cas_write <= 3'b010;
                        send_vector_address <= 0;
                    end
                    8'h08: begin
                        cas_write <= 3'b011;
                        send_vector_address <= 0;
                    end
                    8'h10: begin
                        cas_write <= 3'b100;
                        send_vector_address <= 0;
                    end
                    8'h20: begin
                        cas_write <= 3'b101;
                        send_vector_address <= 0;
                    end
                    8'h40: begin
                        cas_write <= 3'b110;
                        send_vector_address <= 0;
                    end
                    8'h80: begin
                        cas_write <= 3'b111;
                        send_vector_address <= 0;
                    end
                    default: begin
                        cas_write <= 3'b000;
                        send_vector_address <= 1;
                    end
                endcase
            end
            else begin // slave mode
                if (cas_read == icw3[2:0]) // check if cascasde is same as my id
                    send_vector_address <= 1;
            end
        end
    
    end
    
endmodule