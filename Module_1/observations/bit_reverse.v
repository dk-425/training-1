module bit_reverse( 
    input [99:0] in,
    output [99:0] out
);  
    reg [6:0] i;
    always @(*) begin
        for (i=7'd0;i<7'd100;i=i+7'd1) begin
            out[i]=in[99-i];
        end  
end
endmodule
