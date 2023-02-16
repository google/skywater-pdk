module mult_seq #(parameter WIDTH=16)
   (a, b, clk, reset, en, sum_q);

   output logic [2*WIDTH-1:0] sum_q;

   input logic [WIDTH-1:0]    a;
   input logic [WIDTH-1:0]    b;
   input logic		      clk;   
   input logic 		      reset;
   input logic 		      en;   
   
   logic [2*WIDTH-1:0] 	      p;
   logic [2*WIDTH-1:0] 	      sum;

   assign p = a*b;
   adder #(2*WIDTH) add1 (p, sum_q, sum);
   flopenr #(2*WIDTH) reg1 (clk, reset, en, sum, sum_q);

endmodule // mult_seq
