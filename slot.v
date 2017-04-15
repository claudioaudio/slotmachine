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
lfsr_in,
slot_out0,
slot_out1,
slot_out2
);

//Define internal parameters
parameter IDLE			= 2'b00;
parameter RUNNING		= 2'b01;
parameter STOPPING		= 2'b10;

parameter MUX_ADDR0		= 2'b00;
parameter MUX_ADDR1		= 2'b01;
parameter MUX_ADDR2		= 2'b10;

parameter clk_val		= 24'h989680;

parameter debounce_max	= 32'h004C4B40;

parameter stop_val0		= 32'h05F5E100;
parameter stop_val1		= 32'h0BEBC200;
parameter stop_val2		= 32'h11E1A300;

parameter lfsr_length = 10;

//Declare Input Ports
input start;
input stop;
input clk;
input reset;
input [lfsr_length-1 : 0] lfsr_in;

//Declare Output Ports
output [3:0] slot_out0;
output [3:0] slot_out1;
output [3:0] slot_out2;

//Declare internal registers
reg [3:0] slot_out0 = 0; 
reg [3:0] slot_out1 = 0; 
reg [3:0] slot_out2 = 0;

reg [1:0] state 	= IDLE; 

reg [1:0] mux_sel 	= MUX_ADDR0;

reg running;
reg stopping;

reg start_flag;

reg stop_flag;

reg [31:0] debounce;

reg [31:0] stop_cnt;

reg [23:0] clk_cnt;



//Declare internal wires


wire clk_flag;

wire clk_cond;

wire slot_cond0;
wire slot_cond1;
wire slot_cond2;

wire mux_cond0;
wire mux_cond1;
wire mux_cond2;

wire finish_flag0;
wire finish_flag1;
wire finish_flag2;

//Structural Coding

assign clk_flag = (clk_cnt == clk_val) ? 1'b1 : 1'b0;
assign clk_cond = (clk_flag & (running | stopping));
assign mux_cond0 = (~finish_flag0 & clk_cond);
assign mux_cond1 = (~finish_flag1 & clk_cond);
assign mux_cond2 = (~finish_flag2 & clk_cond);
assign finish_flag0 = (stop_cnt > stop_val0) ? 1'b1 : 1'b0;
assign finish_flag1 = (stop_cnt > stop_val1) ? 1'b1 : 1'b0;
assign finish_flag2 = (stop_cnt > stop_val2) ? 1'b1 : 1'b0;

//Sequential Coding

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
begin: MAIN_STATE_MACHINE
	if (reset == 0) begin
		state <= IDLE;
		running <= 1'b0;		
		stopping <= 1'b0;
	end
	else begin
		case (state)
			IDLE	:	if (start_flag == 1) begin
							state 		<= RUNNING;
							running 	<= 1'b1;
						end else begin
							state 		<= IDLE;
						end
			RUNNING	:	if (stop_flag == 1) begin
							state 		<= STOPPING;
							running 	<= 1'b0;
							stopping 	<= 1'b1;
						end else begin
							state 		<= RUNNING;
						end
			STOPPING:  	if (finish_flag2 == 1) begin
							state 		<= IDLE;
							stopping 	<= 1'b0;
						end else begin
							state 		<= STOPPING;
						end
		endcase
	end
end

always @ (posedge clk or negedge reset)
begin: MUX_STATE_MACHINE0
	if(reset == 0) begin
		mux_sel <= MUX_ADDR0;
	end
	else begin
		case (mux_sel) 
			MUX_ADDR0 	: 	if (clk_cond == 1) mux_sel <= MUX_ADDR1;
								else mux_sel <=  MUX_ADDR0;
			MUX_ADDR1	: 	if (clk_cond == 1) mux_sel <= MUX_ADDR2; 
								else mux_sel <=  MUX_ADDR1;
			MUX_ADDR2 	: 	if (clk_cond == 1) mux_sel <= MUX_ADDR0; 
								else mux_sel <=  MUX_ADDR2;
		endcase
	end
end

always @ (posedge clk)
begin: SLOT_OUT0
	if (mux_cond0 == 1) begin
		case (mux_sel)
			MUX_ADDR0	: slot_out0 <= {1'b0, lfsr_in[2:0]};
			MUX_ADDR1	: slot_out0 <= {1'b0, lfsr_in[5:3]};
			MUX_ADDR2	: slot_out0 <= {1'b0, lfsr_in[8:6]};
		endcase
	end
end

always @ (posedge clk)
begin: SLOT_OUT1
	if (mux_cond1 == 1) begin
		case (mux_sel)
			MUX_ADDR1	: slot_out1 <= {1'b0, lfsr_in[2:0]};
			MUX_ADDR2	: slot_out1 <= {1'b0, lfsr_in[5:3]};
			MUX_ADDR0	: slot_out1 <= {1'b0, lfsr_in[8:6]};
		endcase
	end
end

always @ (posedge clk)
begin: SLOT_OUT2
	if (mux_cond2 == 1) begin
		case (mux_sel)
			MUX_ADDR2	: slot_out2 <= {1'b0, lfsr_in[2:0]};
			MUX_ADDR0	: slot_out2 <= {1'b0, lfsr_in[5:3]};
			MUX_ADDR1	: slot_out2 <= {1'b0, lfsr_in[8:6]};
		endcase
	end
end

always @ (posedge clk or negedge reset)
begin: STOP_CNT
	if (reset == 0 ) begin
		stop_cnt <= 10'b0000000000;
	end
	else if (stopping == 1) begin
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
	else if (debounce == debounce_max) begin
		debounce <= 32'h00000000;
		start_flag <= (start == 0) ? 1'b1 : 1'b0;
		stop_flag <= (stop == 0) ? 1'b1 : 1'b0;
	end
	else begin 
		debounce <= debounce + 1'b1;
	end
end

endmodule
