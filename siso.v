//Serial In Serial Out left shift register
//Suraj Singh 16CO146
module DFF(clk,clear,d,q);
	input d,clear,clk;
	output reg q;
	always@(posedge clk)
	begin
		if(clear==1)
			q = 0;
	else
		q <= d;
	end
endmodule

module siso(clk,clear,in, out,d1,d2,d3);
	input clk, clear, in;
	output out;
	output   d1,d2,d3;
  wire t1,t2,t3;
	DFF M1(clk,clear,in,d1);
  assign t1  = d1;
	DFF M2(clk,clear,t1,d2);
  assign t2  = d2;
	DFF M3(clk, clear, t2, d3);
  assign t3  = d3;
	DFF M4(clk, clear, t3, out);

endmodule
