// Example counter for synthesis
module counter(clk,rst,count);
   
   input logic        clk;
   input logic 	      rst;
   output logic [7:0] count;
   
   always@(posedge clk or negedge rst)
     begin
	if(!rst)
	  count=0;
	else
	  count=count+1;
     end
   
endmodule

