# ICC2 Library Manager

set root ..
source ${root}/scripts/util.tcl

check_var target_lib_dir
check_var target_lib_name
check_var output_dir

set lib_name ${output_dir}/mw 
set ndm_file ${output_dir}/ndm/${target_lib_name}.ndm
set tech_file ${root}/milkyway/${target_lib_name}.tf
set layer_map ${root}/milkyway/${target_lib_name}.mw.map

set db_dir "${output_dir}/db_nldm"
set lef_dir "${output_dir}/lef"

file mkdir ${output_dir}/ndm

set cells_dir ${target_lib_dir}/cells
set cells [lmap cell_dir [glob -directory $cells_dir *] { file tail $cell_dir }]

set_app_options -name lib.workspace.save_design_views -value true
set_app_options -name lib.workspace.save_layout_views -value true
set_app_options -name lib.workspace.keep_all_physical_cells -value true

create_workspace -technology $tech_file ${target_lib_name}_ws

foreach lef_file [glob -directory ${lef_dir} *.lef] {
    read_lef ${lef_file} -library ${target_lib_name} -cell_boundary by_cell_size
}

foreach db_file [glob -directory ${db_dir} *.db] {
	read_db ${db_file}
}
set_process -label nominal -number 1 -libraries *
set_pvt_configuration -clear_filter all -add -name all -process_labels [list nominal] -process_numbers {1} -voltages {1.28 1.35 1.4 1.44 1.56 1.6 1.65 1.76 1.8 1.95} -temperatures {-40 25 100}
check_workspace -details all 

commit_workspace -force -output $ndm_file

exit
