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
#  Create Date:         October 08, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     
# 
# ----------------------------------------------------------------------------

# create GREP process
# From: http://wiki.tcl.tk/9395
# Modified to set a variable, instead of only printing locations
proc grep {pattern args} {
    global found
    set found "false"
    if {[llength $args] == 0} {
        grep0 "" $pattern stdin
    } else {
        foreach filename $args {
            if {[file exists $filename]} {
               set file [open $filename r]
               grep0 ${filename}: $pattern $file
               close $file
            } else {
               puts "File $filename does not exist"
            }
        }
    }
}
proc grep0 {prefix pattern handle} {
    set lnum 0
    while {[gets $handle line] >= 0} {
        incr lnum
        if {[regexp $pattern $line]} {
            global found
            set found "true"
            puts "$prefix${lnum}:${line}"
        }
    }
}

# loop waiting for build to end so can call TAG
# loop looks for \Projects\sampleproject_working\sampleproject_working.runs\impl_1\.place_design.end.rst
# loop also looks for error conditions, so it does not wait forever for something that cannot finish

set updown "up"
set dot_count 1
set x 0

while {1} {
   # stop if an error is detected
   if {[file exists $projects_folder/${board}_${project}.runs/synth_1/runme.log]} {
      grep "ERROR:" $projects_folder/${board}_${project}.runs/synth_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Synthesis..."
         break
      }
   }
   # stop if an error is detected
   if {[file exists $projects_folder/${board}_${project}.runs/impl_1/runme.log]} {
      grep "ERROR:" $projects_folder/${board}_${project}.runs/impl_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Bitstream Creation..."
         break
      }
   }
   # stop if an error is detected
   if {[file exists $projects_folder/${board}_${project}.runs/impl_1/.vivado.error.rst]} { 
      puts "Found Error in Implementation..."
      break 
   }
   # stop if an error is detected
   if {[file exists $projects_folder/${board}_${project}.runs/synth_1/.vivado.error.rst]} { 
      puts "Found Error in Synthesis..."
      break 
   }
   # stop if end of run detected
   if {[file exists $projects_folder/${board}_${project}.runs/impl_1/.vivado.end.rst]} { 
      puts "Found End of Bitstream Creation..."
      break 
   }
#   # paint pretty picture - shows still running
#   if {[string match -nocase "up" $updown]} {
#      if {$dot_count < 10} { 
#         incr dot_count
#      } else {
#         incr dot_count -1
#         set updown "down"
#      }
#   } elseif {[string match -nocase "down" $updown]} {
#      if {$dot_count > 0} { 
#         incr dot_count -1
#      } else {
#         incr dot_count
#         set updown "up"
#      }
#   } else {
#      set dot_count 1
#      set updown "down"
#   }
#   for {set y 0} {$y< $dot_count} {incr y} {
#      puts -nonewline "."
#   }
#   puts "."
#   # wait 1 second to check
#   after 1000
}
