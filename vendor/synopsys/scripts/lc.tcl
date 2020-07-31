# Library compiler

if { ! [info exists target_lib] } {
    echo "Error-PE: no target_lib specified - [date]"
    exit
}
if { ! [info exists target_lib_name] } {
    echo "Error-PE: no target_lib_name specified - [date]"
    exit
}

set lib_dir ${target_lib}/timing
set db_dir  ${target_lib}/db_nldm/

set N 0
set i 0
set report {}
foreach lib [glob -directory $lib_dir *.lib] {
    set lib_name [file rootname [file tail $lib]]
    read_lib $lib
    file mkdir $db_dir
    set ret_code [write_lib $lib_name -output ${db_dir}/${lib_name}.db]
    if { $ret_code == 1 } {
        append report "Compiled $lib\n"
    } {
        incr i
        append report "Error    $lib\n"
    } 
    incr N
}

echo "Summary:\n$report\n${i}/${N} errors"

exit
