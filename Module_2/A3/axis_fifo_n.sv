`timescale 1ns / 1ps

module axis_fifo #(
    parameter AW = 12,
    parameter DW = 16,
    parameter DD = 2048)(

      input                  clk,
      input                  rst,

      input    [DW-1   :0]   s_tdata,
      input                  s_tvalid,
      input                  s_tlast,
      output                 s_tready,

      output   logic [DW-1   :0]   m_tdata,
      output   logic               m_tvalid,
      output                 m_tlast,
      input                  m_tready
    );

  logic [DW-1 :0] s_tdata_i;//,m_tdata_i;
  logic [DW-1 :0] s_tdata_1,s_tdata_2;
  logic [DW-1 :0] m_tdata_1,m_tdata_2;
  logic [AW:0] read_idx, write_idx;
  logic [AW-1:0] fifo1_r_idx, fifo1_w_idx, fifo2_r_idx, fifo2_w_idx;
  logic flag=0,enb1,enb2,wea1,wea2;
  logic m_tlast_i,s_tready_i;//,m_tvalid_i;
  logic fifo1_full,fifo2_full;


  always @(posedge clk)
  begin
    if (rst || flag)
      s_tready_i <=0;
    else
      s_tready_i <=1;
  end

  always @(posedge clk)
  begin
      if (rst)
        begin
         // m_tdata_i <= 0;
         // m_tvalid_i <= 0;
          m_tlast_i <= 0;
          read_idx<=0;
         write_idx<=0;
        end
      else
        begin

          if (s_tvalid && s_tready && ~s_tlast)
            begin
              if (read_idx==4097)
                begin
                  read_idx <=0;
                    flag<=1;
                    wea1<=0;
                    wea2<=0;
                    fifo1_r_idx<=0;
                    fifo2_r_idx<=0;
                end

              else
                begin

                  read_idx=read_idx+1;
                    if (read_idx<2049)
                      begin
                        wea1<=1;
                        wea2<=0;
                        fifo1_r_idx<=read_idx-1;
                        fifo2_r_idx<=0;
                        s_tdata_1<=s_tdata_i;
                      end
                    else
                      begin
                        wea2<=1;
                        wea1<=0;
                        fifo2_r_idx<=read_idx-2049;
                        fifo1_r_idx<=0;
                        s_tdata_2<=s_tdata_i;
                    end

                end
            end
      //      else begin
      //        wea1<=0;
      //        wea2<=0;
      //        read_idx<=0;
      //        fifo1_r_idx<=0;
      //        fifo2_r_idx<=0;
      //      end

      else if (m_tready && ~s_tvalid)
      begin
        if (write_idx==4098)
        begin
          write_idx <=0;
          flag <=0;
          m_tlast_i <=1;
        //  m_tvalid_i <=0;
          enb1 <=0;
          enb2 <=0;
          fifo2_w_idx<=0;
          fifo1_w_idx<=0;
        end
        else
        begin

          write_idx <= write_idx+1;
          if (write_idx<2049)
          begin
            enb1<=1;
            enb2<=0;
            // m_tdata_i<=m_tdata_1;
            // m_tvalid_i<=1;
            fifo1_w_idx<= write_idx;
            fifo2_w_idx<=0;
          end
          else
          begin
            enb2<=1;
            enb1<=0;
            // m_tdata_i<=m_tdata_2;
            // m_tvalid_i<=1;
            fifo2_w_idx <= write_idx-2049;
            fifo1_w_idx<=0;
          end

        end

      end

      else
      begin
     //   m_tvalid_i<=0;
        enb1<=0;
        enb2<=0;
        write_idx<=0;
        fifo2_w_idx<=0;
        fifo1_w_idx<=0;

        wea1<=0;
        wea2<=0;
        read_idx<=0;
        fifo1_r_idx<=0;
        fifo2_r_idx<=0;
      end
    end

  end

 // assign m_tvalid=m_tvalid_i;
  assign m_tlast=m_tlast_i;
 // assign m_tdata=m_tdata_i;
  assign s_tready=s_tready_i;

  bram #(
         .ADDR_WIDTH(AW),
         .DATA_WIDTH(DW)
       ) fifo_1(
         .clk(clk),
         .wea(wea1),
         .addra(fifo1_r_idx),
         .dina(s_tdata_1),
         .enb(enb1),
         .addrb(fifo1_w_idx),
         .doutb(m_tdata_1),
         .full(fifo1_full)
       );

  bram #(
         .ADDR_WIDTH(AW),
         .DATA_WIDTH(DW)
       ) fifo_2(
         .clk(clk),
         .wea(wea2),
         .addra(fifo2_r_idx),
         .dina(s_tdata_2),
         .enb(enb2),
         .addrb(fifo2_w_idx),
         .doutb(m_tdata_2),
         .full(fifo2_full)
       );

  assign s_tdata_i = s_tdata;


  always_comb begin
    if(enb1) begin
      m_tdata = m_tdata_1;
    end
    else if(enb2) begin
      m_tdata = m_tdata_2;
    end
  end

  always@(posedge clk) begin
    if(enb1 || enb2) begin
      m_tvalid <= 1;
      if(write_idx == 2049) begin
        m_tvalid <= 'd0;
      end
    end
    else m_tvalid<=0;

  end
endmodule
