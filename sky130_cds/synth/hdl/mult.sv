module mult #(parameter WIDTH=32)
   (a, b, p);

   input logic [WIDTH-1:0]    a;
   input logic [WIDTH-1:0]    b;
   output logic [2*WIDTH-1:0] p;

   assign p = a*b;

endmodule // mult

   