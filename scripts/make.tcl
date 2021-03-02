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
#                      Copyright(c) 2021 Avnet, Inc.
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
# ----------------------------------------------------------------------------

# must be format [4 digit major][period][1 digit minor]
# i.e. 2020.2
set required_version 2020.2
# properly set vivado version for secondary check and folder creation
set vivado_ver [string replace $required_version 4 4 _ ]

set debuglevel 0
set scriptdir [pwd]
set board "init"
set clean "no"
set project "init"
set tag "init"
set close_project "no"
set version_override "no"
set found "false"
set ok_to_tag_public "false"
set sdk "no"
set jtag "no"
set dev_arch "zynq"

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

# From StackOverflow
# https://stackoverflow.com/questions/29482303/how-to-find-the-number-of-cpus-in-tcl

proc numberOfCPUs {} {
    # Windows puts it in an environment variable
    global tcl_platform env
    if {$tcl_platform(platform) eq "windows"} {
        return $env(NUMBER_OF_PROCESSORS)
    }

    # Check for sysctl (OSX, BSD)
    set sysctl [auto_execok "sysctl"]
    if {[llength $sysctl]} {
        if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
            return $cores
        }
    }

    # Assume Linux, which has /proc/cpuinfo, but be careful
    if {![catch {open "/proc/cpuinfo"} f]} {
        set cores [regexp -all -line {^processor\s} [read $f]]
        close $f
        if {$cores > 0} {
            return $cores
        }
    }

    # No idea what the actual number of cores is; exhausted all our options
    # Fall back to returning 1; there must be at least that because we're running on it!
    return 1
}

set numberOfCores [numberOfCPUs] 

puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-        Welcome to the Avnet Project Builder         -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
# fetch the required Vivado Board Definition File (BDF) from the bdf git repo
set bdf_path [file normalize [pwd]/../../bdf]
if {[expr {![catch {file lstat $bdf_path finfo}]}]} {
   set_param board.repoPaths $bdf_path
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected \n BDF path $bdf_path"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
} else {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected \n BDF path set to $bdf_path \n\n"
   puts " BDF Repository Does NOT Exist!"
   puts " Please Clone BDF repository to same parent level as hdl!"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   return -code ok
}

# in TCL mkdir is like running mkdir -p in Linux
# no need for directory exists check
puts "Creating projects Folder"
file mkdir [file normalize $scriptdir/../projects]

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
      puts "board=<board_name>\n boards are listed in the /boards folder"
      puts "project=<project_name>\n project names are listed in the /scripts/project_scripts folder"
      puts "sdk=\n 'yes' will attempt to execute:\n ../../../software/<project_name>_sdk.tcl"
      puts " in order to build the SDK portion of the project (prior to tagging request)"
      puts "tag=\n 'yes' will tag locally\n this will attempt to tag based on that flag"
      puts " each project has a release level flag, in the project make script\n the project has been released for the tag level you are attempting to run at"
      puts " 'private' used to allow this project to be privately tagged"
      puts "    with release_state set to private the script will release a tag + compress the package"
      puts " 'public' used to allow this project to be publicly tagged"
      puts "    with release_state set to public the script will release to GITHUB"
      puts "close_project=\n 'no' will prevent the script from closing the project\n used to allow 'up+enter' rebuilds of a project"
      puts "jtag=\n 'yes' will attempt to JTAG a project after synthesis and binary generation"
      puts "arch=\n specifies the target device architecture (zynq or zynqmp) to create a boot.bin file"
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
      append build_params  "| Clean            |     $printmessage |\n"
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
      set close_project [string range [lindex $argv $i] 14 end]
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
      append build_params "| JTAG             |     $printmessage |\n"
   }
   # check for DEV_ARCH parameter
   if {[string match -nocase "dev_arch=*" [lindex $argv $i]]} {
      set dev_arch [string range [lindex $argv $i] 9 end]
      set printmessage $dev_arch
      for {set j 0} {$j < [expr $chart_wdith - [string length $dev_arch]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Device           |     $printmessage |\n"
   }
   # check for VIVADO_VER parameter
   if {[string match -nocase "vivado_ver=*" [lindex $argv $i]]} {
      set vivado_ver [string range [lindex $argv $i] 11 end]
      set printmessage $vivado_ver
      for {set j 0} {$j < [expr $chart_wdith - [string length $vivado_ver]]} {incr j} {
         append printmessage " "
      }
      append build_params "| Vivado Version   |     $printmessage |\n"
   }
   append build_params "+------------------+------------------------------------+\n"
}
puts $build_params
unset printmessage
unset ranonce

#version check
set version [version -short]
if {[string match -nocase "yes" $version_override]} {
   puts "Overriding Version Check, Please Check the Design for Validity!"
} else {
   if { [string first $required_version $version] == -1 } {
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Vivado version $version"
      puts "      not acceptable"
      puts " Please run with Vivado $required_version"
      puts "      to continue"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
      return -code ok
   } else {
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Vivado version $version acceptable, \ncontinuing..."
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   }
}

# If variables do not exist, exit script
if {[string match -nocase "init" ${board}]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Board was not defined"
   puts " Please define and try again!"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   return -code ok
}
if {[string match -nocase "init" ${project}]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Project was not defined"
   puts " Please define and try again!"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   return -code ok
}

if {[file isfile ./project_scripts/${board}_${project}.tcl]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected Board and Project as:\n ${board} and ${project}"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
} else {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Selected Board and Project as:\n ${board} and ${project}"
   puts " Project Script Does NOT Exist, Check Name and Try Again!"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   return -code ok
}

# create variables with absolute folders for all necessary folders
set boards_folder [file normalize [pwd]/../boards]
set ip_folder [file normalize [pwd]/../ip]
set projects_folder [file normalize [pwd]/../projects/${board}_${project}_${vivado_ver}]
set scripts_folder [file normalize [pwd]]
set repo_folder [file normalize [pwd]../../]

if {[string match -nocase "yes" $clean]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Cleaning Project..."
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   file delete -force ${projects_folder}
   return -code ok
}

# IF tagging - check for modified files
set GUI $rdi::mode
if {[string match -nocase "init" $tag]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Not Requesting Tag"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
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
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Requesting Tag"
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   cd $repo_folder
   set modified_files [exec git ls-files -m]
   cd $scripts_folder
   if {[llength $modified_files] > 0} { 
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Please commit all files before trying to TAG\nNot Tagging..."
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
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
   pz7010_fmc2                -
   pz7020_fmc2                -
   pz7015_fmc2                -
   pz7030_fmc2                -
   u96v2_sbc              -
   uz3eg_iocc                 -
   uz3eg_pciec                -
   uz7ev_evcc                 -
   minized_sbc                -
   mz7010_som                 -
   mz7020_som                 {puts " Setting Up Project ${board}_${project}..."
                                 source ./project_scripts/${board}_${project}.tcl -notrace}
   default                    {puts " Error in Selecting Board!"
                                 puts " Boards are defined in [file normalize [pwd]/../boards]"
                                 return -code ok}
}
if {[string match -nocase "no" $jtag]} {
   puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   puts " Generating Binary..."
   puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   source ./bin_helper.tcl -notrace

   # if using for development, can set this to yes to just use the script
   # to build your project in Vivado
   if {[string match -nocase "no" $close_project]} {
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Not Closing Project..."
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
   } else {
      set curr_proj [current_project -quiet]
      if {[string match -nocase "" $curr_proj]} {
         puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts " Not Closing Project..."
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
      } else {
         puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts " Closing Project..."
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
         close_project
      }
      unset curr_proj
   }
   
   # attempt to build SDK portion
   if {[string match -nocase "yes" $sdk]} {
      pwd
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Attempting to Build SDK..."
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
      cd ${projects_folder}
      # Change starting with 2018.2 (Ultra96v2 validation test, Nov 2018) to use xsct instead of xsdk
      # https://www.xilinx.com/html_docs/xilinx2018_2/SDK_Doc/xsct/use_cases/xsct_howtoruntclscriptfiles.html
      # added the Board variable so it could be used when needed - see uz_petalinux SDK build script for 
      # how to use this
      exec >@stdout 2>@stderr xsct ../../software/$project/$project\_sdk.tcl -notrace $board $vivado_ver
      # Build a BOOT.bin file only if a BIF file exists for the project.
      if {[file exists ../../software/$project/$project\_sd.bif]} {
         puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
         puts " Generating BOOT.BIN..."
         puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
         exec >@stdout 2>@stderr bootgen -arch $dev_arch -image ../../software/$project/$project\_sd.bif -w -o BOOT.bin
      }
      cd ${scripts_folder}
   }
   
   # run Tagging script
   if {[string match -nocase "yes" $tag]} {
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Running Tag"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
      source ./tag.tcl -notrace
   } else {
      puts "\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
      puts " Not Running Tag"
      puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n"
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
