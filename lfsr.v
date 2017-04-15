/***********Linear Shifted Feedback Register**************
Description: Verilog-Code of an 4-Bit Shift register, with 
an variable AND-Value. The variable AND-Value allows the 
user to parameterize the position of the XOR-gates.	
*********************************************************/
module lfsr(
clk,
reset,
lfsr_out
);

parameter	lfsr_length = 15;

//Declare input and output ports
input clk;
input reset;
output [lfsr_length-1 : 0] lfsr_out;

//Declare the parameters
reg [lfsr_length-1 : 0] lfsr_out = 0;
wire linear_feedback;

//Feedback-Line of the Shift-Register
assign linear_feedback = !(lfsr_out[lfsr_length-1] ^ lfsr_out[lfsr_length-2] );

//Shift-process of the Feedback Register
always @ (posedge clk or negedge reset)
begin: LFSR_INTERN
	if(reset == 0) begin
		lfsr_out <= 0;
	end
	else begin
		lfsr_out[lfsr_length-1 : 1] <= lfsr_out[lfsr_length-2 : 0];
		lfsr_out[0] <= linear_feedback;
	end
end

endmodule
	
