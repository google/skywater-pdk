source ./setup.tcl

set root ..
source ${root}/scripts/util.tcl

check_var target_lib_dir
check_var target_lib_name
check_var output_dir

set lib_name ${output_dir}/mw 
set db_file ${output_dir}/db_nldm/${target_lib_name}__ss_n40C_1v28.db
set tech_file ${root}/milkyway/${target_lib_name}.tf
set layer_map ${root}/milkyway/${target_lib_name}.mw.map

set cells_dir ${target_lib_dir}/cells
set cells [lmap cell_dir [glob -directory $cells_dir *] { file tail $cell_dir }]

file delete -force -- $lib_name
create_mw_lib $lib_name -technology $tech_file -open

foreach cell $cells {
    foreach gds [glob -directory ${cells_dir}/${cell} *.gds] {
        echo "Info-PE: reading GDS file: $gds"
        read_gds \
			-cell_version overwrite_existing_cell \
			-boundary_layer_map 236 \
			-ignore_undefined_layer \
			-lib_name $lib_name \
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
scheme setFormField "Set PR Boundary" "Library Name" "${lib_name}"
scheme setFormField "Set PR Boundary" "Tile Name" "unit"
scheme setFormField "Set PR Boundary" "allOrN" "all"
scheme setFormField "Set PR Boundary" "Left Boundary" "specify"
scheme setFormField "Set PR Boundary" "Left Offset" "0.000"
scheme setFormField "Set PR Boundary" "Left From" "Left Boundary"
scheme setFormField "Set PR Boundary" "specify tile" "unit"
scheme setFormField "Set PR Boundary" "Cell GROUND Rail Position" "Bottom"
scheme setFormField "Set PR Boundary" "Cell P/G Rail Orientation" "Horizontal"
scheme setFormField "Set PR Boundary" "Height" "specify"
scheme setFormField "Set PR Boundary" "Height Value" "2.72"
scheme setFormField "Set PR Boundary" "Width" "specify"
scheme setFormField "Set PR Boundary" "Width Value" "0.46"
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
      dbSetCellPortTypes $lib_name "*" [list [list $power_pin_from_lib "Inout" "Power"] [list $ground_pin_from_lib "Inout" "Ground"]] 1
      }
    }
  } 

update_mw_port_by_db \
	-update_analog_pin	\
	-bias_pg	\
	-db_file $db_file \
	-mw_lib $lib_name

scheme auLoadCLF
scheme setFormField "Load CLF File" "Load CLF File Without Timing Related Information" "1"
scheme setFormField "Load CLF File" "CLF File Name" "${root}/milkyway/${target_lib_name}.antenna.clf"
scheme setFormField "Load CLF File" "Library Name" "${lib_name}"
scheme formOK "Load CLF File"

# Export LEF
file mkdir ${output_dir}/lef
foreach_in_collection cell [get_mw_cels] {
	set cname [get_attribute ${cell} name]
        set lef_file ${output_dir}/lef/${cname}.lef
        info_msg "Writing LEF: $lef_file"
	write_lef -lib_name ${lib_name} -ignore_tech_info -output_cell ${cname} $lef_file 
}
close_mw_lib -save
exit
