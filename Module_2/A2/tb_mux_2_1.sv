`timescale 1ns / 1ps

module mux_2_1_tb;

  // Parameters
  localparam  DW = 8;

  //Ports
  reg  clk;
  reg  rst;
  reg  sel;
  reg [DW-1   :0] s1_tdata='d0;
  reg  s1_tvalid=0;
  reg  s1_tlast=0;
  wire  s1_tready;
  reg [DW-1   :0] s2_tdata='d0;
  reg  s2_tvalid=0;
  reg  s2_tlast=0;
  wire  s2_tready;
  wire [DW-1   :0] m_tdata;
  wire  m_tvalid;
  wire  m_tlast;
  reg  m_tready=0;

  mux_2_1 # (
    .DW(DW)
  )
  mux_2_1_inst (
    .clk(clk),
    .rst(rst),
    .sel(sel),
    .s1_tdata(s1_tdata),
    .s1_tvalid(s1_tvalid),
    .s1_tlast(s1_tlast),
    .s1_tready(s1_tready),
    .s2_tdata(s2_tdata),
    .s2_tvalid(s2_tvalid),
    .s2_tlast(s2_tlast),
    .s2_tready(s2_tready),
    .m_tdata(m_tdata),
    .m_tvalid(m_tvalid),
    .m_tlast(m_tlast),
    .m_tready(m_tready)
  );

always #5  clk = ! clk ;

integer i=0;

  initial
  begin
    clk=1;
    rst=1;
    #10
    m_tready=1;
    s1_tlast=0;
    s2_tlast=0;
    #11
     reset;
    s1_tvalid=1;
    s2_tvalid=1;
    stimuli(9);
    #10
    s1_tvalid=0;
    s2_tvalid=0;
    stimuli(4);
    #10
     reset;
    s1_tvalid=1;
    s2_tvalid=1;
    stimuli(5);
    #10
    s1_tlast=1;
     s1_tvalid=1;
     s2_tlast=1;
     s2_tvalid=1;
     stimuli(5);
    #10
     $stop();
  end

  task automatic reset;
    begin
      rst = ~rst;
    end
  endtask

  task automatic stimuli(input [5:0] n);
    begin
      for (i=0;i<n;i=i+1)
      begin
      #10;
        s1_tdata=$urandom;
        s2_tdata=$urandom;
      end

    end
  endtask
 
   initial begin
    sel=0;
    #40
    sel=1;
    #40
    sel=0;
    #50
    sel=1;
    #60
    sel=0;
   end
endmodule