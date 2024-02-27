`timescale 1ns/1ps

module fifo #(
        parameter AW = 11,
        parameter DW = 15,
        parameter DD = 2048
    )
    (

        input clk,
        input rst,
        input wea,
        input [DW:0] dina,
        input enb,
        output [DW:0] doutb,
        output full,
        output empty

    );
    
    
    reg [DW :0] ram [DD - 1:0];
    reg [DW:0] doutb_reg;
    reg [AW:0] counter;
    reg [AW-1:0] addra,addrb;
    reg [2:0] refc; 
    wire fill;
    reg flag;

    integer i;

	initial begin
	for(i = 0; i < DD; i = i + 1) begin
					ram[i] = 0;
			  end
		doutb_reg = 0;
		refc=0;
		counter=0;
		addra=0;
		addrb=0;
		flag=0;
	end
    
  
    always @(posedge clk) begin
    if (rst) begin
    doutb_reg <= 0;
		counter<=0;
		addra<=0;
		addrb<=0;
    end
    else begin

        if (wea && ~full) begin
            ram[addra] <= dina;
            counter<=counter+1;
            if (addra==2048) addra<=0; 
            else addra<=addra+1;
        end
        
        
        if(enb && ~empty) begin
            doutb_reg <= ram[addrb];
            if (counter==0) counter<=counter;
            else counter <= counter-1;
            if (addrb==2048) addrb<=0; 
            else addrb<=addrb+1;
            
        end
        end

    end
    
    always @(posedge clk) begin
    if (fill) refc<=refc+1;
    else refc<=0;
    if (addra==addrb) flag<=1;
    else flag<=0;
    end
    
    
    assign doutb = doutb_reg;
    assign fill = (counter==DD)?1:0;
    assign  full = refc[0];
    assign empty = (counter==0 && wea==0 && enb==0 || flag)?1:0;
    
    
endmodule
