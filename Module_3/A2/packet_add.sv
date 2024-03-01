`timescale 1ns / 1ps

module axis_packrec_1 #(
    parameter AW = 10,
    parameter DW = 8,
    parameter DD = 512)(

      input                  clk,
      input                  rst,

      input    [DW-1   :0]   s_tdata,
      input                  s_tvalid,
      input                  s_tlast,
      output                 s_tready,

      input [DW+DW -1:  0]   packet_config,

      output   [DW-1   :0]   m_tdata,
      output                 m_tvalid,
      output                 m_tlast,
      input                  m_tready,
      output                 full,
      output                 empty
    );

  logic [DW :0] s_tdata_i;
  logic [DW :0] m_tdata_i;
  logic [AW:0] read_idx, write_idx;
  logic [DW-1:0] len,k;
  //(*preserve*) logic wea, enb;

  logic s_tready_i;

  fifo #(
         .AW(AW),
         .DW(DW),
         .DD(DD)
         
  ) fifo_inst(
         .clk(clk),
         .rst(rst),
         .wea(wea),
         .dina(s_tdata_i),
         .enb(enb),
         .doutb(m_tdata_i),
         .full(full),
         .empty(empty)
       );

  always @(*)
  begin
    if (rst || full)
      s_tready_i <=0;
    else
      s_tready_i <=1;
  end

  always @(posedge clk)
  begin
    if (rst)
    begin
      read_idx<=0;
      write_idx<=0;
    end
    end


  assign s_tready= s_tready_i;
  assign m_tvalid = (enb && ~empty)?1:0;
  assign wea = s_tvalid && s_tready ;
  assign enb = (m_tready)?1:0;
  assign s_tdata_i = wea?{s_tlast,s_tdata}:0;
  assign {m_tlast,m_tdata} = enb?m_tdata_i:0;
  assign {len,k} = packet_config;
 

endmodule

module axis_packrec_2 #(
    parameter AW = 10,
    parameter DW = 8,
    parameter DD = 512)(

      input                  clk,
      input                  rst,

      input    [DW-1   :0]   s_tdata,
      input                  s_tvalid,
      input                  s_tlast,
      output                 s_tready,

      output   [DW-1   :0]   m_tdata,
      output                 m_tvalid,
      output                 m_tlast,
      input                  m_tready,
      output                 full,
      output                 empty
    );

  logic [DW :0] s_tdata_i;
  logic [DW :0] m_tdata_i;
  logic [AW:0] read_idx, write_idx;

  //(*preserve*) logic wea, enb;

  logic s_tready_i;

  fifo #(
         .AW(AW),
         .DW(DW),
         .DD(DD)
         
  ) fifo_inst(
         .clk(clk),
         .rst(rst),
         .wea(wea),
         .dina(s_tdata_i),
         .enb(enb),
         .doutb(m_tdata_i),
         .full(full),
         .empty(empty)
       );

  always @(*)
  begin
    if (rst || full)
      s_tready_i <=0;
    else
      s_tready_i <=1;
  end

  always @(posedge clk)
  begin
    if (rst)
    begin
      read_idx<=0;
      write_idx<=0;
    end
    end


  assign s_tready= s_tready_i;
  assign m_tvalid = (enb && ~empty)?1:0;
  assign wea = s_tvalid && s_tready ;
  assign enb = (m_tready)?1:0;
  assign s_tdata_i = wea?{s_tlast,s_tdata}:0;
  assign {m_tlast,m_tdata} = enb?m_tdata_i:0;
 

endmodule
