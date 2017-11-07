/*

Title:- AUTOMATED HOSPITAL MANAGEMENT SYSTEM

Team Members:- Mahir Jain (16CO123) AND Suraj Singh (16CO146)

Abstract:- 
The project implements an emergency room scenario in a hospital. Different patients suffering from varying degree of medical issues are brought for treatment. Following a straight-forward queue is not sufficient. Hence the system created assigns an ID and a priority to a patient (Inputs). When the doctor is ready to receive another patient, the highest priority patient is sent for treatment, with the ID and priority displayed (Outputs). An additional output of the number of patients is also given, to ensure the room does not exceed capacity. This can easily be extended to a larger scale system, with more doctors and patients. The system will help in easing decision making, and make the entire process more efficient.

Functionalities:- 
The system is capable of:-
1. Checking if room is full or not, and accordingly allowing an input to take place
2. Storing the patient information, including ID and Priority.
3. Updating automatically the number of patients/availability status.
4. Deciding which patient next gets the treatment from the doctor.
 
*/



//Module to implement main logic- that of the priority queue

// This is a behavioral module. It utilises registers to store the input, and upon being sent signal for dequeue, produces the required output by observing the priority bits that have been assigned.
module VerilogBM_123_146(in,
			clk, //Clock signal
			out, //Output information/details of patient who is sent for treatment.
			ende, //enqueue(0)/dequeue(1)-Control input given by user. 
			counter //Keeps track of number of patients. 
			   );  //ADD FLAGS FOR FULL AND EMPTY CHECK IN THESE ()
	//DECLARATION
	parameter size = 15;	//Capacity of the queue.
 
	reg [3:0] arr[15:0]; //Array to store of length "size" to store four 4 bit values 

	reg [1:0] priority_array[15:0]; //Array to store each patients priority.

	input  [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.

	input clk;	//Clock input

	input ende;	//Flag , 0- Enqueue, 1-Dequeue

	output reg  [3:0]out,counter ;	//4 bit output corresponding to the 4 bit input.

	reg [3:0] tmp; //temporary variable to swap front of queue with element with highest priority

	reg [1:0] tmp_priority;	// Temporary variable to hold priority.

	output reg isfull;	//Flag to check if the room is full/has reached capacity. 

	output reg isempty;	//Flag to check if the room is empty.

	integer i,count;		//Variable that keeps count of the number of patients presently in the room.

	//INITIAL
	initial 
	begin

	count<=0; //Number of patients is 0 initially.

	end

	//ALWAYS
	always@ (posedge clk)
	begin
		if(ende == 0) //inexpensive enqueue
		begin
			arr[count] <= in;	//Stores value in a serial-shift-register
			priority_array[count] <= in[3:2];  //Storing priority in register.
			count = count + 1;	//Updating count of patients.
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
			out =  arr[0]; //Removing from front of the queue.
			count = count - 1;	//Updating patient count.
		end
		assign counter = count; 

	end

endmodule
