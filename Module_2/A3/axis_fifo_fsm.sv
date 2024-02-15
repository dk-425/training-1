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

  integer read_idx, write_idx;
  reg flag=0;

  enum reg {
         RDATA,
         WDATA
       } present, next;

  always_ff @(posedge clk)
  begin
    if (rst)
    begin
      present <= RDATA;
    end
    else
    begin
      present <= next;
    end
  end

  always_comb
  begin
    case(present)
      RDATA:
      begin
        if (s_tlast)
          next = WDATA;
        else
          next = RDATA;
      end
      WDATA:
      begin
        if (write_idx==4095)
          next = RDATA;
        else
          next = WDATA;
      end

    endcase
  end

  always @(posedge clk)
  begin
    case(present)
      RDATA:
      begin
        if (rst)
        begin
          m_tdata <= 0;
          m_tvalid <= 0;
          m_tlast <= 1;
          s_tready <= 0;
          read_idx<=0;
          write_idx<=0;
        end
        else
        begin
        //  s_tready<=1;
          if (s_tvalid && s_tready && ~s_tlast)
          begin
            if (read_idx==4095)
            begin
              read_idx <=0;
              flag<=1;
              s_tready<=0;
            end

            else
            begin
              if (read_idx<2047)
                fifo1[read_idx] <= s_tdata;
              else
                fifo2[read_idx] <= s_tdata;
            end
            read_idx=read_idx+1;
          end

          else
          begin
             s_tready <=1;
          end
        end
      end

      WDATA:
      begin
        if (m_tready && flag)
        begin
          if (write_idx==4095)
          begin
            write_idx <=0;
            flag <=0;
            m_tlast <=1;
            m_tvalid <=0;
          end
          else
          begin
            m_tvalid<=1;
            if (write_idx<2047)
              m_tdata <= fifo1[write_idx];
            else
              m_tdata <= fifo2[write_idx];

          end
          write_idx <= write_idx+1;
        end
        else
        begin
          m_tvalid<=0;
        end
      end
    endcase

  end

endmodule
