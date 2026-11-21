`timescale 1ns / 1ps
module ctrl_unit (
    	input clock, reset, NTT_start,
     
	// Butterfly control veriable 
	output reg [35:0] Twiddle_Factor_cs, //Twiddle Factor 
	
	// Ram  control veriable 
	output reg wr_en_cs,
  	output reg intf,
  	output reg [2:0] wr_addr_cs,
  	
  	// AGU cantrol veriables   
	output reg start_agu_cs,
	output reg [2:0] Stride_cs );        // Stride_cs or Gap
	
 reg [2:0] state; 	
 localparam N = 'd8;
 localparam idel = 'd0; 
 localparam data_incert = 'd1;
 localparam stage_1 = 'd2;
 localparam stage_2 = 'd3;
 localparam stage_3 = 'd4;
 integer i;
 
//////////////////////////////////////////////////////////////////

                    //Twiddle Factor RAM
                    
 reg [8:0] Twiddle_Factor_cs_ram [3:0]; 
 
 //assign Twiddle_Factor_cs = ({Twiddle_Factor_cs_ram[3],Twiddle_Factor_cs_ram[2],Twiddle_Factor_cs_ram[1],Twiddle_Factor_cs_ram[0]});
 
 initial begin
        Twiddle_Factor_cs_ram[0] = 9'd1;
        Twiddle_Factor_cs_ram[1] = 9'd4;
        Twiddle_Factor_cs_ram[2] = 9'd16;
        Twiddle_Factor_cs_ram[3] = 9'd64;
 end

//////////////////////////////////////////////////////////////////


always @(*) begin 

    case (state)
        stage_1: begin
            Twiddle_Factor_cs[8:0] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[17:9] = Twiddle_Factor_cs_ram[1];
            Twiddle_Factor_cs[26:18] = Twiddle_Factor_cs_ram[2];
            Twiddle_Factor_cs[35:27] = Twiddle_Factor_cs_ram[3];
        end
        stage_2: begin
            Twiddle_Factor_cs[8:0] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[17:9] = Twiddle_Factor_cs_ram[2];
            Twiddle_Factor_cs[26:18] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[35:27] = Twiddle_Factor_cs_ram[2];
        end
        stage_3: begin
            Twiddle_Factor_cs[8:0] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[17:9] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[26:18] = Twiddle_Factor_cs_ram[0];
            Twiddle_Factor_cs[35:27] = Twiddle_Factor_cs_ram[0];
        end
    endcase 
end    

always @(posedge clock or negedge reset)begin 
	if(!reset) begin
		// Ram  control veriable
		wr_en_cs <= 0;
  		intf <= 0;
  		wr_addr_cs <= 0;
  		// AGU cantrol veriables 
		start_agu_cs <= 0;
		Stride_cs <= 4;  
		
		state = idel;
	end 
	
	else begin 
		case (state)
		idel: begin 
			if(NTT_start)
			 	state <= data_incert;
		end 
		data_incert: begin
			wr_en_cs <= 1;
  			intf <= 1;
  			wr_addr_cs <= wr_addr_cs + 1;
  			if(wr_addr_cs == 7) begin
  				state <= stage_1;
  				start_agu_cs <= 1;
  			end
  			
		end
		stage_1: begin 
			Stride_cs <= 2;
			state <= stage_2;
		end 
		
		stage_2: begin 
			Stride_cs <= 1;
			state <= stage_3;
		end 
		
		stage_3: begin 
			wr_en_cs <= 0;
  		 	intf <= 0;
  			wr_addr_cs <= 0;
			start_agu_cs <= 0;
			Stride_cs <= 1;
		end 
		
		endcase
	end 
end

endmodule












