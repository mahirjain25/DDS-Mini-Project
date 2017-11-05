module prioq(in,
			clk, 
			out, 
			ende //enqueue/dequeue? 
			   );  //ADD FLAGS FOR FULL AND EMPTY CHECK IN THESE ()
	//DECLARATION
	parameter size = 15;	//Capacity of the queue. 
	reg [3:0] arr[15:0]; //Array to store of length "size" to store four 4 bit values 
	reg [1:0] priority_array[15:0]; //Array to store each patients priority.
	input  [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.
	input clk;	//Clock input
	input ende;	//Flag , 0- Enqueue, 1-Dequeue
	output reg  [3:0]out;	//4 bit output corresponding to the 4 bit input.
	reg [3:0] tmp; //temporary variable to swap front of queue with element with highest priority
	reg [1:0] tmp_priority;	// Temporary variable to hold priority.
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
			priority_array[count] <= in[3:2];
			count = count + 1;
		end

		else if(ende == 1) //O(n) dequeue. Checking if there's an element with higher priority and swapping if there is 
		begin
			for(i=0;i<count;i=i+1)
			begin
				if(priority_array[i] > priority_array[0]) //comparing priorities. If greater priority, swap.
				begin
					tmp =  arr[i];
					tmp_priority = priority_array[i];
					arr[i]  =  arr[0];
					priority_array[i]  =  priority_array[0];
					arr[0] = tmp;
					priority_array[0] = tmp_priority; 
				end
			end
			out =  arr[0];
			count = count - 1;
		end

	end

endmodule
