### design compiler flow
set search_path { \
/home/eic.eb.ac.in/Downloads/vlsisoftware/Design_compiler/pdk_lib_files/SAED32_EDK-20260503T135702Z-3-003/SAED32_EDK/lib/stdcell_hvt/db_nldm \
/home/eic.eb.ac.in/Downloads/vlsisoftware/Design_compiler/pdk_lib_files/SAED32_EDK-20260503T135702Z-3-003/SAED32_EDK/lib/lib/stdcell_lvt/db_nldm \
/home/eic.eb.ac.in/Downloads/vlsisoftware/Design_compiler/pdk_lib_files/SAED32_EDK-20260503T135702Z-3-003/SAED32_EDK/lib/stdcell_rvt/db_nldm \
/home/eic.eb.ac.in/Downloads/vlsisoftware/Design_compiler/pdk_lib_files/SAED32_EDK-20260503T135702Z-3-003/SAED32_EDK/lib/sram_lp/db_nldm     \
}

set link_library {saed32hvt_ss0p95v125c.db saed32sramlp_ss0p95v125c_i0p95v.db}
#saed32rvt_ss0p95v125c.db

set target_library {saed32hvt_ss0p95v125c.db  saed32sramlp_ss0p95v125c_i0p95v.db}
#saed32rvt_ss0p95v125c.db

## Analyze
analyze -library WORK -format verilog ./inputs/rtl2/sequitial_adder.v
                                       #     rtl top module file    #

## Elaborate
elaborate adder -library WORK
      #top module#

## Link
link

##source SDC file
source ./inputs/chiptop.sdc

## Mapping and optimisation
compile_ultra

## report generated after the synthesis

write verilog -hierarchy -output ./outputs/reports/sq_adder_netlist.v

change_name -hierarchy -rules verilog 

write_sdc -nosplit ./outputs/reports/sq_adder_pd.sdc



