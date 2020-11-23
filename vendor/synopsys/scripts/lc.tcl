## Library compiler script

source ./setup.tcl
source ${ROOT}/scripts/util.tcl

check_var SCLIB
check_var ROOT
check_var TARGET_LIB_DIR
check_var PLACEROUTE_DIR

set lib_dir ${TARGET_LIB_DIR}/timing
set db_dir  ${PLACEROUTE_DIR}/db_nldm
set fixed_lib_dir ${PLACEROUTE_DIR}/lib

file mkdir $fixed_lib_dir

set N 0
set i 0
set report {}
foreach lib [glob -directory $lib_dir *.lib] {
    info_msg "Reading lib: $lib"
    set lib_name [file rootname [file tail $lib]]

    ## fix wells:
    set fixed_lib ./$fixed_lib_dir/${lib_name}.lib
    exec cat $lib | ${ROOT}/scripts/fix_well_pg_type.py > $fixed_lib
    info_msg "Fixed lib: $fixed_lib"

    set lib $fixed_lib
    info_msg "Reading lib: $lib"

    read_lib $lib
    file mkdir $db_dir
    info_msg "Writing DB: ${db_dir}/${lib_name}.db"
    set ret_code [write_lib $lib_name -output ${db_dir}/${lib_name}.db]
    set lib [file normalize $lib]
    if { $ret_code == 1 } {
        append report " OK       $lib\n"
    } {
        incr i
        append report " Error    $lib\n"
    }
    incr N
    #break
}

echo "\n\n\nSummary:\n$report\n${i}/${N} errors"

exit
