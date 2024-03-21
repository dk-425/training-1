module fsm_tkeep #(
    parameter DW = 16,
    parameter KW = 8
  )(

    input clk,
    input rst,

    input s_tvalid,
    input [DW-1 :0] s_tdata,
    input s_tlast,
    input [KW-1 :0] s_tkeep,
    output s_tready,

    output m_tvalid,
    output [DW-1 :0] m_tdata,
    output m_tlast,
    output [KW-1 :0] m_tkeep,
    input m_tready
  );

  logic [DW-1 :0] s_tdata_i,m_tdata_i,sum=0;


  enum logic [1:0]{
         RD_DATA,
         PROCESS_DATA ,
         WR_DATA
       }present,next;

  always@(posedge clock)
  begin
    if (rst)
      present <= RD_DATA ;
    else
      present <= next ;
  end
  always_comb
  begin
    case (present)
      RD_DATA :
      begin

        if(s_tvalid && s_tready)
          next = PROCESS_DATA ;
        else
          next = RD_DATA ;
      end

      PROCESS_DATA :
      begin

        if((sum>=16'd16) && (m_tready))
          next = WR_DATA ;
        else
          next = PROCESS_DATA;
      end

      WR_DATA :
      begin
        if(m_tvalid && m_tready)
          next = RD_DATA ;
        else
          next = WR_DATA ;
      end
      default :
        next = RD_DATA ;
    endcase
  end

  always @(posedge clk)
  begin

    case(present)
      RD_DATA:
      begin
        if (rst)
        begin
          s_tdata_i<=0;
          m_tdata_i<=0;
          sum<=0;
        end
        else
        begin
          if(s_tready && s_tvalid)
          begin
            rd_in_tdata <= s_tdata;
          end
        end
      end
      PROCESS_DATA :
      begin

        s_tdata_i<=s_tdata[s_tkeep-1:0];

        if (sum>=16)
          sum<=0;
        else
          sum<=sum+s_tkeep;

      end
      WR_DATA:
      begin

        if(m_tready)
        begin
          m_tdata <= s_tdata_i;
          m_tvalid<=1;
        end
        else
          m_tdata<=m_tdata;
        m_tvalid<=0;
      end
    endcase


  end
  always@(posedge clk)
  begin
    if (rst)
      s_tready<=0;
    else
      s_tready<=1;

  end


endmodule
