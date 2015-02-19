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
            puts "Public GITHUB Found"
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
      puts [exec git push $repo_server master --tags]
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


# Tagging Cases
# Assumes GIT is installed and setup

# if tag = yes, close_project, then look for errors in the log
# grep through   C:\Avnet\Projects\sampleproject\sampleproject.runs\impl_1\runme.log
# for ERROR:
# then grep for failed timing
# finally check that a binary actually was written to hard drive (file exists)
# commit

if {[string match -nocase "yes" $tag]} {
   puts "Attempting to Tag Project..."
   tag_process $project $board $projects_folder $repo_folder $scripts_folder "origin"
} elseif {[string match -nocase "yes_private_release" $tag]} {
   if {[string match "private" $release_state]} {
      set archive_name $project\_$board\_[clock format [clock seconds] -gmt true -format "%Y%m%d_%H%M%S"].tar.gz
      puts "Attempting to Tag Project for Private Release"
      #tag_process $project $board $projects_folder $repo_folder $scripts_folder
      puts "Tagged Project for Private Release"
      puts "Compressing file..."
      exec git clean -dxf
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
         cd $scripts_folder
      }
   } else {
      puts "Private Release State Set to NOT ALLOWED, please check and try again..."
   }
} elseif {[string match -nocase "yes_public_release" $tag]} { 
   puts "Attempting to Tag Project for Public Release"
   if {[string match "public" $release_state]} {
      #check if variable is AOK to public tag
      puts "Ready for Public Commit, if you are certain type 'yes' (no quotes):"
      set ok_to_tag_public [read stdin 3]
      if {[string match -nocase "yes" $ok_to_tag_public]} {
         grep "tag_public" ../.git/config
         # if false, add in the public tagging information
         if {[string match -nocase "false" $found]} {
            puts "Public GITHUB Not Found, adding to CONFIG"
            set data "\n\[remote \"tag_public\"\]\n	url = git@xterra1.avnet.com:repo/hdl.git\n	url = git@github.com:Avnet/hdl.git"
            set out [open ../.git/config a]
            puts -nonewline $out $data
            close $out
         }
         puts "Please Wait, pushing to servers"
         tag_process $project $board $projects_folder $repo_folder $scripts_folder "tag_public"
         puts "Tagged Project for Public Release"
      } else {
         puts "Not OK to check-in public repository, check make and project\nRun public tag process again"
      }
      } else {
         puts "Not OK to check-in public repository, check make and project\nRun public tag process again"
         return -code ok
      }
   } else {
      close_project
      puts "Tagging Project for Public Release Not Allowed, Please Check Permissions"
   }
} else { 
   puts "No Tagging Requested, exiting"
}

