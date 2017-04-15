`include "lfsr.v"
`include "SEG7_LUT.v"
`include "slot.v"

module slot_top(
	clk,
	reset,
	start,
	stop,
	oSEG0,
	oSEG1,
	oSEG2
);

parameter lfsr_length = 10;

input	clk;
input	reset;
input	start;
input	stop;
output [6:0]	oSEG0;
output [6:0]	oSEG1;
output [6:0]	oSEG2;


wire [lfsr_length-1 : 0] w_lfsr;

wire [3:0] iDIG0;
wire [3:0] iDIG1;
wire [3:0] iDIG2;

wire clk;
wire reset;
wire start;
wire stop;
wire [6:0] oSEG0;
wire [6:0] oSEG1;
wire [6:0] oSEG2;

wire rst_out;

reg rst_ff0, rst_ff1, rst_ff2 = 0;

defparam	slot_inst.stop_val0 = 32'h0000000A;
defparam	slot_inst.stop_val1 = 32'h00000014;
defparam	slot_inst.stop_val2 = 32'h0000001E;

defparam	slot_inst.clk_val = 24'h000005;

defparam	slot_inst.lfsr_length = lfsr_length;
defparam	lfsr_inst0.lfsr_length = lfsr_length;

defparam	slot_inst.debounce_max	 = 32'h00000001;

always @ (posedge clk)
begin: RESET_SYNCH
	rst_ff0 <= reset;
	rst_ff1 <= rst_ff0;
	rst_ff2 <= rst_ff1 && rst_ff0;
end

assign rst_out = rst_ff2;

lfsr	lfsr_inst0(
	.clk		(clk),
	.reset 		(rst_out),
	.lfsr_out	(w_lfsr)
);

slot	slot_inst(
	.clk		(clk),
	.reset		(rst_out),
	.start		(start),
	.stop		(stop),
	.lfsr_in	(w_lfsr),
	.slot_out0	(iDIG0),
	.slot_out1	(iDIG1),
	.slot_out2	(iDIG2)
);

SEG7_LUT	SEG7_LUT_inst0(
	.iDIG		(iDIG0),
	.oSEG		(oSEG0)
);

SEG7_LUT	SEG7_LUT_inst1(
	.iDIG		(iDIG1),
	.oSEG		(oSEG1)
);

SEG7_LUT	SEG7_LUT_inst2(
	.iDIG		(iDIG2),
	.oSEG		(oSEG2)
);

endmodule
