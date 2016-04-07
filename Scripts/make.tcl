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
set required_version 2015.4.2
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
set clean "no"
set project "init"
set tag "init"
set close_project "yes"
set version_override "no"
set found "false"
set ok_to_tag_public "false"
set sdk "no"
set jtag "no"

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
set start_time [clock seconds]
set build_params ""
# to adjust the width of the chart, need to adjust this as well as the "predefined"
# chart elements below (there are 4 lines that need to be adjusted)
set chart_wdith 30
# need to add debug printing to a log
for {set i 0} {$i < [llength $argv]} {incr i} {

   # check for BOARD parameter
   if {[string match -nocase "*help*" [lindex $argv $i]]} {
      puts "Parameters are:"
      puts "board=<board_name>\n boards are listed in the /Boards folder"
      puts "project=<project_name>\n project names are listed in the /Scripts/ProjectScripts folder"
      puts "sdk=\n 'yes' will attempt to execute:\n ../software/<project_name>_sdk.tcl"
      puts " in order to build the SDK portion of the project (prior to tagging request)"
      puts "tag=\n 'yes' will tag locally\n this will attempt to tag based on that flag"
      puts " each project has a release level flag, in the project make script\n the project has been released for the tag level you are attempting to run at"
      puts " 'private' used to allow this project to be privately tagged"
      puts "    with release_state set to private the script will release a tag + compress the package"
      puts " 'public' used to allow this project to be publicly tagged"
      puts "    with release_state set to public the script will release to GITHUB"
      puts "close_project=\n 'no' will prevent the script from closing the project\n used to allow 'up+enter' rebuilds of a project"
      puts "jtag=\n 'yes' will attempt to JTAG a project after synthesis and binary generation"
      puts "clean=\n Be careful due to destructive nature of wiping ALL output products out"
      puts "version_override=yes\n ***************************** \n CAUTION: \n Override the Version Check\n and attempt to make project\n *****************************"
      return -code ok
   } elseif [string match -nocase "false" $ranonce] {
      set ranonce "true"
      set build_params "\n"
      append build_params "+------------------+------------------------------------+\n"
      append build_params "| Setting          |     Configuration                  |\n"
      append build_params "+------------------+------------------------------------+\n"
   }
   # check for BOARD parameter
   if {[string match -nocase "board=*" [lindex $argv $i]]} {
      set board [string range [lindex $argv $i] 6 end]
      set printmessage $board
      for {set j 0} {$j < [expr $chart_wdith - [string length $board]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Board            |     $printmessage |\n"
   }
   # check for CLEAN parameter
   if {[string match -nocase "clean=*" [lindex $argv $i]]} {
      set clean [string range [lindex $argv $i] 6 end]
      set printmessage $clean
      for {set j 0} {$j < [expr $chart_wdith - [string length $clean]]} {incr j} {
         append printmessage " "
      }
      puts "| Clean            |     $printmessage |"
   }
   # check for PROJECT parameter
   if {[string match -nocase "project=*" [lindex $argv $i]]} {
      set project [string range [lindex $argv $i] 8 end]
      set printmessage $project
      for {set j 0} {$j < [expr $chart_wdith - [string length $project]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Project          |     $printmessage |\n"
   }
   # check for TAG parameter
   if {[string match -nocase "tag=*" [lindex $argv $i]]} {
      set tag [string range [lindex $argv $i] 4 end]
      set printmessage $tag
      for {set j 0} {$j < [expr $chart_wdith - [string length $tag]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Tag              |     $printmessage |\n"
   }
   # check for SDK parameter
   if {[string match -nocase "sdk=*" [lindex $argv $i]]} {
      set sdk [string range [lindex $argv $i] 4 end]
      set printmessage $sdk
      for {set j 0} {$j < [expr $chart_wdith - [string length $sdk]]} {incr j} {
         append printmessage " "
      }
      append build_params "| SDK              |     $printmessage |\n"
   }
   # check for Version parameter
   if {[string match -nocase "version_override=*" [lindex $argv $i]]} {
      set version_override [string range [lindex $argv $i] 17 end]
      set printmessage $version_override
      for {set j 0} {$j < [expr $chart_wdith - [string length $version_override]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Version override |     $printmessage |\n"
   }
   # check for No Close Project parameter
   if {[string match -nocase "close_project=*" [lindex $argv $i]]} {
      set close_project [string range [lindex $argv $i] 17 end]
      set printmessage $close_project
      for {set j 0} {$j < [expr $chart_wdith - [string length $close_project]]} {incr j} {
         append printmessage " "
      }
      append build_params "| No Close Project |     $printmessage |\n"
   }
   # check for JTAG parameter
   if {[string match -nocase "jtag=*" [lindex $argv $i]]} {
      set jtag [string range [lindex $argv $i] 5 end]
      set printmessage $jtag
      for {set j 0} {$j < [expr $chart_wdith - [string length $jtag]]} {incr j} {
         append printmessage " "
      }
      append build_params "| No Close Project |     $printmessage |\n"
   }
   append build_params "+------------------+------------------------------------+\n"
}
append build_params "\n\n"
puts $build_params
unset printmessage
unset ranonce

#version check
set version [version -short]
if {[string match -nocase "yes" $version_override]} {
   puts "Overriding Version Check, Please Check the Design for Validity!"
} else {
   if {[string first $version $required_version]} {
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
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected Board and Project as:\n$board and $project"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
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
set GUI $rdi::mode
if {[string match -nocase "init" $tag]} {
   puts "Not Requesting Tag"
   if {[string match -nocase "yes" $jtag]} {
      if {[string match -nocase "tcl" $GUI]} {
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts "*-                                                     -*"
         puts "*-              JTAG recommended to                    -*"
         puts "*-            Use GUI!  Please run from GUI!           -*"
         puts "*-                                                     -*"
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         return -code ok
      }
   }
} else {
   puts "Requesting Tag"
   cd $repo_folder
   set modified_files [exec git ls-files -m]
   cd $scripts_folder
   if {[llength $modified_files] > 0} { 
      puts "Please commit all files before trying to TAG\nNot Tagging..."
      return -code ok
   }
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
   PZ7015_FMCCC               -
   PZ7030_FMCCC               -
   PZ7010_FMC2                -
   PZ7020_FMC2                -
   PZ7015_FMC2                -
   PZ7030_FMC2                -
   PZSDR7035_FMCCC            -
   ZC702                      -
   ZC706                      -
   ZEDBOARD                   -
   MITXZ7045                  -
   MITXZ7100                  -
   MZ7010_FMCCC               -
   MZ7020_FMCCC               -
   MZ7010_EMBV                -
   MZ7020_EMBV                -
   MZ7010_IOCC                -
   MZ7020_IOCC                {puts "Setting Up Project $project..."
                                 source ./ProjectScripts/$project.tcl -notrace}
   default                    {puts "Error in Selecting Board!"
                                 puts "Boards are defined in [file normalize [pwd]/../Boards]"
                                 return -code ok}
}
if {[string match -nocase "no" $jtag]} {
   puts "Generating Binary..."
   source ./bin_helper.tcl -notrace

   # if using for development, can set this to yes to just use the script
   # to build your project in Vivado
   if {[string match -nocase "no" $close_project]} {
      puts "Not Closing Project..."
   } else {
      set curr_proj [current_project -quiet]
      if {[string match -nocase "" $curr_proj]} {
         puts "Not Closing Project..."
      } else {
         puts "Closing Project..."
         close_project
      }
      unset curr_proj
   }
   
   # attempt to build SDK portion
   if {[string match -nocase "yes" $sdk]} {
      puts "Attempting to Build SDK..."
      cd ${projects_folder}
      exec >@stdout 2>@stderr xsdk -batch -source ../software/$project\_sdk.tcl -notrace
	  # Build a BOOT.bin file only if a BIF file exists for the project.
	  if {[file exists ../software/$project\_sd.bif]} {
         puts "Generating BOOT.BIN..."
         exec >@stdout 2>@stderr bootgen -image ../software/$project\_sd.bif -w -o BOOT.bin
      }
      cd ${scripts_folder}
   }
   
   # run Tagging script
   if {[string match -nocase "yes" $tag]} {
      puts "Running Tag"
      source ./tag.tcl -notrace
   } else {
      puts "Not Running Tag"
   }
}
set end_time [clock seconds]
set number_seconds [expr {$end_time - $start_time}]
set time_string "Your Build Took\nseconds [$number_seconds]\n\nor a total of:\n\ndays [[expr {$number_seconds/86400}]]\nhrs  [[expr {($number_seconds%86400)/3600}]]\nmin  [[expr {(($number_seconds%86400)%3600)/60}]]\nsec  [[expr {(($number_seconds%86400)%3600)%60}]]\n\nto complete"

append build_params "\n"
append build_params $time_string
set out [open $projects_folder/buildInfo.log w]
puts -nonewline $out $build_params
close $out

puts "
$time_string

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-            Finished Running Script                  -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
"
unset out
unset build_params
unset start_time
unset end_time
unset number_seconds
unset time_string