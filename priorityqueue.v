module prioq(in,
			clk, 
			out, 
			ende, //enqueue/dequeue? 
			isfull,
			isempty);
	//DECLARATION
	parameter size = 5;
	wire [3:0] arr [size:0]; //Array to of length "size" to store four 4 bit values 
	input  [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.
	input clk;	//Clock input
	output [3:0]out;	//4 bit output corresponding to the 4 bit input.
	reg [3:0] tmp; //temporary variable to swap front of queue with element with highest priority
	output reg isfull;	//Flag to check if the room is full/has reached capacity. 
	output reg isempty;	//Flag to check if the room is empty.
	integer count;		//Variable that keeps count of the number of patients presently in the room.

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
			arr[count-1] <= in;
		end

		else if(ende ==1) //O(n) dequeue. Checking if there's an element with higher priority and swapping if there is 
		begin
			for(i=0;i<count;i=i+1)
			begin
				if(arr[i][4:3] > arr[0][4:3]) //comparing priorities. If greater priority, swap.
				begin
					tmp <= arr[i];
					arr[i]  <= arr[0];
					arr[0] <= tmp; 
				end
			end
			out <= arr[0];
		end

	end

endmodule
