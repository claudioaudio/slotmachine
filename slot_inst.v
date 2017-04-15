// Copyright (C) 2016  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Generated by Quartus Prime Version 16.1 (Build Build 196 10/24/2016)
// Created on Sat Apr 15 09:20:31 2017

slot slot_inst
(
	.start(start_sig) ,	// input  start_sig
	.stop(stop_sig) ,	// input  stop_sig
	.clk(clk_sig) ,	// input  clk_sig
	.reset(reset_sig) ,	// input  reset_sig
	.lfsr_in(lfsr_in_sig) ,	// input [lfsr_length-1:0] lfsr_in_sig
	.enable(enable_sig) ,	// output  enable_sig
	.slot_out0(slot_out0_sig) ,	// output [3:0] slot_out0_sig
	.slot_out1(slot_out1_sig) ,	// output [3:0] slot_out1_sig
	.slot_out2(slot_out2_sig) 	// output [3:0] slot_out2_sig
);

defparam slot_inst.IDLE = 'b00;
defparam slot_inst.RUNNING = 'b01;
defparam slot_inst.STOPPING = 'b10;
defparam slot_inst.MUX_ADDR0 = 'b00;
defparam slot_inst.MUX_ADDR1 = 'b01;
defparam slot_inst.MUX_ADDR2 = 'b10;
defparam slot_inst.clk_val = 'b100110001001011010000000;
defparam slot_inst.debounce_max = 'b00000000010011000100101101000000;
defparam slot_inst.stop_val0 = 'b00000101111101011110000100000000;
defparam slot_inst.stop_val1 = 'b00001011111010111100001000000000;
defparam slot_inst.stop_val2 = 'b00010001111000011010001100000000;
defparam slot_inst.lfsr_length = 10;
