source ./setup.tcl
source ${ROOT}/scripts/util.tcl

check_var SCLIB
check_var TARGET_LIB_DIR
check_var PLACEROUTE_DIR
check_var COMMON_DIR

set lib_name mw_tech

read_lef -lib_name $lib_name \
    -tech_lef_files ${TARGET_LIB_DIR}/tech/${SCLIB}.tlef \
    -layer_mapping ${COMMON_DIR}/lef_mw.map

# Dump Technology property
cmDumpTech
setFormField "Dump Technology File" "Technology File Name" "${PLACEROUTE_DIR}/techfile/${SCLIB}_icc.tf"
setFormField "Dump Technology File" "Library Name" "$lib_name"
formOK "Dump Technology File"

# Dump Antenna property
auDumpCLF
setFormField "CLF File Name" "CLF File Name" "${PLACEROUTE_DIR}/techfile/${SCLIB}_antenna.clf"
setFormField "Dump Technology File" "Library Name" "$lib_name"
formOK "Dump CLF File"
exit
