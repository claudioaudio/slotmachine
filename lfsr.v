/***********Linear Shifted Feedback Register**************
Description: Verilog-Code of an 4-Bit Shift register, with 
an variable AND-Value. The variable AND-Value allows the 
user to parameterize the position of the XOR-gates.	
*********************************************************/
module lfsr(
clk,
reset,
enable,
lfsr_out
);
//Declare input and output ports
input clk;
input reset;
input enable;
output [3:0] lfsr_out;

//Declare the parameters
parameter	and_val = 4'b1100;
parameter	reset_val = 4'b0000;

reg [3:0] lfsr_out = reset_val;

wire linear_feedback;
//Feedback-Line of the Shift-Register
assign linear_feedback = !((lfsr_out[3] & and_val[3]) ^
						   (lfsr_out[2] & and_val[2]) ^
						   (lfsr_out[1] & and_val[1]) ^
						   (lfsr_out[0] & and_val[0]));

//Shift-process of the Feedback Register
always @ (posedge clk or negedge reset)
begin: LFSR_INTERN
	if(reset == 0) begin
		lfsr_out <= reset_val;
	end
	else if (enable == 1) begin
		lfsr_out <= {lfsr_out[2], lfsr_out[1], lfsr_out[0], linear_feedback};
	end
	else begin
		lfsr_out <= lfsr_out;
	end
end



endmodule
	
