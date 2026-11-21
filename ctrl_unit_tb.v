`include "ctrl_unit.v"

module ctl_test ();
	reg clock, reset, NTT_start;
	// Butterfly control veriable 
	wire [8:0] tw_p0_ntt_wire;
	wire [8:0] tw_p1_ntt_wire;
	wire [8:0] tw_p2_ntt_wire;
	wire [8:0] tw_p3_ntt_wire;
	// Ram  control veriable 
	wire wr_en_mm;
  	wire intf_mm;
  	wire [2:0] wr_addr_ntt;
  	
  	// AGU cantrol veriables 
  	wire [1:0] stage;
	wire start_agu;
	wire [2:0] Stride;        
	
	
ctrl_unit dut (
    	.clock(clock), 
    	.reset(reset),
     
	// Butterfly control veriable 
	.Twiddle_Factor_cs({tw_p3_ntt_wire, tw_p2_ntt_wire, tw_p1_ntt_wire, tw_p0_ntt_wire}), //Twiddle Factor 
	
	// Ram  control veriable 
	.wr_en_cs(wr_en_mm),
  	.intf(intf_mm),
  	.wr_addr_cs(wr_addr_ntt),
  	
  	// AGU cantrol veriables    
	.start_agu_cs(start_agu),
	.Stride_cs(Stride),               // Stride or Gap
	.NTT_start(NTT_start) );        
	
always #5 clock = ~clock;	
	
initial begin 
	$fsdbDumpfile("ctl_test");
	$fsdbDumpvars(0,ctl_test);
end

initial begin 
	clock =0;
    	reset =0;
    	repeat(2) @(posedge clock);
    
    	@(posedge clock)
    	reset = 1;
NTT_start = 1;
    	#150 $finish;
end

endmodule
	
	
	
	
	
	
