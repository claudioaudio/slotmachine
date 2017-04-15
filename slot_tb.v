`include "slot_top.v"
module slot_tb();
// Declare inputs as regs and outputs as wires
reg clk, reset, start, stop;

wire [6:0] oSEG0;
wire [6:0] oSEG1;
wire [6:0] oSEG2;



// Initialize all variables
initial begin 
	$display ("time\t | clk | reset | start   | stop    |   led_out0  |   led_out1  |   led_out2  |");
	$monitor ("%g\t   | %b  |  %b   |   %b    |   %b    |   %b        |    %b       |    %b       |", 
		$time , clk, reset, start, stop, oSEG0, oSEG1, oSEG2);
		
		clk = 1;
		reset = 1;
		stop = 1;
		start = 1;
		#5 reset = 1;
		#100 reset = 0;
		#110 reset = 1;		
		#1020 start =0;
		#70 start = 1;
		#2000 stop = 0;
		#70 stop = 1;
		#50 reset = 0;
		#1 reset = 1;
		#50 reset = 0;
		#10 reset = 1;
		#1030 start = 0;
		#30 start = 1;
		#1000 stop = 0;
		#5 stop = 1;
		#10 start = 0;
		#10 start = 1;
		#1000 stop = 0;
		#10 stop = 1;
end

always begin
	 #5 clk = ~clk; // Toggle clock every 5 ticks
end


slot_top dut(
	.clk 		(clk),
	.reset 		(reset),
	.start 		(start),
	.stop 		(stop),
	.oSEG0 	(oSEG0),
	.oSEG1 	(oSEG1),
	.oSEG2 	(oSEG2)
);

endmodule
