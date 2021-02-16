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
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         July 14, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     
# 
# ----------------------------------------------------------------------------

set fileName "8T49N24x_EEPROM_HexString_20150728_132950.txt"

puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-        Welcome to the Avnet IDT Clock               -*
*-           Binary to C Header Script                 -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

#if the filename variable is not set, stop here
# puts the command to set a variable in Vivado, otherwise the user just needs to set the command line


puts "dumping to file now"
set date [clock format [clock seconds] -gmt true -format "%Y-%m-%d"]
set time [clock format [clock seconds] -gmt true -format "%H:%M:%S"]
set data "// ----------------------------------------------------------------------------
//     _____
//    *     *
//   *____   *____
//  * *===*   *==*
// *___*===*___**  AVNET Design Resource Center
//      *======*         www.em.avnet.com/drc
//       *====*    
// ----------------------------------------------------------------------------
// 
//  Created With Avnet IDT Clock Binary to .h Converter V0.1.0\n"
append data "//     Date: " $date "\n"
append data "//     Time: " $time "\n"
append data "//  This design is the property of Avnet.  Publication of this
//  design is not authorized without written consent from Avnet.
//  
//  Please direct any questions to:
//     Avnet Centralized Technical Support
//     Centralized-Support@avnet.com
//     1-800-422-9023
// 
//  Disclaimer:
//     Avnet, Inc. makes no warranty for the use of this code or design.
//     This code is provided  \"As Is\". Avnet, Inc assumes no responsibility for
//     any errors, which may appear in this code, nor does it make a commitment
//     to update the information contained herein. Avnet, Inc specifically
//     disclaims any implied warranties of fitness for a particular purpose.
//                      Copyright(c) " [clock format [clock seconds] -gmt true -format "%Y"] " Avnet, Inc.
//                              All rights reserved.
// 
// ----------------------------------------------------------------------------
"

set in [open ./$fileName r]
set fileData [read $in]

set arrayData [split $fileData " "]
set count 0

append data "static unsigned long uft242_eeprom_data_length = "
append data [expr [llength $arrayData] - 1]
append data ";\nstatic unsigned uft242_eeprom_data[] =
{\n"


foreach item $arrayData { 
   incr count
   append data "    0x"
   append data $item
   if {$count < [llength $arrayData]} {
      append data ",\n"
   } else {
      append data "\n"
   }
}
append data "};"

set out [open ./[lindex [split $fileName .] 0].h w]
puts -nonewline $out $data
close $in
close $out
unset fileName date time in fileData arrayData count data 
puts "
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-          Finished Running IDT Clock                 -*
*-           Binary to C Header Script                 -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

