/*********************Slotmachine************************
Description: This Verilog-Code describes the Main-Core of
the Slotmachine. He contains a statemachine, an clock-
counter, a debounce function and a output	
*********************************************************/
module slot(
start,
stop,
clk,
reset,
lfsr_in0,
lfsr_in1,
lfsr_in2,
enable0,
enable1,
enable2,
out0,
out1,
out2
);
//Declare Input Ports
input start;
input stop;
input clk;
input reset;
input [3:0] lfsr_in0;
input [3:0] lfsr_in1;
input [3:0] lfsr_in2;

//Declare Output Ports
output [3:0] out0;
output [3:0] out1;
output [3:0] out2;
output enable0;
output enable1;
output enable2;


//Declare internal variables
reg [3:0] out0 = 4'b0000; 
reg [3:0] out1 = 4'b0000; 
reg [3:0] out2 = 4'b0000;

reg [1:0] state, next_state;

reg start_flag;

reg stop_flag;

reg finish_flag;

reg [31:0] debounce;

reg [31:0] stop_cnt;

reg [23:0] clk_cnt;

reg enable0, enable1, enable2;

//Define internal parameters

parameter pIdle			= 2'b00;
parameter pRunning		= 2'b01;
parameter pStopping		= 2'b10;

parameter clk_val		= 24'h989680;

parameter stop_val0		= 32'h05F5E100;
parameter stop_val1		= 32'h0BEBC200;
parameter stop_val2		= 32'h11E1A300;

always @ (posedge clk or negedge reset)
begin: CLK_COUNT
	if (reset == 0) begin
		clk_cnt <= 24'h000000;
	end
	else if (clk_cnt == clk_val) begin
		clk_cnt <= 24'h000000;
	end 
	else begin
		clk_cnt <= clk_cnt + 1'b1;	
	end
end
//State machine with three states
always @ (posedge clk or negedge reset)
begin: STATE_MACHINE
	state <= pIdle;
	if (reset == 0) begin
		state <= pIdle;
	end
	else begin
	state <= next_state;
		case (state)
			pIdle:		next_state <= (start_flag == 1) ? pRunning 	: pIdle;
			pRunning:	next_state <= (stop_flag == 1) 	? pStopping : pRunning;
			pStopping:  next_state <= (finish_flag == 1)? pIdle 	: pStopping;
		endcase
	end
end

always @ (posedge clk or negedge reset)
begin: OUT0
	out0 <= 0;
	if (reset == 0) begin
		out0 <= 0;
	end
	else if (clk_cnt == clk_val) begin
		out0[2:0] <= lfsr_in0[2:0];
		out0[3] <= 1'b0;
	end
end

always @ (posedge clk or negedge reset)
begin: OUT1
	out1 <= 0;
	if (reset == 0) begin
		out1 <= 0;
	end
	else if (clk_cnt == clk_val) begin
		out1[2:0] <= lfsr_in1[2:0];
		out1[3] <= 1'b0;
	end
end

always @ (posedge clk or negedge reset)
begin: OUT2
	out2 <= 0;
	if (reset == 0) begin
		out2 <= 0;
	end
	else if (clk_cnt == clk_val) begin
		out2[2:0] <= lfsr_in2[2:0];
		out2[3] <= 1'b0;
	end
end
//Stop Process of the slots
always @ (posedge clk or negedge reset)
begin: ENABLE
	enable0 <= 0;
	enable1 <= 0;
	enable2 <= 0;
	if (reset == 0) begin
		enable0 <= 0;
		enable1 <= 0;
		enable2 <= 0;
	end
	else if(state == pRunning) begin
		finish_flag <= 0;
		enable0 <= 1;
		enable1 <= 1;
		enable2 <= 1;
	end
	else if(state == pStopping) begin
		enable0 <= (stop_cnt > stop_val0) 		? 1'b0 : 1'b1;
		enable1 <= (stop_cnt > stop_val1) 		? 1'b0 : 1'b1;
		enable2 <= (stop_cnt > stop_val2) 		? 1'b0 : 1'b1;
		finish_flag <= (stop_cnt > stop_val2) 	? 1'b1 : 1'b0;	
	end
end

always @ (posedge clk or negedge reset)
begin: STOP_CNT
	if (reset == 0 ) begin
		stop_cnt <= 10'b0000000000;
	end
	else if (state == pStopping) begin
		stop_cnt <= stop_cnt +1'b1;
	end
	else begin 
		stop_cnt <= 10'b0000000000;
	end
end
//Debounce Process
always @ (posedge clk or negedge reset)
begin: DEBOUNCE
	if (reset == 0) begin
		debounce <= 32'h00000000;
	end
	else if (debounce == 32'h004C4B40) begin
		start_flag <= (start == 0) ? 1 : 0;
		stop_flag <= (stop == 0) ? 1: 0;
		debounce <= 32'h00000000;
	end
	else begin 
		debounce <= debounce + 1'b1;
	end
end

endmodule
