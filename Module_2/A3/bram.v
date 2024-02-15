`timescale 1ns/1ps

module bram #(
        //! address width
        parameter ADDR_WIDTH = 11,
        //! data width
        parameter DATA_WIDTH = 8
    )
    (
        //! clock
        input clk,
        //! write enable
        input wea,
        //! write address
        input [ADDR_WIDTH - 1:0] addra,
        //! write data
        input [DATA_WIDTH - 1:0] dina,
        //! read enable
        input enb,
        //! read address
        input [ADDR_WIDTH - 1:0] addrb, 
        //! read data output
        output [DATA_WIDTH - 1:0] doutb
    );
    
    //! computing depth based on the number of address bits
    localparam DEPTH = (1 << ADDR_WIDTH);
    
    //! ram/memory
    //! TODO: add pragma
    reg [DATA_WIDTH - 1:0] ram [DEPTH - 1:0];
    reg [DATA_WIDTH - 1:0] doutb_reg;
    integer i;
    //! turn on initiailisation
    //! NOTE: there is no reset on memory
	 generate 
	 
		if(DEPTH == 2048) begin
		 initial begin
			  for(i = 0; i < DEPTH; i = i + 1) begin
					ram[i] = 0;
			  end
		 end		
		end
	 endgenerate


	initial begin
		doutb_reg = 0;
	end
    
    //! read/write block
    always @(posedge clk) begin

            if (wea) begin
                ram[addra] <= dina;
        end
        
        //! reading from the bram
        if(enb) begin
            doutb_reg <= ram[addrb];
        end
    end
    
    assign doutb = doutb_reg;
endmodule