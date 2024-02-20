`timescale 1ns/1ps

module bram #(
    //! address width
    parameter ADDR_WIDTH = 11,
    //! data width
    parameter DATA_WIDTH = 15
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
    output [DATA_WIDTH - 1:0] doutb,
    output full,
    output empty
  );

  //! computing depth based on the number of address bits
  localparam DEPTH = 2048;

  //! ram/memory
  //! TODO: add pragma
  reg [DATA_WIDTH - 1:0] ram [DEPTH - 1:0];
  reg [DATA_WIDTH - 1:0] doutb_reg;
  reg [DATA_WIDTH - 1:0] counter;
  integer i;

  generate

    if(DEPTH == 2048)
    begin
      initial
      begin
        for(i = 0; i < DEPTH; i = i + 1)
        begin
          ram[i] = 0;
        end
      end
    end
  endgenerate


  initial
  begin
    doutb_reg = 0;
    counter = 0;
  end

  //! read/write block
  always @(posedge clk)
  begin

    if (wea)
    begin
      ram[addra] <= dina;
      counter<=counter+1;
    end

    //! reading from the bram
    if(enb)
    begin
      doutb_reg <= ram[addrb];
      counter <= counter-1;
    end
  end

  assign doutb = doutb_reg;
  assign full = (addra==DEPTH-1)?1:0;
  assign empty = (counter==0)?1:0;
endmodule

