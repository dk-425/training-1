`timescale 1ns / 1ps

module axis_fifo #(

    parameter DW = 8,
    parameter DD = 2048)(

      input   logic               clk,
      input   logic               rst,

      input   logic [DW-1   :0]   s_tdata,
      input   logic               s_tvalid,
      input   logic               s_tlast,
      output  logic               s_tready,

      output  logic [DW-1   :0]   m_tdata,
      output  logic               m_tvalid,
      output  logic               m_tlast,
      input   logic               m_tready
    );

  logic [DW-1 :0] fifo1 [DD-1 :0];
  logic [DW-1 :0] fifo2 [DD-1 :0];

  integer fifo1_raddr, fifo1_waddr,fifo2_raddr, fifo2_waddr,read_idx,write_idx,i;
  reg fifo1_en,fifo2_en,fifo1_ren,fifo2_wen,fifo1_wen,fifo2_ren;
  //reg flag=0;

  generate
    if(DD == 2048)
    begin
      initial
      begin
        for(i = 0; i < DD; i = i + 1)
        begin
          fifo1[i] = 0;
          fifo2[i] = 0;
        end
      end
    end
  endgenerate

  always @(posedge clk)
  begin
    if (rst)
    begin
      m_tdata <= 0;
      m_tvalid <= 0;
      m_tlast <= 1;
      // s_tready <= 0;
      fifo1_raddr<=0;
      fifo1_waddr<=0;
      fifo2_raddr<=0;
      fifo2_waddr<=0;
    end
    else
    begin

      if (s_tvalid && s_tready && ~s_tlast)
      begin
        if (read_idx==4095)
        begin
          read_idx <=0;
        //  flag<=1;
          //  s_tready<=0;
        end

        else
        begin
          //  s_tready<=1;
          if (read_idx<2048)
          begin
            fifo1_waddr <= read_idx;
            fifo1_en=1;
            fifo1_wen=1;
          end
          else
          begin
            fifo2_waddr <= read_idx-2048;
            fifo2_en=1;
            fifo2_wen=1;
          end
          read_idx=read_idx+1;
        end

      end

      else
      begin
        // s_tready <=1;
      end
    end

  end

  always @(posedge clk)
  begin
    if (rst)
      s_tready <=0;
    else
      s_tready <=1;
  end

  always @(posedge clk)
  begin
    if (m_tready)
    begin
      if (write_idx==4095)
      begin
        write_idx <=0;
       // flag <=0;
        m_tlast <=1;
        m_tvalid <=0;
      end
      else
      begin
        m_tvalid<=1;
        write_idx <= write_idx+1;

        if (write_idx<2047) begin
        fifo1_raddr <= write_idx;
        fifo1_ren <=1;
        end

        else begin
          fifo2_raddr <= write_idx-2048;
          fifo2_ren <=1;
        end

      end
    end
    else
    begin
      m_tvalid<=0;
    end
  end

  always @(posedge clk)
  begin
    //! writing into the bram.
    if (fifo1_en)
    begin
      if (fifo1_wen)
        fifo1[fifo1_waddr] <= s_tdata;
    end

    //! reading from the bram
    if(fifo1_ren)
    begin
      m_tdata <= fifo1[fifo1_raddr];
    end

    if (fifo2_en)
    begin
      if (fifo2_wen)
        fifo2[fifo1_waddr] <= s_tdata;
    end

    //! reading from the bram
    if(fifo2_ren)
    begin
      m_tdata <= fifo2[fifo2_raddr];
    end
  end

  //assign s_tready = (rst && flag) ? 0:1;

endmodule
