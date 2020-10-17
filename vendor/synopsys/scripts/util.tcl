proc _msg { prefix msg } {
    echo "${prefix}-PE: [join $msg { }] - [date]"
}

proc error_msg { args } {
    _msg "Error" $args
}

proc info_msg { args } {
    _msg "Info" $args
}

proc debug_msg { args } {
    _msg "Debug" $args
}

proc check_var { name } {
    if { ! [uplevel #0 "info exists $name"] } {
        error_msg "var $name does not exists"
        exit 1
    }
}
