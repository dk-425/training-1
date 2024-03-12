
module fp_mul_tb;

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
  wire sign;
  fp_mul # (
    .i1(i1),
    .f1(f1),

    .i2(i2),
    .f2(f2),
 
    .i3(i3),
    .f3(f3)
  )
  fp_mul_inst (
    .a(a),
        .s1(s1),
    .b(b),
       .s2(s2),
       .sign(sign),
    .c(c),
    .overflow(overflow),
    .underflow(underflow)
  );

//always #5  clk = ! clk ;
reg sres;
integer file;
real rand_num, ref_A, ref_B, ref_C_mul, error_mul, error_mul_abs;
real ref_a,ref_b,ref_c;
  
initial begin

file = $fopen("out_fp.csv", "w");
  for (integer i = 0; i < 100; i++) begin
  if (file == 0) begin
              $stop("Error in Opening file !!");
          end
  else begin        
  s1=$urandom;
  s2=$urandom;
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

        ref_C_mul = ref_A * ref_B;
  

        a = $rtoi(ref_A * (2 ** f1));
        b = $rtoi(ref_B * (2 ** f2));
        #1
        if(s1) ref_a=$signed(a);
        else ref_a=a;
        if(s2) ref_b=$signed(b);
        else ref_b=b;
        
        if (sign)ref_c = $signed(c);
        else ref_c = c;
        
        error_mul = ref_C_mul - real'(ref_c/2.0**f3);
    
        

        if(error_mul < 0) begin
            error_mul_abs = -error_mul;
        end else begin
            error_mul_abs = error_mul;
        end            
        
        $fdisplay(file,"a_ref = %f, b_ref = %f, c_ref = %f, a = %f, b = %f, c = %f", ref_A, ref_B, ref_C_mul, (real'(ref_a)/2**14), real'(ref_b/2**14), real'(ref_c/2**14));
           
        if(error_mul_abs > 1e-3) begin
            if (overflow) $fdisplay(file,"-----overflow has occured!-----");
        else begin
             $fdisplay(file,"~~~~~output mismatch~~~~~. error = %f", error_mul_abs);          
        end
        end
        else begin
        if (overflow) $fdisplay(file,"-----overflow has occured!-----");
        else $fdisplay(file,"success. precision=%f",error_mul);
        end
      end  
      
end
  $fclose(file);
end

/* generates a real value between min and max */
function automatic real rand_float (input real min, max);
    integer unsigned rand_num;
    rand_num = $urandom();
    rand_float = min + (max-min) * (real'(rand_num)/32'hffffffff);
        $display("%f %f %f %f %f", min, max, max-min, (real'(rand_num)/32'hffffffff), rand_float);
endfunction

function real fp_range_min (input integer i, f);
    /* -2.0 ** (i-1) will not work as (-2) ^ 0 = 1 */
    fp_range_min = -1 * (2.0**(i-1));
endfunction

function real fp_range_max (input integer i, f);
    fp_range_max = 2.0**(i-1) - 2.0**(-f);
endfunction

function real fp_urange_max (input integer i, f);
    fp_urange_max =  2**i - 2.0**(-f);
endfunction






endmodule