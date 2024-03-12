`timescale 1ns / 1ps

module fp_add#(
parameter i1 = 2,
parameter f1 = 14,
//parameter s1=0,
parameter i2 = 2,
parameter f2 = 14,
//parameter s2 =0,
parameter i3 = 2,
parameter f3 = 14
)(
input [i1+f1-1 :0] a,
input s1,
input [i2+f2-1 :0] b,
input s2,
output [i3+f3-1 :0] c,
output reg overflow
//output reg underflow
);
localparam ideal_i=i1>i2?i1+1:i2+1;
localparam ideal_f=f1>f2?f1:f2;
localparam ideal_width=ideal_i+ideal_f;
localparam shift=ideal_f-f3;
reg [i3+f3-1 :0] c_ref;
reg [ideal_width-1 :0] ideal,ta,tb;    //3.14

wire sres;
reg overflow_may = ideal_i>i3;
reg underflow_may = ideal_f>f3;
assign sres = s1 || s2;
//reg signed [i1+f1-1] a_max = 2<<(i1-1)- 2>>f1;
always_comb begin
    if (sres) begin
        if (s1) ta = $signed(a);
        else ta = a;
        if (s2) tb = $signed(b);
        else tb = b;
        ideal=$signed(ta)+ $signed(tb);
        overflow=ideal[ideal_width-1-1];
        c_ref=$signed({s1&&s2,overflow?{{{i3+f3}{1'b1}}}:ideal[i3+f3-1:0]});
    //    underflow=tmp2[0];
    end
    else begin
        ideal=a+b;
       
         if(i3+f3>=ideal_width)
            overflow=0;
            else
            overflow =ideal[ideal_width - 1]? (~&ideal[ideal_width - 1 -: 1] == ideal[ideal_width - 1]):|ideal[ideal_width - 1:ideal_width -ideal_i+i3-1];
            
        c_ref=overflow?{{{i3+f3}{1'b1}}}:ideal[i3+f3-1:0];
      //  underflow = tmp1[0];
    end


end

assign c = c_ref;

endmodule








module fp_add_tb;

  // Parameters
  localparam  i1 = 2;
  localparam  f1 = 14;
 // localparam  s1 = 0;
  localparam  i2 = 2;
  localparam  f2 = 14;
 // localparam  s2 = 0;
  localparam  i3 = 2;
  localparam  f3 = 14;

  //Ports
  reg [i1+f1-1 :0] a;
  reg s1;
  reg [i2+f2-1 :0] b;
  reg s2;
  wire [i3+f3-1 :0] c;
  wire  overflow;
  wire  underflow;

  fp_add # (
    .i1(i1),
    .f1(f1),

    .i2(i2),
    .f2(f2),
 
    .i3(i3),
    .f3(f3)
  )
  fp_add_inst (
    .a(a),
        .s1(s1),
    .b(b),
       .s2(s2),
    .c(c),
    .overflow(overflow)
    //.underflow(underflow)
  );

//always #5  clk = ! clk ;
reg sres;
integer file;
real rand_num, ref_A, ref_B, ref_C_add, error_add, error_add_abs;

  
initial begin
//a=13107;
//s1=0;
//b=19661;
//s2=0;

file = $fopen("out_fp.csv", "w");
//a= 13107;
//s1=0;
//b=52429;
//s2=1;
  for (integer i = 0; i < 100; i++) begin
  if (file == 0) begin
              $stop("Error in Opening file !!");
          end
  else begin        
  s1=$urandom;
  s2=$urandom;
  sres = s1 || s2;
        if(s1) begin
            ref_A = rand_float(fp_range_min(i1, f1), fp_range_max(i1, f1));
        end else begin
            ref_A = rand_float(0, fp_urange_max(i1, f1));
        end   

        if(s2) begin
            ref_B = rand_float(fp_range_min(i2, f2), fp_range_max(i2, f2));
        end else begin
            ref_B = rand_float(0, fp_urange_max(i2, f2));
        end        

        ref_C_add = ref_A + ref_B;
  

        a = $rtoi(ref_A * (2 ** f1));
        b = $rtoi(ref_B * (2 ** f2));
    //    #10

        if(sres) begin
            error_add = ref_C_add - real'($signed(c)/2.0**f3);
        
        end else begin
            error_add = ref_C_add - real'(c/2.0**f3);
    
        end

        if(error_add < 0) begin
            error_add_abs = -error_add;
        end else begin
            error_add_abs = error_add;
        end            

        if(error_add_abs > 1e-3) begin
            $fdisplay(file,"%f %f %f %d %d %d", ref_A, ref_B, ref_C_add, real'(a/2**14), real'(b/2**14), real'(c/2**14));
            $fdisplay(file,"add out mismatch. error = %f", error_add_abs);
           
        end
        
      end  
      #10;
end
  $fclose(file);
end

/* generates a real value between min and max */
function automatic real rand_float (input real min, max);
    integer unsigned rand_num;
    rand_num = $urandom();
    rand_float = min + (max-min) * (real'(rand_num)/32'hffffffff);
//        $display("%f %f %f %f %f", min, max, max-min, (real'(rand_num)/32'hffffffff), rand_float);
endfunction

function real fp_range_min (input integer i, f);
    /* -2.0 ** (i-1) will not work as (-2) ^ 0 = 1 */
    fp_range_min = -1 * (2.0**(i-1));
endfunction

function real fp_range_max (input integer i, f);
    fp_range_max = 2.0**(i-1) - 2.0**(-f);
endfunction

function void fp_range (input integer i, f, output real min, max);
    min = -1 * 2**(i-1);
    max = 2**(i-1) - 2.0**(-f);
endfunction

function void fp_urange (input integer i, f, output real max);
    max =  2**i - 2.0**(-f);
endfunction

function real fp_urange_max (input integer i, f);
    fp_urange_max =  2**i - 2.0**(-f);
endfunction

function void fp_complex_mult(input real ar, ai, br, bi, output real pr, pi);
    pr = ar * br - ai * bi;
    pi = ai * br + ar * bi;
endfunction




endmodule