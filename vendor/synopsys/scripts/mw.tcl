source ./setup.tcl
source ${ROOT}/scripts/util.tcl

check_var TARGET_LIB_DIR
check_var SCLIB
check_var COMMON_DIR
check_var PLACEROUTE_DIR

set SCLIB_DIMENSIONS [dict create  \
sky130_fd_sc_hd {0.46 2.72} \
sky130_fd_sc_hdll {0.46 2.72} \
sky130_fd_sc_hs {0.48 3.33} \
sky130_fd_sc_ls {0.48 3.33} \
sky130_fd_sc_ms {0.48 3.33} \
]

set lef_dir  ${PLACEROUTE_DIR}/lef
set MW_LEF mw_lef
# Sample db to updated port definitions
set db_file   ${PLACEROUTE_DIR}/db_nldm/${SCLIB}__tt_100C_1v80.db
set tech_file ${PLACEROUTE_DIR}/techfile/${SCLIB}_icc.tf
set layer_map ${COMMON_DIR}/skywater130.mw.map
set cells_dir ${TARGET_LIB_DIR}/cells

# Get list of cells
set cells [lmap cell_dir [glob -directory $cells_dir *] { file tail $cell_dir }]
file delete -force -- $MW_LEF

# Create Milkyway Project and read all GDS with layer 81 as PR Bundary
create_mw_lib $MW_LEF -technology $tech_file -open
foreach cell $cells {
    foreach gds [glob -directory ${cells_dir}/${cell} *.gds] {
        echo "Info-PE: Reading GDS file: $gds"
        read_gds -cell_version overwrite_existing_cell \
                -boundary_layer_map 81 \
                -ignore_undefined_layer \
                -lib_name $MW_LEF \
                -layer_mapping $layer_map \
                $gds
    }
}

# TODO: Add other special cell types
scheme cmMarkCellType
scheme setFormField "Mark Cell Type" "Cell Type" "tap"
scheme setFormField "Mark Cell Type" "pattern match" "1"
scheme setFormField "Mark Cell Type" "Cell Name" "*__tap_1.*"
scheme setFormField "Mark Cell Type" "Cell Name" "*__tap_*"
scheme setFormField "Mark Cell Type" "Cell Type" "tap"
scheme formOK "Mark Cell Type"

scheme auExtractBlockagePinVia
scheme formButton "Extract Blockage" "extractPin"
scheme formOK "Extract Blockage"

# Set PR Boundary and create unitTile
scheme auSetPRBdry
scheme setFormField "Set PR Boundary" "Library Name" "${MW_LEF}"
scheme setFormField "Set PR Boundary" "Tile Name" "unit"
scheme setFormField "Set PR Boundary" "allOrN" "all"
scheme setFormField "Set PR Boundary" "Left Boundary" "specify"
scheme setFormField "Set PR Boundary" "Left Offset" "0.000"
scheme setFormField "Set PR Boundary" "Left From" "Left Boundary"
scheme setFormField "Set PR Boundary" "specify tile" "unit"
scheme setFormField "Set PR Boundary" "Cell GROUND Rail Position" "Bottom"
scheme setFormField "Set PR Boundary" "Cell P/G Rail Orientation" "Horizontal"
scheme setFormField "Set PR Boundary" "Height" "specify"
scheme setFormField "Set PR Boundary" "Height Value" "[lindex [dict get $SCLIB_DIMENSIONS $SCLIB] 1]"
scheme setFormField "Set PR Boundary" "Width" "specify"
scheme setFormField "Set PR Boundary" "Width Value" "[lindex [dict get $SCLIB_DIMENSIONS $SCLIB] 0]"
scheme setFormField "Set PR Boundary" "Bottom Offset" "0.000000"
scheme setFormField "Set PR Boundary" "Bottom Boundary" "specify"
scheme setFormField "Set PR Boundary" "Bottom From" "Origin (0,0)"
scheme setFormField "Set PR Boundary" "Multiple (2x, 3x)" "based on cell height"
scheme formButton "Set PR Boundary" "analyze"
scheme formOk "Set PR Boundary"

scheme axgDefineWireTracks
axgDefineWireTracks
setFormField "Define Wire Track" "polyDir" "vertical"
setFormField "Define Wire Track" "m1Dir" "vertical"
setFormField "Define Wire Track" "M2 Offset" "0.17"
setFormField "Define Wire Track" "m2Dir" "horizontal"
setFormField "Define Wire Track" "m3Dir" "vertical"
setFormField "Define Wire Track" "m4Dir" "horizontal"
setFormField "Define Wire Track" "m5Dir" "vertical"
setFormField "Define Wire Track" "m6Dir" "horizontal"
scheme formOK "Define Wire Track"

# Define Power ports
set power_pins_from_lib "VPWR VPB"
set ground_pins_from_lib "VGND VNB"
if {$power_pins_from_lib ne "" && $ground_pins_from_lib ne ""} {
   foreach ground_pin_from_lib $ground_pins_from_lib {
    foreach power_pin_from_lib $power_pins_from_lib {
      dbSetCellPortTypes $MW_LEF "*" [list [list $power_pin_from_lib "Inout" "Power"] [list $ground_pin_from_lib "Inout" "Ground"]] 1
    }
  }
}

update_mw_port_by_db \
  -update_analog_pin	\
  -bias_pg	\
  -db_file $db_file \
  -mw_lib $MW_LEF

scheme auLoadCLF
scheme setFormField "Load CLF File" "Load CLF File Without Timing Related Information" "1"
scheme setFormField "Load CLF File" "CLF File Name" "${PLACEROUTE_DIR}/techfile/${SCLIB}_antenna.clf"
scheme setFormField "Load CLF File" "Library Name" "${MW_LEF}"
scheme formOK "Load CLF File"

# Export LEF
file mkdir ${lef_dir}
foreach_in_collection cell [get_mw_cels] {
  set cname [get_attribute ${cell} name]
        set lef_file ${lef_dir}/${cname}.snps.lef
        info_msg "Writing LEF: $lef_file"
  write_lef -lib_name ${MW_LEF} -ignore_tech_info -output_cell ${cname} $lef_file
}
close_mw_lib -save
exit
