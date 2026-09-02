set Time_Period 4
set Input_Delay 1
set Output_Delay 1
set Clock_Latency 0.2
set Max_Transition 0.5
set Min_IO_Delay 1.0


##Clocks 
create_clock -name "clk" -period  $Time_Period [get_ports clk]
set_clock_latency $Clock_Latency [get_clocks clk]
set_clock_uncertainty 0.1 [get_clocks clk]
set_clock_transition $Max_Transition [get_clocks clk]



# create clocks
# 	# types 
# 		#main {master clock} -> generated from source {PLL} and distributed to all seq cells 
#				     -> fequency of design is decided
# 		#virtual clock
# 		#generated clock 
 
# grouping of paths

# weight means priority, all weight 1 have equal priority for optimization 

	group_path -name CLOCK -to [get_clocks clk] -weight 1          
	group_path -name INPUTS -through [all_inputs] -weight 1
	group_path -name OUTPUT -to [all_outputs] -weight 1
	


# in/out delays 
	set input_ports [remove_from_collection [all_inputs] [get_ports clk]]
	set output_ports [all_outputs]
	
	set_input_delay -clock "clk" -max $Input_Delay $input_ports 
	set_output_delay -clock "clk" -max $Output_Delay $output_ports 
	set_input_delay -clock "clk" -min $Min_IO_Delay $input_ports 
	set_output_delay -clock "clk" -min $Min_IO_Delay $output_ports 
	
	set_load 3.3 [all_outputs]
	set_driving_cell -lib_cell NBUFFX4_HVT [all_inputs]      

# name(NBUFF), derive strength(X4), threshold voltage(HVT)

	set_operating_conditions ss0p95v125c     		 
# process voltage temprature
	
	
	
# set voltage 
	
	
####################################################################################################################################	
	
# chiptop.sdc

#set_max_delay 5 -from [all_inputs] -to [all_outputs]

#set_load 3.3 [all_outputs]

#set_driving_cell -lib_cell NBUFFX4_HVT [all_inputs]

#set_operating_conditions ss0p95v125c
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
