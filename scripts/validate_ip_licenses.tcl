proc validate_ip_licenses {project_name} {

    set results ""
    set invalid_ip_lic 0

    set ip_status_str [report_ip_status -license_status -return_string]
    set ip_status_lines [split $ip_status_str \n];

    foreach line $ip_status_lines {
        if {[regexp "Instance Name" $line]} {
            append results "$line\n"
        }
        if {[regexp $project_name $line]} {
            if {![regexp "Included" $line] && ![regexp  "Hardware_Evaluation" $line] && ![regexp  "Purchased" $line]} {
                incr invalid_ip_lic
                append results "$line\n"
            }
        }
    }

    if {$invalid_ip_lic == 0} {
        puts "License Validation = Successful"
    } else {
        puts "License Validation = Error(s) detected"
        puts "\n$results"
    }

    return $invalid_ip_lic
}
