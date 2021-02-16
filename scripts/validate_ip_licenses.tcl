# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Feb 02, 2021
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     
# 
# ----------------------------------------------------------------------------

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
