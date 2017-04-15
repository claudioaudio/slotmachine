`include "lfsr.v"
module lfsr_tb();
// Declare inputs as regs and outputs as wires
parameter lfsr_length = 10;

reg clk, reset, enable;

wire [lfsr_length-1:0] lfsr_out0;



// Initialize all variables
initial begin 
	$display ("time\t | clk | reset | lfsr_out0 ");
	$monitor ("%g\t   | %b  |  %b   |    %h     ", 
		$time , clk, reset, lfsr_out0,);
		
		clk = 1;
		reset = 0;
		enable = 1;
		#5 reset = 1;
		#100 reset = 0;
		#110 reset = 1;	
end

always begin
	 #5 clk = ~clk; // Toggle clock every 5 ticks
end

defparam  u0.lfsr_length = lfsr_length;

lfsr u0(
	.clk (clk),
	.reset (reset),
	.enable (enable),
	.lfsr_out (lfsr_out0)
);


endmodule
