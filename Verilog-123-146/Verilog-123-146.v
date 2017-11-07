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

`timescale 1ns/10ps

//This is the testbench for the project. It is common to both Behavioral and Dataflow models.
//It will demonstrate the sequence in which patients receive treatment. The output can be viewed on terminal or as a waveform in GTKWave.



module Verilog_123_146;

reg [3:0]in;	//4 bit input, with 2 bits representing priority, and 2 bits representing Unique ID.
reg clk;	//Clock input
reg ende;	//Flag , 0- Enqueue, 1-Dequeue
wire [3:0]out,counter;	//4 bit output corresponding to the 4 bit input.

VerilogBM_123_146 p1(in,clk,out,ende,counter); //Initiating module to implement the logic.//
//VerilogDM_123_146 p1(in,clk,out,ende,counter); //Initiating module to implement the logic.
//Setting up clock pulse

initial
begin
clk <= 0;
end
always #5 clk = ~clk;

//Providing stimulus to circuit
initial 
begin
	$dumpfile("VerilogBM-123-146.vcd");
	$dumpvars(0, Verilog_123_146);
	//Initialise inputs
	ende <= 0;
	in <= 4'b0011; //Enqueue Priority-00 ID-11
	#10;
	in <= 4'b1010; //Enqueue Priority-10 ID-10
	#10;
	ende <= 1'b1;  //Dequeue requested
	#10;
	ende <= 0;     //Enqueue a patient
	in <= 4'b1101; //Enqueue Priority-11 ID-01
	#10;
	ende <= 1'b1;  //Dequeue requested
	#10;
	$finish;       //Stop simulation
end
initial 
begin
	//Displaying relevant outputs on the terminal/bash.
	$monitor("Time:- %t, Ende:- %b, In:- %b, Out:- %b, Number of patients:- %b",$time,ende,in,out,counter);
end
endmodule
