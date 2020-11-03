# ICC2 Library Manager
source ./setup.tcl
source ${ROOT}/scripts/util.tcl

check_var SCLIB
check_var TARGET_LIB_DIR
check_var COMMON_DIR
check_var PLACEROUTE_DIR

set ndm_file ${PLACEROUTE_DIR}/ndm/${SCLIB}.ndm
set tech_file ${PLACEROUTE_DIR}/techfile/${SCLIB}_icc.tf
set layer_map ${COMMON_DIR}/skywater130.mw.map

set db_dir "${PLACEROUTE_DIR}/db_nldm"
set lef_dir "${PLACEROUTE_DIR}/lef"

file mkdir ${PLACEROUTE_DIR}/ndm

set cells_dir ${TARGET_LIB_DIR}/cells
set cells [lmap cell_dir [glob -directory $cells_dir *] { file tail $cell_dir }]

set_app_options -name lib.workspace.save_design_views -value true
set_app_options -name lib.workspace.save_layout_views -value true
set_app_options -name lib.workspace.keep_all_physical_cells -value true

create_workspace -technology $tech_file ${SCLIB}_ws

foreach lef_file [glob -directory ${lef_dir} *.lef] {
    read_lef ${lef_file} -library ${SCLIB} -cell_boundary by_cell_size
}

foreach db_file [glob -directory ${db_dir} *.db] {
    read_db ${db_file}
}

set_process -label nominal -number 1 -libraries *
set_pvt_configuration -clear_filter all -add -name all -process_labels [list nominal] -process_numbers {1} -voltages {1.28 1.35 1.4 1.44 1.56 1.6 1.65 1.76 1.8 1.95} -temperatures {-40 25 100}

# LEF view needs some changes
remove_lib_cell *isowell*

check_workspace -details all
commit_workspace -force -output $ndm_file

exit
