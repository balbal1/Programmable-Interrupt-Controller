module IMR (ocw1, imr);

    input [7:0] ocw1;
    output reg [7:0] imr = 8'h00;

    always @(ocw1) begin
        imr <= ocw1;
    end

endmodule