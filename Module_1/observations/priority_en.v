
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );
    
    always @(*) begin
        casex (in)
            4'bxxx1 : pos=2'b00;
            4'bxx1x : pos=2'b01;
            4'bx1xx : pos=2'b10;
            4'b1xxx : pos=2'b11;
            default : pos=2'b00;
        endcase
    end
    
endmodule
