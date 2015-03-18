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
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Main Tag Script, used for 3 types of tagging
# 
#  Dependencies:        Windows requires the use of two .exe files, at least
#                       until Vivado incorporates the next version of TCL
# 
# ----------------------------------------------------------------------------

set found "false"
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
               puts "Files does not exist"
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
# create recursive glob process
# From: http://wiki.tcl.tk/1474
# Unmodified
proc glob-r {{dir .}} {
    set res {}
    foreach i [lsort [glob -nocomplain -dir $dir *]] {
        if {[file type $i] eq {directory}} {
            eval lappend res [glob-r $i]
        } else {
            lappend res $i
        }
    }
    set res
}
proc tag_process {project board projects_folder repo_folder scripts_folder repo_server} {
   global found
   # check project logs for errors
   #  C:/demo_try/Avnet/Projects/sampleproject/sampleproject.runs/synth_1/runme.log
   grep "ERROR:" $projects_folder/$project.runs/synth_1/runme.log
   if {[string match -nocase "true" $found]} { 
      puts "Error detected in Synthesis...\nNot Tagging..."
      return -code error 
   } else {
      puts "No Error detected in Synthesis...\nContinuing Checks..."
   }
   # C:/demo_try/Avnet/Projects/sampleproject/sampleproject.runs/impl_1/runme.log
   grep "ERROR:" $projects_folder/$project.runs/impl_1/runme.log
   if {[string match -nocase "true" $found]} { 
      puts "Error detected in Implementation...\nNot Tagging..."
      return -code error
   } else {
      puts "No Error detected in Implementation...\nContinuing Checks..."
   }
   # check again for modified files
   cd $repo_folder
   set modified_files [exec git ls-files -m]
   cd $scripts_folder
   if {[llength $modified_files] > 0} { 
      puts "Please commit all files before trying to TAG\nNot Tagging..."
      return -code error
   } else {
      puts "Executing Tag Now..."
      # need to figure out how to remove everything after "while executing" catch {} ??
      puts [exec git tag -a $project\_$board\_[clock format [clock seconds] -gmt true -format "%Y%m%d_%H%M%S"] -m $project\_$board\_[clock format [clock seconds] -gmt true -format "%Y%m%d_%H%M%S"]]
      puts "Pushing to server..."
      puts [exec -ignorestderr git push $repo_server master --tags]
   }
}

puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-        Welcome to the Avnet Tag Script              -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

# if using for development, can set this to yes to just use the script
# to build your project in Vivado
# add this check, in case we end up trying to tag without running make.tcl
# allow user to override (in case they are using start_gui/stop_gui

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

# Tagging Cases
# Assumes GIT is installed and setup

if {[string match -nocase "yes" $tag]} {
   puts "Attempting to Tag Project..."
   if {[string match -nocase "private" $release_state]} {
      set archive_name $project\_$board\_[clock format [clock seconds] -gmt true -format "%Y%m%d_%H%M%S"].tar.gz
      puts "Attempting to Tag Project for Private Release"
      tag_process $project $board $projects_folder $repo_folder $scripts_folder "origin"
      puts "Tagged Project for Private Release"
      puts "Compressing file..."
      exec git clean -dxf
      # when the TCL engine is updated in Vivado, this should be a good
      # starting point to remove the need for the two .exe files
      # tar and compress files
      # use these lines once $tcl_version is 8.6b1 or greater
      #puts "Finding Files..."
      #set tarball_files [glob-r $repo_folder]
      #package require tar
      #puts "Tar Files..."
      #set chan [open $repo_folder/$archive_name.tar.gz w]
      #zlib push gzip $chan
      #tar::create $chan [glob-r $repo_folder] -chan
      #close $chan
      # give clean time to settle
      # why do I need this?
      after 35000
      if {[string match -nocase *windows* $tcl_platform(platform)]} {
         cd $repo_folder
         exec $scripts_folder/tar cvf $archive_name.tar Boards IP Projects Scripts
         exec $scripts_folder/gzip -c $archive_name.tar > $archive_name.tar.gz
         file delete $archive_name.tar
         unset $archive_name
         cd $scripts_folder
      } else {
         puts "Script Needs to be updated to handle this Operating Environment, please contact script maintainer"
      }
   } elseif {[string match -nocase "public" $release_state]} {
      puts "Attempting to Tag Project for Public Release"
      #check if variable is AOK to public tag
      puts "Ready for Public Commit, if you are certain type your project name\n'$project' (no quotes):"
      set ok_to_tag_public [gets stdin]
      if {[string match -nocase $project $ok_to_tag_public]} {
         grep "tag_public" ../.git/config
         # if false, add in the public tagging information
         if {[string match -nocase "false" $found]} {
            puts "Public GITHUB Not Found, adding to CONFIG"
            set data "\n\[remote \"tag_public\"\]\n	url = git@xterra1.avnet.com:repo/hdl.git\n	url = git@github.com:Avnet/hdl.git"
            set out [open ../.git/config a]
            puts -nonewline $out $data
            close $out
         } else {
            puts "Public GITHUB Found in CONFIG"
         }
         puts "Please Wait, pushing to servers"
         tag_process $project $board $projects_folder $repo_folder $scripts_folder "tag_public"
         puts "Tagged Project for Public Release"
      } else {
         puts "Tagging Project for Public Release Not Allowed\nPlease Check Permissions"
      }
   } else { 
         tag_process $project $board $projects_folder $repo_folder $scripts_folder "origin"
   }
} else {
   puts "No Tagging Requested, exiting"
}
unset ok_to_tag_public
puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-          Finished Running Tag Script                -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

