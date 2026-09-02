set_app_options -name lib.workspace.group_libs_create_slg -value false
set_app_options -name lib.workspace.allow_missing_related_pg_pins -value true

# Create a workspace (Choose flow 'normal' or 'exploration')
create_workspace stdcell_32nm_workspace -flow exploration     -technology /home/eic.eb.ac.in/Downloads/vlsisoftware/SAED32_EDK_03312022/SAED32_EDK/tech/milkyway/saed32nm_1p9m_mw.tf

read_lef /home/eic.eb.ac.in/Downloads/vlsisoftware/SAED32_EDK_03312022/SAED32_EDK/lib/stdcell_hvt/lef/saed32nm_hvt_1p9m.lef 

read_db [glob /home/eic.eb.ac.in/Downloads/vlsisoftware/SAED32_EDK_03312022/SAED32_EDK/lib/stdcell_hvt/db_nldm/*.db]

group_libs

check_workspace


