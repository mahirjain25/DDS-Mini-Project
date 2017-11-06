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