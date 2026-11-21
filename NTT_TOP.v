`include "ctrl_unit.v"
`include "mem_9_8.v"
`include "AGU.v"
`include "Butterfly.v"

module NTT_top (
    input clock, reset, intf, NTT_start,
    input [8:0] nttIN
    );

// wires from memory and buterfly
wire [8:0] m2bta0_wire;
wire [8:0] m2btb0_wire;
wire [8:0] m2bta1_wire;
wire [8:0] m2btb1_wire;
wire [8:0] m2bta2_wire;
wire [8:0] m2btb2_wire;
wire [8:0] m2bta3_wire;
wire [8:0] m2btb3_wire;
wire [8:0] bt2mm_a0_wire;
wire [8:0] bt2mm_b0_wire;
wire [8:0] bt2mm_a1_wire;
wire [8:0] bt2mm_b1_wire;
wire [8:0] bt2mm_a2_wire;
wire [8:0] bt2mm_b2_wire;
wire [8:0] bt2mm_a3_wire;
wire [8:0] bt2mm_b3_wire;

//wires from agu to memory
wire [2:0] agu2mm_a0_wire;
wire [2:0] agu2mm_a1_wire;
wire [2:0] agu2mm_a2_wire;
wire [2:0] agu2mm_a3_wire;
wire [2:0] agu2mm_b0_wire;
wire [2:0] agu2mm_b1_wire;
wire [2:0] agu2mm_b2_wire;
wire [2:0] agu2mm_b3_wire;

//cantrol wires 
wire wr_en_wire;
wire [2:0] wr_addr_wire;
wire start_agu_wire;
wire [2:0] stride_wire;

// cantrol to butterfly twidle factor wires 
wire [8:0] tw_p0_ntt_wire;
wire [8:0] tw_p1_ntt_wire;
wire [8:0] tw_p2_ntt_wire;
wire [8:0] tw_p3_ntt_wire;

memory_9_8 RAM
  (.clock(clock),
  .reset(reset),
  .wr_en_mm(wr_en_wire),
  .intf_mm(intf),
  .wr_addr_mm(wr_addr_wire),
  
  .rd_addrA0(agu2mm_a0_wire),
  .rd_addrB0(agu2mm_b0_wire),
  .rd_addrA1(agu2mm_a1_wire),
  .rd_addrB1(agu2mm_b1_wire),
  .rd_addrA2(agu2mm_a2_wire),
  .rd_addrB2(agu2mm_b2_wire),
  .rd_addrA3(agu2mm_a3_wire),
  .rd_addrB3(agu2mm_b3_wire),
  
  .data_in(nttIN),
  
  .data_inA0(bt2mm_a0_wire),
  .data_inB0(bt2mm_b0_wire),
  .data_inA1(bt2mm_a1_wire),
  .data_inB1(bt2mm_b1_wire),
  .data_inA2(bt2mm_a2_wire),
  .data_inB2(bt2mm_b2_wire),
  .data_inA3(bt2mm_a3_wire),
  .data_inB3(bt2mm_b3_wire),
  
  .data_outA0(m2bta0_wire),
  .data_outB0(m2btb0_wire),
  .data_outA1(m2bta1_wire),
  .data_outB1(m2btb1_wire),
  .data_outA2(m2bta2_wire),
  .data_outB2(m2btb2_wire),
  .data_outA3(m2bta3_wire),
  .data_outB3(m2btb3_wire) );
  
  
AGU_gen Address_gen(
    .clock(clock), 
    .reset(reset), 
    .start(start_agu_wire), 
    .G(stride_wire), //stride / gap
    .out_A({agu2mm_a3_wire, agu2mm_a2_wire, agu2mm_a1_wire, agu2mm_a0_wire}),
    .out_B({agu2mm_b3_wire, agu2mm_b2_wire, agu2mm_b1_wire, agu2mm_b0_wire})
    );


ctrl_unit CPU (
    	.clock(clock), 
    	.reset(reset), 
    	.NTT_start(NTT_start),
	.Twiddle_Factor_cs({tw_p3_ntt_wire, tw_p2_ntt_wire, tw_p1_ntt_wire, tw_p0_ntt_wire}),
	.wr_en_cs(wr_en_wire),
  	.intf(intf),
  	.wr_addr_cs(wr_addr_wire),  
	.start_agu_cs(start_agu_wire),
	.Stride_cs(stride_wire) );      

butterfly bt0 (.A(m2bta0_wire), .B(m2btb0_wire), .W(tw_p0_ntt_wire), .top(bt2mm_a0_wire), .btm(bt2mm_b0_wire) );
butterfly bt1 (.A(m2bta1_wire), .B(m2btb1_wire), .W(tw_p1_ntt_wire), .top(bt2mm_a1_wire), .btm(bt2mm_b1_wire) );
butterfly bt2 (.A(m2bta2_wire), .B(m2btb2_wire), .W(tw_p2_ntt_wire), .top(bt2mm_a2_wire), .btm(bt2mm_b2_wire) );
butterfly bt3 (.A(m2bta3_wire), .B(m2btb3_wire), .W(tw_p3_ntt_wire), .top(bt2mm_a3_wire), .btm(bt2mm_b3_wire) );


endmodule












