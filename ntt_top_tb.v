`include "NTT_TOP.v"

module ntt_test ();
	reg clock, reset, intf, NTT_start;  
	reg [8:0] nttIN;
	integer i;
NTT_top dut(
    .clock(clock), 
    .reset(reset), 
    .intf(intf), 
    .NTT_start(NTT_start),
    .nttIN(nttIN) );
	
always #5 clock = ~clock;	
	
initial begin 
	$fsdbDumpfile("ntt_test");
	$fsdbDumpvars(0,ntt_test);
end

initial begin 
	clock =0;
    	reset =0;
    	repeat(2) @(posedge clock);
    	i=0;
    	@(posedge clock)
    	reset = 1;
    	
    	intf=1;
    	NTT_start=1;
    	repeat(8)begin
    	nttIN = i+1;
    	@(posedge clock);
    	end
    	
    	#150
    	display_memory;
    	
    	#15 $finish;
end

task display_memory;
integer j;
begin
    $display("\n========== MEMORY CONTENTS ==========");
    for (j = 0; j < 8; j = j + 1) begin
        $display("MEM[%0d] = %09b (%0d)",
                  j, dut.RAM.mem_loc[j], dut.RAM.mem_loc[j]);
    end
    $display("=====================================\n");
end
endtask
endmodule
	
