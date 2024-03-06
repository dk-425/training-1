`timescale 1ns / 1ps
//Uses 8 LUT and 10 FF
module mux_2_1 #(parameter DW = 8)(

    input   logic               clk,
    input   logic               rst,

    input   logic               sel,

    input   logic [DW-1   :0]   s1_tdata,
    input   logic               s1_tvalid,
    input   logic               s1_tlast,
    output  logic               s1_tready,

    input   logic [DW-1   :0]   s2_tdata,
    input   logic               s2_tvalid,
    input   logic               s2_tlast,
    output  logic               s2_tready,

    output  logic [DW-1   :0]   m_tdata,
    output  logic               m_tvalid,
    output  logic               m_tlast,
    input   logic               m_tready
  );


  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tdata <= 0;
      m_tvalid <=0;
      m_tlast <=0;
    end
    else
    begin
      if(sel)                                                //!sel?s1:s2
      begin
        if (s1_tvalid && s1_tready)
        begin
          m_tdata <= s1_tdata;
          m_tvalid <= 1;
          m_tlast <= s1_tlast;
        end
        else
        begin
          m_tvalid<=0;
        end

      end
      else
      begin
        if (s2_tvalid && s2_tready)
        begin
          m_tdata <= s2_tdata;
          m_tvalid <= 1;
          m_tlast <= s2_tlast;
        end
        else
        begin
          m_tvalid <= 0;

        end
      end
    end
  end

  always @(posedge clk)
  begin
    if (rst)
    begin
      s1_tready<=0;
      s2_tready<=0;
    end
    else
    begin
      s1_tready<=sel && m_tready;
      s2_tready<=~sel && m_tready;
    end
  end


endmodule


////////////////////////////////////////////////

/*`timescale 1ns / 1ps
//11 LUT and 10 FF
module mux_2_1 #(parameter DW = 8)(

    input   logic               clk,
    input   logic               rst,

    input   logic               sel,

    input   logic [DW-1   :0]   s1_tdata,
    input   logic               s1_tvalid,
    input   logic               s1_tlast,
    output  logic               s1_tready,

    input   logic [DW-1   :0]   s2_tdata,
    input   logic               s2_tvalid,
    input   logic               s2_tlast,
    output  logic               s2_tready,

    output  logic [DW-1   :0]   m_tdata,
    output  logic               m_tvalid,
    output  logic               m_tlast,
    input   logic               m_tready
  );



  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tdata <= 0;
      m_tvalid <=0;
      m_tlast <=0;
    end
    else
    begin

        if (sel && s1_tvalid && s1_tready)
        begin
          m_tdata <= s1_tdata;
          m_tvalid <= s1_tvalid;
          m_tlast <= s1_tlast;
        end
    
      
      else if (~sel && s2_tvalid && s2_tready)
        begin
          m_tdata <= s2_tdata;
          m_tvalid <= s2_tvalid;
          m_tlast <= s2_tlast;
        end
        
      else
        begin
          m_tvalid <= 0;
          m_tdata <= m_tdata;
          m_tlast <=m_tlast;
        end
      end
    end
  

  assign s1_tready=rst?0: (sel && m_tready);
  assign s2_tready=rst?0: (~sel && m_tready);
  
endmodule
*/






