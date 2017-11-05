
`timescale 1ns/10ps

module test_circuit;

reg [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.
reg clk;	//Clock input
reg ende;	//Flag , 0- Enqueue, 1-Dequeue
wire [3:0]out;	//4 bit output corresponding to the 4 bit input.

prioq p1(in,clk,out,ende);

initial
begin
clk <= 0;
end
initial 
begin
	$dumpfile("test.vcd");
	$dumpvars(0, test_circuit);
	//Initialise inputs
	ende <= 0;
	in <= 4'b1111;
	#5;
	clk <= ~clk;
	#5;
	in <= 4'b1010;
	clk <= ~clk;
	#5;
	clk <= ~clk;
	#5;
	ende <= 1'b1;
	clk <= ~clk;
	#5;
	$finish;
end
initial 
begin
	$monitor("Time:- %t, Ende:- %b, in:- %b, out:- %b",$time,ende,in,out);
end
endmodule
