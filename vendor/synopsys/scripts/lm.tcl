# ICC2 Library Manager
source ./setup.tcl
set lib_name ${target_lib_dir}/mw 
set db_file ${target_lib_dir}/db_nldm/${target_lib_name}__ss_n40C_1v28.db
set tech_file ../milkyway/${target_lib_name}.tf
set layer_map ../milkyway/${target_lib_name}.mw.map

set cells_dir ${target_lib_dir}/cells
set cells [lmap cell_dir [glob -directory $cells_dir *] { file tail $cell_dir }]

set db_dir "${target_lib_dir}/db_nldm" ;# $db_dir/$libs_$opconds.db
set lef_dir "./lef" ;# $lef_dir/$libs.lef

set_app_options -name lib.workspace.save_design_views -value true
set_app_options -name lib.workspace.save_layout_views -value true

set ndm_file ./${target_lib_name}.ndm
create_workspace -technology $tech_file ${target_lib_name}_ws
set_current_mismatch_config auto_fix
foreach lef_file [glob -directory ${lef_dir} *.lef] {
	read_lef ${lef_file} -library ${target_lib_name}
}

foreach db_file [glob -directory ${db_dir} *.db] {
	if { ![regexp sky130_fd_sc_hd__ss_n40C_1v76 ${db_file}] } {  
		read_db ${db_file}
	}
}
set_process -label nominal -number 1 -libraries *
set_pvt_configuration -clear_filter all -add -name all -process_labels [list nominal] -process_numbers {1} -voltages {1.28 1.35 1.4 1.44 1.56 1.6 1.65 1.76 1.8 1.95} -temperatures {-40 25 100}
check_workspace -details all

#return
sh mkdir -p ${output_dir}/ndm
commit_workspace -force -output ${output_dir}/ndm/$ndm_file

exit
