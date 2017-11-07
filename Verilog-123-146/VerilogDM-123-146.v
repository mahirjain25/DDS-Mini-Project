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

// This is a dataflow module. It utilises registers to store the input, and upon being sent signal for dequeue, produces the required output by observing the priority bits that have been assigned.



//Module to create a D-flip-flop for storing 2 bits.

module DFF(clk,en,d,q);
	input clk,	//Clock pulse
	      en;	//Enable input	
	input [1:0]d;	// D-input
	output reg [1:0]q;	//Output Q of the flip flop.
	always@(posedge clk or en)
	if(en)
	begin
			q <= d;
	end
endmodule

//Module to create a Serial in Serial out Shift Register, using D flip flops.

module siso(clk,en,in,t4,t1,t2,t3);
	input clk,	//Clock Pulse
	      en;	//Enable
        input [1:0]in;	
	inout [1:0]d1,d2,d3,d4;
	output reg [1:0]t1,t2,t3,t4;
	DFF done(clk,en,in,d1);
	DFF dtwo(clk,en,d1,d2);
	DFF dthree(clk,en,d2,d3);
	DFF dfour(clk,en,d3,d4);
	always @(posedge clk)
	begin
		if(en)
		begin
			
	 	 		t1  <= d1;
			
	  			t2  <= d2;
			
	  			t3  <= d3;

				t4  <= d4;
		
		end
		else
		begin
			
	 	 		t1  <= t1;
			
	  			t2  <= t2;
			
	  			t3  <= t3;

				t4  <= t4;
		
		end
	end

endmodule


//This demux helps in identifying which queue will be enabled, and implements the choosing of priority logic.
module demux(in, select, o1,o2,o3,o4);
	input [1:0]in, select;
	output reg [1:0] o1,o2,o3,o4;
	always@(in or select)
	begin
		if(!select[1] && !select[0])
		begin
			o1 = in;
			o2 = 2'b00;
			o3 = 2'b00;
			o4 = 2'b00;
		end
		else if(!select[1] && select[0])
		begin
			o1 = 2'b00;
			o2 = in;
			o3 = 2'b00;
			o4 = 2'b00;
		end	
		else if(select[1] && !select[0])
		begin
			o1 = 2'b00;
			o2 = 2'b00;
			o3 = in;
			o4 = 2'b00;
		end
		else if(select[1] && select[0])
		begin
			o1 = 2'b00;
			o2 = 2'b00;
			o3 = 2'b00;
			o4 = in;
		end
	end
endmodule



//Main module- Implements the entire priority logic.


module VerilogDM_123_146(            in, // Input information containing ID and priority.  
			clk, //Clock signal
			out, //Output information/details of patient who is sent for treatment.
			ende, //enqueue(0)/dequeue(1)-Control input given by user.
			counter // Number of patients. 
			   );
	//DECLARATION OF INPUTS AND OUTPUTS IN THE MODULE.
	parameter size = 15;	//Capacity of the queue.

	output reg [3:0]counter;
 
	reg [3:0] arr[15:0]; //Array to store of length "size" to store four 4 bit values 

	reg [1:0] priority_array[15:0]; //Array to store each patients priority.

	input  [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.

	input clk;	//Clock input

	input ende;	//Control Signal , 0- Enqueue, 1-Dequeue

	reg [3:0]enable;	//Helps enable one of four registers for dequeue

	output reg  [3:0]out;	//4 bit output corresponding to the 4 bit input.

	reg [3:0] tmp; //temporary variable to swap front of queue with element with highest priority

	reg [1:0] tmp_priority;	// Temporary variable to hold priority.

	output reg isfull;	//Flag to check if the room is full/has reached capacity. 

	output reg isempty;	//Flag to check if the room is empty.

	integer count;		//Variable that keeps count of the number of patients presently in the room.

	wire [1:0] s1,s2,s3,s4;

	integer c1,c2,c3,c4;		//Keeping track of count in each priority. Used internally.

	reg [1:0] c11,c22,c33,c44;	//registers keeping track of each queue's counter.

	wire [1:0] t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16; //Temporary outputs from flip flops.

	reg [3:0] out1,out2,out3,out4; //Temporary ID outputs.

	//Instantiate DEMUX.

	demux M1(in[1:0],in[3:2], s1,s2,s3,s4);

	//Creating 4 Serial in Serial Out registers
	

	siso srzero(clk,enable[3],in[1:0],t4,t1,t2,t3);

        siso srone(clk,enable[2],in[1:0],t8,t5,t6,t7);

	siso srtwo(clk,enable[1],in[1:0],t12,t9,t10,t11);

	siso srthree(clk,enable[0],in[1:0],t16,t13,t14,t15);

        initial 
	begin
	//Number of patients is 0 initially
	c1<=0; 
	c2<=0;
	c3<=0;
	c4<=0;
	count<=0;
	end
	
		
	always @(posedge clk)
	begin
	if(s1)	//00 priority logic
	begin
		if(!ende)
		begin
			count = count + 1;
			c1 = c1+1;
			enable = 4'b1000;
			assign c11 = c1;
		end
		else
		begin
			enable = 4'b1000;
			if(~c11[1] & c11[0])
			begin
				out1[3] = 0;
				out1[2] = 0;
				out1[1:0] = t1;
			end
			else if(c11[1] & ~c11[0])
			begin
				out1[3:2] = 2'b00;
				out1[1:0] = t2;
			
			end	
			else if(c11[1] & c11[0])
			begin
				out1[3:2] = 2'b00;
				out1[1:0] = t3;
			
			end

		end
	end

	else if(s2)	//01 priority logic
	begin
		if(~ende)
		begin
			c2 = c2+1;
			count = count +1;
			enable = 4'b0100;
			assign c22 = c2;
		end
		else
		begin
			enable = 4'b0100;
			if(~c22[1] & c22[0])
			begin
				out2[3:2] = 2'b01;
				out2[1:0] = t5;
				 
			end
			else if(c22[1] & ~c22[0])
			begin
				out2[3:2] = 2'b01;
				out2[1:0] = t6;
			
			end	
			else if(c22[1] & c22[0])
			begin
				out2[3:2] = 2'b01;
				out2[1:0] = t7;
			
			end

		end

	end

	else if(s3)	//10 priority logic
	begin
		if(~ende)
		begin
			c3 = c3+1;
			count = count + 1;
			enable = 4'b0010;
			assign c33 = c3;
		end
		else
			begin
			enable = 4'b0010;
			if(~c33[1] && c33[0])
			begin
				out3[3:2] = 2'b10;
				out3[1:0] = t9;
				 
			end
			else if(c33[1] && ~c33[0])
			begin
				out3[3:2] = 2'b10;
				out3[1:0] = t10;
			
			end	
			else if(c33[1] && c33[0])
			begin
				out3[3:2] = 2'b10;
				out3[1:0] = t11;
			
			end

		end

	end

	else if(s4)
	begin
		if(~ende)
		begin
			c4 = c4+1;
			count = count + 1;
			enable = 4'b0001;
			assign c44 = c4;
		end
		else
		begin
			enable = 4'b0001;
			if(~c44[1] && c44[0])
			begin
				out4[3:2] = 2'b11;
				out4[1:0] = t13;
				 
			end
			else if(c44[1] && ~c44[0])
			begin
				out4[3:2] = 2'b11;
				out4[1:0] = t14;
			
			end	
			else if(c44[1] && c44[0])
			begin
				out4[3:2] = 2'b11;
				out4[1:0] = t15;
			
			end

		end

	end

	if(ende)	//Dequeue
	begin
		count = count - 1;
		if(c4>0)
		begin
			out = out4;
		end
		
		else if(c3>0)
		begin
			out = out3;
		end

		else if(c2>0)
		begin
			out = out2;
		end

		else if(c1>0)
		begin

			out = out1;
		end
	end
	assign counter = count;	//Update counter
	end



endmodule
