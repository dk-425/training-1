`timescale 1ns / 1ps

module axis_fifo_tb;

  // Parameters
  localparam  DW = 16;
  localparam  DD = 2048;
  localparam AW = 12;

  //Ports
  logic  clk;
  logic  rst;
  logic [DW-1   :0] s_tdata='d0,s_tdata_i;
  logic  s_tvalid=0;
  logic  s_tlast=0;//,s_tlast_i;
  logic  s_tready;
  logic [DW-1   :0] m_tdata;
  logic  m_tvalid;
  logic  m_tlast;
  logic  m_tready=0;
  logic full,empty;

  axis_fifo_top # (
              .DW(DW),
              .DD(DD),
              .AW(AW)
            )
            axis_fifo_inst (
              .clk(clk),
              .rst(rst),
              .s_tdata(s_tdata),
              .s_tvalid(s_tvalid),
              .s_tlast(s_tlast),
              .s_tready(s_tready),
              .m_tdata(m_tdata),
              .m_tvalid(m_tvalid),
              .m_tlast(m_tlast),
              .m_tready(m_tready)
            );


  always #5  clk = ! clk ;

  initial
  begin
    clk=1;
    rst=1;
    reset;
    #20
     fork
       begin

         axis_write(3000);
       end
       //    begin
       //    axis_read;
       //    end
     join

     #10 
     axis_read;

     $stop();

  end
   initial begin
     #3000
     m_tready=1;
     #40480
      m_tready=0;
     end 

  integer file,file2,file3;

task automatic reset;
    begin
    repeat (3) @(posedge clk);
      rst = ~rst;
    end
  endtask

  task automatic axis_write(input [12:0] n);
    file = $fopen("map_out.csv", "r");
    repeat (n)
    begin
      if (file == 0)
      begin
        $stop("Error in Opening file !!");
      end
      else
      begin
        @(posedge clk);
        $fscanf(file,"%d,%b",s_tdata,s_tlast);
        s_tvalid<=1;
        $display("%d,%b\n",s_tdata,s_tlast);
      end
      //$display("%d\n",s_tdata);
    end
    s_tvalid<=0;
    $fclose(file);
  endtask

  task automatic axis_read;
  file3 = $fopen("zc_fd_in.csv", "r");
  file2 = $fopen("output_tb.csv", "w");
   begin
          if (file3 == 0) begin
              $stop("Error in Opening file !!");
          end
          else if (file2 == 0) begin
            $stop("Error in Opening file !!");
        end
          else begin
          while (m_tvalid) begin
          @(posedge clk);
          $fscanf(file3,"%d",s_tdata_i);
          if (m_tdata==s_tdata_i)
          $fdisplay(file2,"pass, %d",m_tdata);
          else $fdisplay(file2,"fail, %d",m_tdata);
          end
          end
          
    end

  $fclose(file3);
  $fclose(file2);
  endtask

endmodule





