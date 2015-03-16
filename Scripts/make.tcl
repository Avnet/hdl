# ----------------------------------------------------------------------------
#       _____
#      *     *
#     *____   *____
#    * *===*   *==*
#   *___*===*___**  AVNET
#        *======*
#         *====*
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
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
#  Create Date:         December 02, 2014
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     
# 
#  Tool versions:       
set required_version 2014.4
# 
#  Description:         Build Script for sample project (fails build)
# 
#  Dependencies:        Variable Configuration Scripts, Project Build Scripts,
#                       Tagging Scripts
# 
# ----------------------------------------------------------------------------

set debuglevel 0
set scriptdir [pwd]
set board "init"
set project "init"
set tag "init"
set no_close_project "no"
set version_override "no"
set found "false"
set ok_to_tag_public "false"

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

puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-        Welcome to the Avnet Project Builder         -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

set ranonce "false"
# need to add debug printing to a log
for {set i 0} {$i < [llength $argv]} {incr i} {

   # check for BOARD parameter
   if {[string match -nocase "*help*" [lindex $argv $i]]} {
      puts "Parameters are:"
      puts "board=<board_name>\n boards are listed in the /Boards folder"
      puts "project=<project_name>\n project names are listed in the /Scripts/ProjectScripts folder"
      puts "tag=\n 'yes' will tag locally\n 'yes_private_release' will attempt a private release tag + compression of package\n 'yes_public_release' will release to GITHUB"
      puts "no_close_project=\n 'yes' will prevent the script from closing the project\n used to allow 'up+enter' rebuilds of a project"
      puts " each project has a release level flag, please validate\n that your project has been released for the tag level you are attempting to run at"
      #puts "would like to add clean=, however would like to add a confirmation due to destructive nature of wiping EVERYTHING out"
      puts "version_override=yes\n ***************************** \n CAUTION: \n Override the Version Check\n and attempt to make project\n *****************************"
      return -code ok
   } elseif [string match -nocase "false" $ranonce] {
      set ranonce "true"
      puts ""
      puts "+------------------+------------------------------------+"
      puts "| Setting          |     Configuration                  |"
      puts "+------------------+------------------------------------+"
   }
   # check for BOARD parameter
   if {[string match -nocase "board=*" [lindex $argv $i]]} {
      set board [string range [lindex $argv $i] 6 end]
      set printmessage $board
      for {set j 0} {$j < [expr 30 - [string length $board]]} {incr j} {
         append printmessage " "
      }
      puts "| Board            |     $printmessage |"
   }
   # check for PROJECT parameter
   if {[string match -nocase "project=*" [lindex $argv $i]]} {
      set project [string range [lindex $argv $i] 8 end]
      set printmessage $project
      for {set j 0} {$j < [expr 30 - [string length $project]]} {incr j} {
         append printmessage " "
      }
      puts "| Project          |     $printmessage |"
   }
   # check for TAG parameter
   if {[string match -nocase "tag=*" [lindex $argv $i]]} {
      set tag [string range [lindex $argv $i] 4 end]
      set printmessage $tag
      for {set j 0} {$j < [expr 30 - [string length $tag]]} {incr j} {
         append printmessage " "
      }
      puts "| Tag              |     $printmessage |"
   }
   # check for Version parameter
   if {[string match -nocase "version_override=*" [lindex $argv $i]]} {
      set version_override [string range [lindex $argv $i] 17 end]
      set printmessage $version_override
      for {set j 0} {$j < [expr 30 - [string length $version_override]]} {incr j} {
         append printmessage " "
      }
      puts "| Version override |     $printmessage |"
   }
   # check for No Close Project parameter
   if {[string match -nocase "no_close_project=*" [lindex $argv $i]]} {
      set no_close_project [string range [lindex $argv $i] 17 end]
      set printmessage $no_close_project
      for {set j 0} {$j < [expr 30 - [string length $no_close_project]]} {incr j} {
         append printmessage " "
      }
      puts "| No Close Project |     $printmessage |"
   }
   puts "+------------------+------------------------------------+"
}
puts ""
unset printmessage
unset ranonce

#version check
set version [version -short]
if {[string match -nocase "yes" $version_override]} {
   puts "Overriding Version Check, Please Check the Design for Validity!"
} else {
   if {[expr $version == $required_version]} {
      puts "Version of Vivado acceptable, continuing..."
   } else {
      puts "Version $version of Vivado not acceptable, please run with Vivado $required_version to continue"
      return -code ok
   }
}

# If variables do not exist, exit script
if {[string match -nocase "init" $board]} {
   puts "Board was not defined, please define and try again!"
   return -code ok
}
if {[string match -nocase "init" $project]} {
   puts "Project was not defined, please define and try again!"
   return -code ok
}

if {[file isfile ./ProjectScripts/$project.tcl]} {
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected Board and Project as:\n$board and $project"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
} else {
   puts "Project Script Does NOT Exist, Check Name and Try Again!"
   return -code ok
}

# create variables with absolute folders for all necessary folders
set boards_folder [file normalize [pwd]/../Boards]
set ip_folder [file normalize [pwd]/../IP]
set projects_folder [file normalize [pwd]/../Projects/$project/$board]
set scripts_folder [file normalize [pwd]]
set repo_folder [file normalize [pwd]../../]

# IF tagging - check for modified files
if {[string match -nocase "init" $tag]} {
   puts "Not Requesting Tag"
} else {
   puts "Requesting Tag"
   cd $repo_folder
   set modified_files [exec git ls-files -m]
   cd $scripts_folder
   if {[llength $modified_files] > 0} { 
      puts "Please commit all files before trying to TAG\nNot Tagging..."
      return -code ok
   }
   set GUI $rdi::mode
   if {[string match -nocase "gui" $GUI]} {
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "*-                                                     -*"
      puts "*-             Cannot TAG from GUI!                    -*"
      puts "*-           Please RUN from TCL SHELL                 -*"
      puts "*-                                                     -*"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      return -code ok
   }
}

# Project Creation Cases
# use a - for fall through expressions
switch -nocase $board {
    MZ7010_IOCC                   -
    MZ7020_IOCC                   {puts "Setting Up Project $project..."
                                     source ./ProjectScripts/$project.tcl -notrace}
    MZ7010_EMBV                   -
    MZ7020_EMBV                   {puts "Setting Up Project $project..."
                                     source ./ProjectScripts/$project.tcl -notrace}

    default                       {puts "Error in Selecting Board!"
                                   puts "Boards are defined in [file normalize [pwd]/../Boards]"
                                   return -code ok}
}

# loop waiting for build to end so can call TAG
# loop looks for C:\demo_try\Avnet\Projects\sampleproject_working\sampleproject_working.runs\impl_1\.place_design.end.rst
# loop also looks for error conditions, so it does not wait forever for something that cannot finish

                                       # C:/demo_try/Avnet/Projects/sampleproject/sampleproject.runs/impl_1/runme.log
                                       # 
set updown "up"
set dot_count 1
set x 0

# wait 5 seconds before starting loop
#after 5000
puts "Generating Binary..."
while {1} {
   # stop if an error is detected
   if {[file exists $projects_folder/$project.runs/synth_1/runme.log]} {
      grep "ERROR:" $projects_folder/$project.runs/synth_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Synthesis..."
         break
      }
   }
   # stop if an error is detected
   if {[file exists $projects_folder/$project.runs/impl_1/runme.log]} {
      grep "ERROR:" $projects_folder/$project.runs/impl_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Bitstream Creation..."
         break
      }
   }
   # stop if end of run detected
   if {[file exists $projects_folder/$project.runs/impl_1/.vivado.end.rst]} { 
      puts "Found End of Bitstream Creation..."
      break 
   }
   # paint pretty picture - shows still running
   if {[string match -nocase "up" $updown]} {
      if {$dot_count < 10} { 
         incr dot_count
      } else {
         incr dot_count -1
         set updown "down"
      }
   } elseif {[string match -nocase "down" $updown]} {
      if {$dot_count > 0} { 
         incr dot_count -1
      } else {
         incr dot_count
         set updown "up"
      }
   } else {
      set dot_count 1
      set updown "down"
   }
   for {set y 0} {$y< $dot_count} {incr y} {
      puts -nonewline "."
   }
   puts "."
   # wait 1 second to check
   after 1000
}

# if using for development, can set this to yes to just use the script
# to build your project in Vivado
if {[string match -nocase "yes" $no_close_project]} {
   puts "Not Closing Project..."
} else {
   close_project
   puts "Closing Project..."
}

# run Tagging script
if {[string match -nocase "yes" $tag]} {
   puts "Running Tag"
   source ./tag.tcl -notrace
} else {
   puts "Not Running Tag"
   puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-            Finished Running Script                  -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
}