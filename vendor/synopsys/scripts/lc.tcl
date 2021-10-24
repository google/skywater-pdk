## Library compiler script

set root ..
source ${root}/scripts/util.tcl

check_var target_lib_dir
check_var target_lib_name
check_var output_dir

set lib_dir ${target_lib_dir}/timing
set db_dir  ${output_dir}/db_nldm/

set N 0
set i 0
set report {}
foreach lib [glob -directory $lib_dir *.lib] {
    info_msg "Reading lib: $lib"
    set lib_name [file rootname [file tail $lib]]
    ## fix wells:
    set fix_dir fixed_libs
    set fixed_lib ./$fix_dir/${lib_name}.lib
    file mkdir $fix_dir
    exec cat $lib | ${root}/scripts/fix_well_pg_type.py > $fixed_lib
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
