module prioq(in,
			clk, 
			out, 
			ende, //enqueue/dequeue? 
			isfull,
			isempty);
	//DECLARATION
	parameter size = 15;	//Capacity of the queue. 
	output [3:0] arr[15:0]; //Array to of length "size" to store four 4 bit values 
	input  [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.
	input clk;	//Clock input
	inout ende;	//Flag , 0- Enqueue, 1-Dequeue
	output [3:0]out;	//4 bit output corresponding to the 4 bit input.
	reg [3:0] tmp; //temporary variable to swap front of queue with element with highest priority
	output reg isfull;	//Flag to check if the room is full/has reached capacity. 
	output reg isempty;	//Flag to check if the room is empty.
	integer count,i;		//Variable that keeps count of the number of patients presently in the room.

	//INITIAL
	initial 
	begin
	count<=0;
	end

	//ALWAYS
	always@ (posedge clk)
	begin
		if(ende == 0) //inexpensive enqueue
		begin
			arr[count] <= in;
			count = count + 1;
		end

		else if(ende == 1) //O(n) dequeue. Checking if there's an element with higher priority and swapping if there is 
		begin
			for(i=0;i<count;i=i+1)
				if([3:2]arr[i] > [3:2] arr[0]) //comparing priorities. If greater priority, swap.
				begin
					tmp <= [3:0] arr[i];
					arr[i]  <= [3:0] arr[0];
					[3:0] arr[0] <= tmp; 
				end
			out <= [3:0] arr[0];
		end

	end

endmodule
