set c_xdevicefamily [ipgui::get_cfamily [get_project_property ARCHITECTURE]]
set Maximum_Number_of_Layers 8

proc EvalSubstituting {parameters procedure {numlevels 1}} {
    set paramlist {}
    if {[string index $numlevels 0]!="#"} {
        set numlevels [expr $numlevels+1]
    }
    foreach parameter $parameters {
        upvar 1 $parameter $parameter\_value
        tcl::lappend paramlist \$$parameter [set $parameter\_value]
    }
    uplevel $numlevels [string map $paramlist $procedure]
}

 proc create_gui { IpView } {
 
	create_Page1 $IpView
	create_Page2 $IpView
	create_Page3 $IpView
	create_Page4 $IpView
	create_Page5 $IpView
	create_Page6 $IpView
	create_Page7 $IpView
	create_Page8 $IpView
	create_Page9 $IpView
	create_Page10 $IpView
	create_Page11 $IpView
	create_Page12 $IpView
	create_Page13 $IpView
	create_Page14 $IpView
	create_Page15 $IpView
	create_Page16 $IpView
	create_Page17 $IpView    
	
	for {set i 3} {$i <= 17} {incr i} {
		variable Page$i
		set_property visible false [set Page$i]
	}
}
	
proc create_Page1 {IpView} {
  set Page1 [ ipgui::add_page $IpView  -name "Page1" -layout horizontal]
	set_property display_name "Features" $Page1
	set Component_Name [ ipgui::add_param  $IpView  -parent  $IpView  -name Component_Name ]
	ipgui::add_row $IpView -parent $Page1
	# optional check box
	set Group1 [ipgui::add_group $IpView -name Group1 -layout vertical -parent $Page1]
	set_property display_name "Optional Features" $Group1
	# ipgui::add_static_text $IpView -parent $Group1 -name Blnk1 -text " "
	set HAS_AXI4_LITE [ipgui::add_param $IpView -parent $Group1 -name HAS_AXI4_LITE -widget checkBox]
	set_property display_name "Include AXI4-Lite Interface" $HAS_AXI4_LITE
	# ipgui::add_static_text $IpView -parent $Group1 -name Blnk2 -text " "
	set HAS_INTC_IF [ipgui::add_param $IpView -parent $Group1 -name HAS_INTC_IF -widget checkBox]
	set_property display_name "Include INTC Interface" $HAS_INTC_IF
	# ipgui::add_static_text $IpView -parent $Group1 -name Blnk3 -text " "
	
	ipgui::add_row $IpView -parent $Page1
	
	set Group2 [ipgui::add_group $IpView -name Group2 -layout vertical -parent $Page1]
	set_property display_name "Options" $Group2
	set S_AXIS_VIDEO_FORMAT [ipgui::add_param $IpView -parent $Group2 -name S_AXIS_VIDEO_FORMAT -widget comboBox]
	set_property display_name "Video Format" $S_AXIS_VIDEO_FORMAT
	set Data_Channel_Width [ipgui::add_param $IpView -parent $Group2 -name Data_Channel_Width -widget comboBox]
	set_property display_name "Video Component Width" $Data_Channel_Width
	set NUMBER_OF_LAYERS [ipgui::add_param $IpView -parent $Group2 -name NUMBER_OF_LAYERS -widget comboBox]
	set_property display_name "Number of Layers" $NUMBER_OF_LAYERS
	set SCREEN_WIDTH [ipgui::add_param $IpView -parent $Group2 -name SCREEN_WIDTH ]
	set_property display_name "Maximum Screen Width" $SCREEN_WIDTH
	
	ipgui::add_row $IpView -parent $Page1
	
	set Group3 [ipgui::add_group $IpView -name Group3 -layout vertical -parent $Page1]
	set_property display_name "Layer Configuration" $Group3
	
	foreach i {0 1 2 3 4 5 6 7} {
		EvalSubstituting { i } {
			set LAYER$i_TYPE [ipgui::add_param $IpView -parent $Group3 -name LAYER$i_TYPE -widget comboBox]
			set_property display_name "LAYER$i Type" $LAYER$i_TYPE
						  set_property tooltip "Set the layer type for layer $i. Each layer can receive data from the external AXI4-Stream interface or from an Internal Graphics Controller." $LAYER$i_TYPE
		} 0
	}	
	foreach i {1 2 3 4 5 6 7} {
		EvalSubstituting { i } {
			set_property visible false $LAYER$i_TYPE 
		} 0
	}
	
  set_property tooltip "Specifies top level name of the HDL wrapper" $Component_Name
  set_property tooltip "Selecting this checkbox adds a memory mapped register interface to the core instance." $HAS_AXI4_LITE
  set_property tooltip "Selecting this checkbox adds a group of output signals to the core interface which can be connected to an external Interrupt Controller instance." $HAS_INTC_IF
  set_property tooltip "Set the maximum number of layers that can be shown on screen.  Each layer can be alpha blended (per pixel or globally) and can be read from external memory via a AXI4-Stream interface or generated internally via an internal Graphics Controller." $NUMBER_OF_LAYERS 
  set_property tooltip "Set the Color Space, number of Data Channels and the Alpha Channel Enable." $S_AXIS_VIDEO_FORMAT 
  set_property tooltip  "Set the Data width of each Channel." $Data_Channel_Width
  set_property tooltip "Set the Maximum width (in number of pixels) of the OSD output." $SCREEN_WIDTH  
}

proc create_Page2 {IpView} {
	set Page2 [ ipgui::add_page $IpView  -name "Page2" ]
	set_property display_name "Screen Layout Options" $Page2
	# set Group4 [ipgui::add_group $IpView -name Group4 -parent $Page2 -layout horizontal]
	# set_property display_name "Constant/Default Screen Layout Options" $Group4


	# ipgui::add_row $IpView -parent $Page2
	set Group5 [ipgui::add_group $IpView -name Group5 -parent $Page2 -layout vertical]
	set_property display_name "Background Size" $Group5
	set M_AXIS_VIDEO_WIDTH [ipgui::add_param $IpView -parent $Group5 -name M_AXIS_VIDEO_WIDTH  ]
	set_property display_name "Width" $M_AXIS_VIDEO_WIDTH
	set M_AXIS_VIDEO_HEIGHT [ipgui::add_param $IpView -parent $Group5 -name M_AXIS_VIDEO_HEIGHT ]
	set_property display_name "Height" $M_AXIS_VIDEO_HEIGHT
	
	ipgui::add_row $IpView -parent $Page2
	set Group6 [ipgui::add_group $IpView -name Group6 -parent $Page2 ]
	set_property display_name "Background Color" $Group6
	set BG_COLOR0 [ipgui::add_param $IpView -parent $Group6 -name BG_COLOR0]
	set_property display_name "Luma (Y)" $BG_COLOR0
	set BG_COLOR1 [ipgui::add_param $IpView -parent $Group6 -name BG_COLOR1]
	set_property display_name "Cb (U)" $BG_COLOR1
	set BG_COLOR2 [ipgui::add_param $IpView -parent $Group6 -name BG_COLOR2]
	set_property display_name "Cr (V)" $BG_COLOR2


	variable table
	#set table [ipgui::add_table $IpView  -name "Layer Table" -rows "9" -columns "9" -parent $Page2 -table_header true]
	set table [ipgui::add_table $IpView  -name "Layer Table" -rows "9" -columns "9" -parent $Page2]
	
	ipgui::add_static_text  $IpView -name Layer -parent $table -text "Layer" -center_align true
	ipgui::add_static_text  $IpView -name Horizontal -parent $table -text "Horizontal\nPosition" -center_align true
	ipgui::add_static_text  $IpView -name Vertical -parent $table -text "Vertical\nPosition" -center_align true
	ipgui::add_static_text  $IpView -name Width -parent $table -text "Width" -center_align true
	ipgui::add_static_text  $IpView -name Height -parent $table -text "Height" -center_align true
	ipgui::add_static_text  $IpView -name LayerPriority -parent $table -text "Layer\nPriority" -center_align true
	ipgui::add_static_text  $IpView -name LayerEnable -parent $table -text "Layer\nEnable" -center_align true
	ipgui::add_static_text  $IpView -name GAlphaValue -parent $table -text "Global Alpha\nValue" -center_align true
	ipgui::add_static_text  $IpView -name GAlphaEnable -parent $table -text "Global Alpha\nEnable" -center_align true

	set_property cell_location "0,0" [ipgui::get_textspec Layer -of $IpView]		
	set_property cell_location "0,1" [ipgui::get_textspec Horizontal -of $IpView]		
	set_property cell_location "0,2" [ipgui::get_textspec Vertical -of $IpView]
	set_property cell_location "0,3" [ipgui::get_textspec Width -of $IpView]
	set_property cell_location "0,4" [ipgui::get_textspec Height -of $IpView]
	set_property cell_location "0,5" [ipgui::get_textspec LayerPriority -of $IpView]
	set_property cell_location "0,6" [ipgui::get_textspec LayerEnable -of $IpView]
	set_property cell_location "0,7" [ipgui::get_textspec GAlphaValue -of $IpView]
	set_property cell_location "0,8" [ipgui::get_textspec GAlphaEnable -of $IpView]

		foreach i {0 1 2 3 4 5 6 7} {
		EvalSubstituting { i } {
			set a [expr $i + 1]
			ipgui::add_static_text  $IpView -name Layer$i -parent  $table -text "$i" -center_align true
			set_property cell_location "$a,0" [ipgui::get_textspec Layer$i -of $IpView] 
				
			set LAYER$i_HORIZONTAL_START_POSITION [ipgui::add_param $IpView -parent $table -name LAYER$i_HORIZONTAL_START_POSITION  -show_range false]
			set_property cell_location "$a,1" [ipgui::get_paramspec LAYER$i_HORIZONTAL_START_POSITION -of $IpView]
			
			set LAYER$i_VERTICAL_START_POSITION [ipgui::add_param $IpView -parent $table -name LAYER$i_VERTICAL_START_POSITION -show_range false ]
			set_property cell_location "$a,2" [ipgui::get_paramspec LAYER$i_VERTICAL_START_POSITION -of $IpView]
			
			set LAYER$i_WIDTH [ipgui::add_param $IpView -parent $table -name LAYER$i_WIDTH -show_range false]
			set_property cell_location "$a,3" [ipgui::get_paramspec LAYER$i_WIDTH -of $IpView]
			
			set LAYER$i_HEIGHT [ipgui::add_param $IpView -parent $table -name LAYER$i_HEIGHT -show_range false]
			set_property cell_location "$a,4" [ipgui::get_paramspec LAYER$i_HEIGHT -of $IpView]
			
			set LAYER$i_PRIORITY [ipgui::add_param $IpView -parent $table -name LAYER$i_PRIORITY -show_range false]
			set_property cell_location "$a,5" [ipgui::get_paramspec LAYER$i_PRIORITY -of $IpView]
			
			set LAYER$i_ENABLE [ipgui::add_param $IpView -parent $table -name LAYER$i_ENABLE -show_range false]
			set_property cell_location "$a,6" [ipgui::get_paramspec LAYER$i_ENABLE -of $IpView]
			
			set LAYER$i_GLOBAL_ALPHA_VALUE [ipgui::add_param $IpView -parent $table -name LAYER$i_GLOBAL_ALPHA_VALUE -show_range false]
			set_property cell_location "$a,7" [ipgui::get_paramspec LAYER$i_GLOBAL_ALPHA_VALUE -of $IpView]
			
			set LAYER$i_GLOBAL_ALPHA_ENABLE [ipgui::add_param $IpView -parent $table -name LAYER$i_GLOBAL_ALPHA_ENABLE -show_range false]
			set_property cell_location "$a,8" [ipgui::get_paramspec LAYER$i_GLOBAL_ALPHA_ENABLE -of $IpView]

			set_property tooltip  "Set the Horizontal Pixel of the upper-left corner of layer $i. Valid range is ([get_property range $LAYER$i_HORIZONTAL_START_POSITION])." $LAYER$i_HORIZONTAL_START_POSITION
			set_property tooltip  "Set the Vertical Line of the upper-left corner of layer $i. Valid range is ([get_property range $LAYER$i_VERTICAL_START_POSITION])." $LAYER$i_VERTICAL_START_POSITION
			set_property tooltip  "Set the width of layer $i. Valid range is ([get_property range $LAYER$i_WIDTH])." $LAYER$i_WIDTH
			set_property tooltip  "Set the height of layer $i. Valid range is ([get_property range $LAYER$i_HEIGHT])." $LAYER$i_HEIGHT
			set_property tooltip  "Set the priority of layer $i. Higher priority layers will appear on top of lower priority layers. Valid range is ([get_property range $LAYER$i_PRIORITY])." $LAYER$i_PRIORITY
			set_property tooltip  "Sets the layer global alpha value for layer $i. Valid when the Global Alpha Enable is set. Valid range is ([get_property range $LAYER$i_GLOBAL_ALPHA_VALUE])." $LAYER$i_GLOBAL_ALPHA_VALUE
			set_property tooltip  "Enable the global alpha value for layer $i. This value is used for all pixels.  Any pixel-level alpha received on the AXI4-Stream interface is ignored when this parameter is set." $LAYER$i_GLOBAL_ALPHA_ENABLE 
			set_property tooltip  "Enable the layer to show on screen for layer $i." $LAYER$i_ENABLE
				
			} 0
		
		}
		
		set_property hidden_rows "2,3,4,5,6,7,8" $table
	# ipgui::add_static_text $IpView -parent $Group4 -name blank0 -text "  "
	#ipgui::add_static_text $IpView -parent $Group4 -name Horizontal -text "Horizontal"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank1 -text " "
	#ipgui::add_static_text $IpView -parent $Group4 -name Vertical -text "Vertical"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank2 -text " "
	#ipgui::add_static_text $IpView -parent $Group4 -name Width -text "Width"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank3 -text ""
	#ipgui::add_static_text $IpView -parent $Group4 -name Height -text "Height"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank4 -text ""
	#ipgui::add_static_text $IpView -parent $Group4 -name Priority -text "  Layer\n Priority"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank5 -text "  "
	#ipgui::add_static_text $IpView -parent $Group4 -name Enable -text "  Layer\n Enable"
	# ipgui::add_static_text $IpView -parent $Group4 -name blank6 -text ""
	#ipgui::add_static_text $IpView -parent $Group4 -name Value -text "Global Alpha\n    Value"
	#ipgui::add_static_text $IpView -parent $Group4 -name blank7 -text ""
	#ipgui::add_static_text $IpView -parent $Group4 -name Enable -text "Global Alpha\n    Enable"
	#ipgui::add_row $IpView -parent $Group4
	#foreach i {0 1 2 3 4 5 6 7} {
	#	EvalSubstituting { i } {
	#		set LAYER$i_HORIZONTAL_START_POSITION [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_HORIZONTAL_START_POSITION  -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_HORIZONTAL_START_POSITION
	#		set LAYER$i_VERTICAL_START_POSITION [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_VERTICAL_START_POSITION -show_range false ]
	#		set_property display_name "LAYER $i" $LAYER$i_VERTICAL_START_POSITION
	#		set LAYER$i_WIDTH [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_WIDTH -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_WIDTH
	#		set LAYER$i_HEIGHT [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_HEIGHT -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_HEIGHT
	#		set LAYER$i_PRIORITY [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_PRIORITY -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_PRIORITY
	#		set LAYER$i_ENABLE [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_ENABLE -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_ENABLE
	#		set LAYER$i_GLOBAL_ALPHA_VALUE [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_GLOBAL_ALPHA_VALUE -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_GLOBAL_ALPHA_VALUE
	#		set LAYER$i_GLOBAL_ALPHA_ENABLE [ipgui::add_param $IpView -parent $Group4 -name LAYER$i_GLOBAL_ALPHA_ENABLE -show_range false]
	#		set_property display_name "LAYER $i" $LAYER$i_GLOBAL_ALPHA_ENABLE
	#		ipgui::add_row $IpView -parent $Group4
	#					
	#			set_property tooltip  "Set the priority of layer $i. Higher priority layers will appear on top of lower priority layers." $LAYER$i_PRIORITY
	#			set_property tooltip  "Set the Horizontal Pixel of the upper-left corner of layer $i." $LAYER$i_HORIZONTAL_START_POSITION
	#			set_property tooltip  "Set the Vertical Line of the upper-left corner of layer $i." $LAYER$i_VERTICAL_START_POSITION
	#			set_property tooltip   "Set the width of layer $i." $LAYER$i_WIDTH
	#			set_property tooltip  "Set the height of layer $i." $LAYER$i_HEIGHT
	#			set_property tooltip   "Enable the global alpha value for layer $i. This value is used for all pixels.  Any pixel alpha is ignored." $LAYER$i_GLOBAL_ALPHA_ENABLE 
	#			set_property tooltip   "Enable the layer to show on screen for layer $i." $LAYER$i_ENABLE
	#			set_property tooltip  "Sets the layer height for layer $i." $LAYER$i_GLOBAL_ALPHA_VALUE
	  
	#	} 0
	#}	
	
 
	set_property tooltip   "Set the width (in number of pixels) of the OSD output." $M_AXIS_VIDEO_WIDTH      
	set_property tooltip   "Set the height (in number of lines) of the OSD output." $M_AXIS_VIDEO_HEIGHT     
	set_property tooltip  "Set the background color component value for the G/Y color channel." $BG_COLOR0     
	set_property tooltip  "Set the background color component value for the B/Cb color channel." $BG_COLOR1    
	set_property tooltip  "Set the background color component value for the R/Cr color channel." $BG_COLOR2

} 
 
proc create_Page3 {IpView} {
	variable Page3
	set Page3 [ ipgui::add_page $IpView  -name "Page3" ];#-layout horizontal ]
	set_property display_name "LAYER 0 Options" $Page3
	# set Group7 [ipgui::add_group $IpView -name Group7 -parent $Page3 -layout horizontal]
	# set_property display_name "LAYER 0 Graphics Controller Options" $Group7
	
	set Group8 [ipgui::add_group $IpView -name Group8 -parent $Page3 -layout vertical]
	set_property display_name "Instruction Memory" $Group8
	set LAYER0_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group8 -name LAYER0_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER0_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group8 -name blank8 -text ""
	set Group9 [ipgui::add_group $IpView -name Group9 -parent $Group8 -layout horizontal]
	set_property display_name "Instruction Set" $Group9
	set LAYER0_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group9 -name LAYER0_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER0_BOX_INSTRUCTION_ENABLE
	set LAYER0_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group9 -name LAYER0_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER0_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER0_LINE_INSTRUCTION_ENABLE 
	set LAYER0_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group9 -name LAYER0_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER0_TEXT_INSTRUCTION_ENABLE

	set Group10 [ipgui::add_group $IpView -name Group10 -parent $Page3 ];#-layout horizontal]
	set_property display_name "Color Table" $Group10
	set LAYER0_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group10 -name LAYER0_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER0_COLOR_TABLE_SIZE
	
	# set Group11 [ipgui::add_group $IpView -name Group11 -parent $Group10 -layout vertical]
	# set_property display_name "Color Memory Type" $Group11
	
	set LAYER0_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group10 -name LAYER0_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER0_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page3
	set Group12 [ipgui::add_group $IpView -name Group12 -parent $Page3 -layout vertical]
	set_property display_name "Font Options" $Group12
	set LAYER0_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group12 -name LAYER0_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER0_FONT_NUMBER_OF_CHARACTERS
	# ipgui::add_row $IpView -parent $Group12
	set LAYER0_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group12 -name LAYER0_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER0_FONT_ASCII_OFFSET
	# ipgui::add_row $IpView -parent $Group12
	set LAYER0_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group12 -name LAYER0_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER0_FONT_CHARACTER_WIDTH
	set LAYER0_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group12 -name LAYER0_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER0_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group12
	set LAYER0_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group12 -name LAYER0_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER0_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page3
	set Group13 [ipgui::add_group $IpView -name Group13 -parent $Page3 -layout vertical]
	set_property display_name "Text Options" $Group13
	set LAYER0_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group13 -name LAYER0_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER0_TEXT_NUMBER_OF_STRINGS
	set LAYER0_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group13 -name LAYER0_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER0_TEXT_MAX_STRING_LENGTH
		
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER0_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER0_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER0_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER0_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER0_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER0_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER0_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER0_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER0_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER0_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER0_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER0_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER0_TEXT_MAX_STRING_LENGTH
}
  
proc create_Page4 {IpView} {
	variable Page4
	set Page4 [ ipgui::add_page $IpView  -name "Page4" ]
}
 
proc create_Page5 {IpView} {
	variable Page5
	set Page5 [ ipgui::add_page $IpView  -name "Page5" ];#-layout horizontal]
	set_property display_name "LAYER 1 Options" $Page5
	# set Group14 [ipgui::add_group $IpView -name Group14 -parent $Page5 -layout horizontal]
	# set_property display_name "LAYER 1 Graphics Controller Options" $Group14
	
	set Group15 [ipgui::add_group $IpView -name Group15 -parent $Page5 -layout vertical]
	set_property display_name "Instruction Memory" $Group15
	set LAYER1_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group15 -name LAYER1_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER1_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group15 -name blank9 -text ""
	set Group16 [ipgui::add_group $IpView -name Group16 -parent $Group15 -layout horizontal]
	set_property display_name "Instruction Set" $Group16
	set LAYER1_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group16 -name LAYER1_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER1_BOX_INSTRUCTION_ENABLE
	set LAYER1_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group16 -name LAYER1_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER1_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER1_LINE_INSTRUCTION_ENABLE
	set LAYER1_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group16 -name LAYER1_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER1_TEXT_INSTRUCTION_ENABLE

	set Group17 [ipgui::add_group $IpView -name Group17 -parent $Page5 ];#-layout horizontal]
	set_property display_name "Color Table" $Group17
	set LAYER1_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group17 -name LAYER1_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER1_COLOR_TABLE_SIZE
	# set Group18 [ipgui::add_group $IpView -name Group18 -parent $Group17]
	
	set LAYER1_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group17 -name LAYER1_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER1_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page5
	set Group19 [ipgui::add_group $IpView -name Group19 -parent $Page5 -layout vertical]
	set_property display_name "Font Options" $Group19
	set LAYER1_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group19 -name LAYER1_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER1_FONT_NUMBER_OF_CHARACTERS
	set LAYER1_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group19 -name LAYER1_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER1_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group19
	set LAYER1_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group19 -name LAYER1_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER1_FONT_CHARACTER_WIDTH
	set LAYER1_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group19 -name LAYER1_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER1_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group19
	set LAYER1_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group19 -name LAYER1_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER1_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page5
	set Group20 [ipgui::add_group $IpView -name Group20 -parent $Page5 -layout vertical]
	set_property display_name "Text Options" $Group20
	set LAYER1_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group20 -name LAYER1_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER1_TEXT_NUMBER_OF_STRINGS
	set LAYER1_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group20 -name LAYER1_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER1_TEXT_MAX_STRING_LENGTH
 
		set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER1_INSTRUCTION_MEMORY_SIZE
		set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER1_BOX_INSTRUCTION_ENABLE
		set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER1_LINE_INSTRUCTION_ENABLE
		set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER1_TEXT_INSTRUCTION_ENABLE
		set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER1_COLOR_TABLE_SIZE
		set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER1_COLOR_TABLE_MEMORY_TYPE
		set_property tooltip  "Set the size number of characters in the font." $LAYER1_FONT_NUMBER_OF_CHARACTERS
		set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER1_FONT_CHARACTER_WIDTH
		set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER1_FONT_CHARACTER_HEIGHT
		set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER1_FONT_BITS_PER_PIXEL
		set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER1_FONT_ASCII_OFFSET
		set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER1_TEXT_NUMBER_OF_STRINGS
		set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER1_TEXT_MAX_STRING_LENGTH
}
 
proc create_Page6 {IpView} {
  variable Page6
  set Page6 [ ipgui::add_page $IpView  -name "Page6" ]
}
 
proc create_Page7 {IpView} {
  variable Page7
  set Page7 [ ipgui::add_page $IpView  -name "Page7" ];#-layout horizontal]
  set_property display_name "LAYER 2 Options" $Page7
  # set Group21 [ipgui::add_group $IpView -name Group21 -parent $Page7 -layout horizontal]
	# set_property display_name "LAYER 2 Graphics Controller Options" $Page7
	
	set Group22 [ipgui::add_group $IpView -name Group22 -parent $Page7 -layout vertical]
	set_property display_name "Instruction Memory" $Group22
	set LAYER2_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group22 -name LAYER2_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER2_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group22 -name blank10 -text ""
	set Group23 [ipgui::add_group $IpView -name Group23 -parent $Group22 -layout horizontal]
	set_property display_name "Instruction Set" $Group23
	set LAYER2_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group23 -name LAYER2_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER2_BOX_INSTRUCTION_ENABLE
	set LAYER2_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group23 -name LAYER2_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER2_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER2_LINE_INSTRUCTION_ENABLE
	set LAYER2_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group23 -name LAYER2_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER2_TEXT_INSTRUCTION_ENABLE

	set Group24 [ipgui::add_group $IpView -name Group24 -parent $Page7];# -layout horizontal]
	set_property display_name "Color Table" $Group24
	set LAYER2_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group24 -name LAYER2_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER2_COLOR_TABLE_SIZE
	# set Group25 [ipgui::add_group $IpView -name Group25 -parent $Group24]
	
	set LAYER2_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group24 -name LAYER2_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER2_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER2_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page7
	set Group26 [ipgui::add_group $IpView -name Group26 -parent $Page7 -layout vertical]
	set_property display_name "Font Options" $Group26
	set LAYER2_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group26 -name LAYER2_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER2_FONT_NUMBER_OF_CHARACTERS
	set LAYER2_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group26 -name LAYER2_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER2_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group26
	set LAYER2_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group26 -name LAYER2_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER2_FONT_CHARACTER_WIDTH
	set LAYER2_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group26 -name LAYER2_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER2_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group26
	set LAYER2_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group26 -name LAYER2_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER2_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page7
	set Group27 [ipgui::add_group $IpView -name Group27 -parent $Page7 -layout vertical]
	set_property display_name "Text Options" $Group27
	set LAYER2_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group27 -name LAYER2_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER2_TEXT_NUMBER_OF_STRINGS
	set LAYER2_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group27 -name LAYER2_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER2_TEXT_MAX_STRING_LENGTH
	
 
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER2_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER2_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER2_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER2_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER2_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER2_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER2_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER2_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER2_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER2_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER2_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER2_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER2_TEXT_MAX_STRING_LENGTH
}
 
proc create_Page8 {IpView} {
	variable Page8
	set Page8 [ ipgui::add_page $IpView  -name "Page8" ]
}
 
proc create_Page9 {IpView} {
	variable Page9
	set Page9 [ ipgui::add_page $IpView  -name "Page9" ];#-layout horizontal]
	set_property display_name "LAYER 3 Options" $Page9
	# set Group28 [ipgui::add_group $IpView -name Group28 -parent $Page9 -layout horizontal]
	# set_property display_name "LAYER 3 Graphics Controller Options" $Page9
	
	set Group29 [ipgui::add_group $IpView -name Group29 -parent $Page9 -layout vertical]
	set_property display_name "Instruction Memory" $Group29
	set LAYER3_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group29 -name LAYER3_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER3_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group29 -name blank11 -text ""
	set Group30 [ipgui::add_group $IpView -name Group30 -parent $Group29 -layout horizontal]
	set_property display_name "Instruction Set" $Group30
	set LAYER3_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group30 -name LAYER3_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER3_BOX_INSTRUCTION_ENABLE
	set LAYER3_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group30 -name LAYER3_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER3_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER3_LINE_INSTRUCTION_ENABLE
	set LAYER3_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group30 -name LAYER3_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER3_TEXT_INSTRUCTION_ENABLE

	set Group31 [ipgui::add_group $IpView -name Group31 -parent $Page9 ];#-layout horizontal]
	set_property display_name "Color Table" $Group31
	set LAYER3_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group31 -name LAYER3_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER3_COLOR_TABLE_SIZE
	# set Group32 [ipgui::add_group $IpView -name Group32 -parent $Group31]
	
	set LAYER3_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group31 -name LAYER3_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER3_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER3_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page9
	set Group33 [ipgui::add_group $IpView -name Group33 -parent $Page9 -layout vertical]
	set_property display_name "Font Options" $Group33
	set LAYER3_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group33 -name LAYER3_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER3_FONT_NUMBER_OF_CHARACTERS
	set LAYER3_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group33 -name LAYER3_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER3_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group33
	set LAYER3_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group33 -name LAYER3_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER3_FONT_CHARACTER_WIDTH
	set LAYER3_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group33 -name LAYER3_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER3_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group33
	set LAYER3_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group33 -name LAYER3_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER3_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page9
	set Group34 [ipgui::add_group $IpView -name Group34 -parent $Page9 -layout vertical]
	set_property display_name "Text Options" $Group34
	set LAYER3_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group34 -name LAYER3_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER3_TEXT_NUMBER_OF_STRINGS
	set LAYER3_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group34 -name LAYER3_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER3_TEXT_MAX_STRING_LENGTH
	
 
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER3_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER3_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER3_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER3_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER3_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER3_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER3_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER3_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER3_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER3_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER3_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER3_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER3_TEXT_MAX_STRING_LENGTH
}
 
proc create_Page10 {IpView} {
	variable Page10
	set Page10 [ ipgui::add_page $IpView  -name "Page10" ]
}
 
proc create_Page11 {IpView} {
	variable Page11
	set Page11 [ ipgui::add_page $IpView  -name "Page11" ];#-layout horizontal]
	set_property display_name "LAYER 4 Options" $Page11
	# set Group35 [ipgui::add_group $IpView -name Group35 -parent $Page11  -layout horizontal]
	# set_property display_name "LAYER 4 Graphics Controller Options" $Page11
	
	set Group36 [ipgui::add_group $IpView -name Group36 -parent $Page11 -layout vertical]
	set_property display_name "Instruction Memory" $Group36
	set LAYER4_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group36 -name LAYER4_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER4_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group36 -name blank12 -text ""
	set Group37 [ipgui::add_group $IpView -name Group37 -parent $Group36 -layout horizontal]
	set_property display_name "Instruction Set" $Group37
	set LAYER4_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group37 -name LAYER4_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER4_BOX_INSTRUCTION_ENABLE
	set LAYER4_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group37 -name LAYER4_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER4_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER4_LINE_INSTRUCTION_ENABLE
	set LAYER4_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group37 -name LAYER4_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER4_TEXT_INSTRUCTION_ENABLE

	set Group38 [ipgui::add_group $IpView -name Group38 -parent $Page11 ];#-layout horizontal]
	set_property display_name "Color Table" $Group38
	set LAYER4_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group38 -name LAYER4_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER4_COLOR_TABLE_SIZE
	# set Group39 [ipgui::add_group $IpView -name Group39 -parent $Group38]
	
	set LAYER4_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group38 -name LAYER4_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER4_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER4_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page11
	set Group40 [ipgui::add_group $IpView -name Group40 -parent $Page11 -layout vertical]
	set_property display_name "Font Options" $Group40
	set LAYER4_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group40 -name LAYER4_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER4_FONT_NUMBER_OF_CHARACTERS
	set LAYER4_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group40 -name LAYER4_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER4_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group40
	set LAYER4_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group40 -name LAYER4_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER4_FONT_CHARACTER_WIDTH
	set LAYER4_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group40 -name LAYER4_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER4_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group40
	set LAYER4_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group40 -name LAYER4_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER4_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page11
	set Group41 [ipgui::add_group $IpView -name Group41 -parent $Page11 -layout vertical]
	set_property display_name "Text Options" $Group41
	set LAYER4_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group41 -name LAYER4_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER4_TEXT_NUMBER_OF_STRINGS
	set LAYER4_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group41 -name LAYER4_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER4_TEXT_MAX_STRING_LENGTH
	
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER4_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER4_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER4_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER4_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER4_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER4_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER4_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER4_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER4_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER4_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER4_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER4_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER4_TEXT_MAX_STRING_LENGTH
}

proc create_Page12 {IpView} {
	variable Page12
	set Page12 [ ipgui::add_page $IpView  -name "Page12" ]
}
 
proc create_Page13 {IpView} {
	variable Page13
	set Page13 [ ipgui::add_page $IpView  -name "Page13" ];#-layout horizontal]
	set_property display_name "LAYER 5 Options" $Page13
	# set Group42 [ipgui::add_group $IpView -name Group42 -parent $Page13 -layout horizontal]
	# set_property display_name "LAYER 5 Graphics Controller Options" $Page13
	
	set Group43 [ipgui::add_group $IpView -name Group43 -parent $Page13 -layout vertical]
	set_property display_name "Instruction Memory" $Group43
	set LAYER5_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group43 -name LAYER5_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER5_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group43 -name blank13 -text ""
	set Group44 [ipgui::add_group $IpView -name Group44 -parent $Group43 -layout horizontal]
	set_property display_name "Instruction Set" $Group44
	set LAYER5_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group44 -name LAYER5_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER5_BOX_INSTRUCTION_ENABLE
	set LAYER5_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group44 -name LAYER5_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER5_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER5_LINE_INSTRUCTION_ENABLE
	set LAYER5_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group44 -name LAYER5_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER5_TEXT_INSTRUCTION_ENABLE

	set Group45 [ipgui::add_group $IpView -name Group45 -parent $Page13];# -layout horizontal]
	set_property display_name "Color Table" $Group45
	set LAYER5_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group45 -name LAYER5_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER5_COLOR_TABLE_SIZE
	# set Group46 [ipgui::add_group $IpView -name Group46 -parent $Group45]
	
	set LAYER5_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group45 -name LAYER5_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER5_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER5_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page13
	set Group47 [ipgui::add_group $IpView -name Group47 -parent $Page13 -layout vertical]
	set_property display_name "Font Options" $Group47
	set LAYER5_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group47 -name LAYER5_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER5_FONT_NUMBER_OF_CHARACTERS
	set LAYER5_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group47 -name LAYER5_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER5_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group47
	set LAYER5_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group47 -name LAYER5_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER5_FONT_CHARACTER_WIDTH
	set LAYER5_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group47 -name LAYER5_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER5_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group47
	set LAYER5_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group47 -name LAYER5_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER5_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page13
	set Group48 [ipgui::add_group $IpView -name Group48 -parent $Page13 -layout vertical]
	set_property display_name "Text Options" $Group48
	set LAYER5_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group48 -name LAYER5_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER5_TEXT_NUMBER_OF_STRINGS
	set LAYER5_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group48 -name LAYER5_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER5_TEXT_MAX_STRING_LENGTH

	
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER5_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER5_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER5_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER5_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER5_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER5_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER5_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER5_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER5_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER5_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER5_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER5_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER5_TEXT_MAX_STRING_LENGTH
}
  
proc create_Page14 {IpView} {
	variable Page14
	set Page14 [ ipgui::add_page $IpView  -name "Page14" ]
}

proc create_Page15 {IpView} {
	variable Page15
	set Page15 [ ipgui::add_page $IpView  -name "Page15" ];#-layout horizontal]
	set_property display_name "LAYER 6 Options" $Page15
	# set Group49 [ipgui::add_group $IpView -name Group49 -parent $Page15 -layout horizontal]
	# set_property display_name "LAYER 6 Graphics Controller Options" $Page15
	
	set Group50 [ipgui::add_group $IpView -name Group50 -parent $Page15 -layout vertical]
	set_property display_name "Instruction Memory" $Group50
	set LAYER6_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group50 -name LAYER6_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER6_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group50 -name blank14 -text ""
	set Group51 [ipgui::add_group $IpView -name Group51 -parent $Group50 -layout horizontal]
	set_property display_name "Instruction Set" $Group51
	set LAYER6_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group51 -name LAYER6_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER6_BOX_INSTRUCTION_ENABLE
	set LAYER6_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group51 -name LAYER6_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER6_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER6_LINE_INSTRUCTION_ENABLE
	set LAYER6_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group51 -name LAYER6_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER6_TEXT_INSTRUCTION_ENABLE

	set Group52 [ipgui::add_group $IpView -name Group52 -parent $Page15];# -layout horizontal]
	set_property display_name "Color Table" $Group52
	set LAYER6_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group52 -name LAYER6_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER6_COLOR_TABLE_SIZE
	# set Group53 [ipgui::add_group $IpView -name Group53 -parent $Group52]
	
	set LAYER6_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group52 -name LAYER6_COLOR_TABLE_MEMORY_TYPE -widget comboBox]
	set_property display_name "Color Memory Type" $LAYER6_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER6_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page15
	set Group54 [ipgui::add_group $IpView -name Group54 -parent $Page15 -layout vertical]
	set_property display_name "Font Options" $Group54
	set LAYER6_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group54 -name LAYER6_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER6_FONT_NUMBER_OF_CHARACTERS
	set LAYER6_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group54 -name LAYER6_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER6_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group54
	set LAYER6_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group54 -name LAYER6_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER6_FONT_CHARACTER_WIDTH
	set LAYER6_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group54 -name LAYER6_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER6_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group54
	set LAYER6_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group54 -name LAYER6_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER6_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page15
	set Group55 [ipgui::add_group $IpView -name Group55 -parent $Page15 -layout vertical]
	set_property display_name "Text Options" $Group55
	set LAYER6_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group55 -name LAYER6_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER6_TEXT_NUMBER_OF_STRINGS
	set LAYER6_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group55 -name LAYER6_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER6_TEXT_MAX_STRING_LENGTH

	
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER6_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER6_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER6_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER6_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER6_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER6_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER6_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER6_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER6_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER6_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER6_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER6_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER6_TEXT_MAX_STRING_LENGTH
}
 
proc create_Page16 {IpView} {
	variable Page16
	set Page16 [ ipgui::add_page $IpView  -name "Page16" ]
}
 
proc create_Page17 {IpView} {
	variable Page17
	set Page17 [ ipgui::add_page $IpView  -name "Page17" ];#-layout horizontal]
	set_property display_name "LAYER 7 Options" $Page17
	# set Group56 [ipgui::add_group $IpView -name Group56 -parent $Page17 -layout horizontal]
	# set_property display_name "LAYER 7 Graphics Controller Options" $Page17
	
	set Group57 [ipgui::add_group $IpView -name Group57 -parent $Page17 -layout vertical]
	set_property display_name "Instruction Memory" $Group57
	set LAYER7_INSTRUCTION_MEMORY_SIZE [ipgui::add_param $IpView -parent $Group57 -name LAYER7_INSTRUCTION_MEMORY_SIZE ]
	set_property display_name "Instructions" $LAYER7_INSTRUCTION_MEMORY_SIZE
	# ipgui::add_static_text $IpView -parent $Group57 -name blank15 -text ""
	set Group58 [ipgui::add_group $IpView -name Group58 -parent $Group57 -layout horizontal]
	set_property display_name "Instruction Set" $Group58
	set LAYER7_BOX_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group58 -name LAYER7_BOX_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Box" $LAYER7_BOX_INSTRUCTION_ENABLE
	set LAYER7_LINE_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group58 -name LAYER7_LINE_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Line" $LAYER7_LINE_INSTRUCTION_ENABLE
	set_property visible false $LAYER7_LINE_INSTRUCTION_ENABLE
	set LAYER7_TEXT_INSTRUCTION_ENABLE [ipgui::add_param $IpView -parent $Group58 -name LAYER7_TEXT_INSTRUCTION_ENABLE -widget checkBox]
	set_property display_name "Text" $LAYER7_TEXT_INSTRUCTION_ENABLE

	set Group59 [ipgui::add_group $IpView -name Group59 -parent $Page17];# -layout horizontal]
	set_property display_name "Color Table" $Group59
	set LAYER7_COLOR_TABLE_SIZE [ipgui::add_param $IpView -parent $Group59 -name LAYER7_COLOR_TABLE_SIZE -widget comboBox]
	set_property display_name "Number of Colors" $LAYER7_COLOR_TABLE_SIZE
	# set Group60 [ipgui::add_group $IpView -name Group60 -parent $Group59]
	
	set LAYER7_COLOR_TABLE_MEMORY_TYPE [ipgui::add_param $IpView -parent $Group59 -name LAYER7_COLOR_TABLE_MEMORY_TYPE -widget comboBox ]
	set_property display_name "Color Memory Type" $LAYER7_COLOR_TABLE_MEMORY_TYPE
	# set_property display_name "Box" $LAYER7_COLOR_TABLE_MEMORY_TYPE
	
	ipgui::add_row $IpView -parent $Page17
	set Group61 [ipgui::add_group $IpView -name Group61 -parent $Page17 -layout vertical]
	set_property display_name "Font Options" $Group61
	set LAYER7_FONT_NUMBER_OF_CHARACTERS [ipgui::add_param $IpView -parent $Group61 -name LAYER7_FONT_NUMBER_OF_CHARACTERS ]
	set_property display_name "Number of Characters" $LAYER7_FONT_NUMBER_OF_CHARACTERS
	set LAYER7_FONT_ASCII_OFFSET [ipgui::add_param $IpView -parent $Group61 -name LAYER7_FONT_ASCII_OFFSET ]
	set_property display_name "ASCII Offset" $LAYER7_FONT_ASCII_OFFSET
	ipgui::add_row $IpView -parent $Group61
	set LAYER7_FONT_CHARACTER_WIDTH [ipgui::add_param $IpView -parent $Group61 -name LAYER7_FONT_CHARACTER_WIDTH -widget comboBox]
	set_property display_name "Character Width" $LAYER7_FONT_CHARACTER_WIDTH
	set LAYER7_FONT_BITS_PER_PIXEL [ipgui::add_param $IpView -parent $Group61 -name LAYER7_FONT_BITS_PER_PIXEL -widget comboBox]
	set_property display_name "Bits per Pixel" $LAYER7_FONT_BITS_PER_PIXEL
	ipgui::add_row $IpView -parent $Group61
	set LAYER7_FONT_CHARACTER_HEIGHT [ipgui::add_param $IpView -parent $Group61 -name LAYER7_FONT_CHARACTER_HEIGHT -widget comboBox]
	set_property display_name "Character Height" $LAYER7_FONT_CHARACTER_HEIGHT
	
	ipgui::add_row $IpView -parent $Page17
	set Group62 [ipgui::add_group $IpView -name Group62 -parent $Page17 -layout vertical]
	set_property display_name "Text Options" $Group62
	set LAYER7_TEXT_NUMBER_OF_STRINGS [ipgui::add_param $IpView -parent $Group62 -name LAYER7_TEXT_NUMBER_OF_STRINGS ]
	set_property display_name "Number of Strings" $LAYER7_TEXT_NUMBER_OF_STRINGS
	set LAYER7_TEXT_MAX_STRING_LENGTH [ipgui::add_param $IpView -parent $Group62 -name LAYER7_TEXT_MAX_STRING_LENGTH -widget comboBox]
	set_property display_name "Maximum String Length" $LAYER7_TEXT_MAX_STRING_LENGTH

		
	set_property tooltip "Set the size of the instruction RAM/ROM in a number of 32-bit instructions words." $LAYER7_INSTRUCTION_MEMORY_SIZE
	set_property tooltip  "Enable the Graphics Controller to recognize the box instruction. If the box instruction is not enabled and a box instruction is programmed, then this instruction will be treated as a no op." $LAYER7_BOX_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the line instruction. If the line instruction is not enabled and a line instruction is programmed, then this instruction will be treated as a no op." $LAYER7_LINE_INSTRUCTION_ENABLE
	set_property tooltip  "Enable the Graphics Controller to recognize the text instruction. If the text instruction is not enabled and a text instruction is programmed, then this instruction will be treated as a no op." $LAYER7_TEXT_INSTRUCTION_ENABLE
	set_property tooltip  "Set the size of the color look up table. Each color will require storage space for the number of data/alpha channels x data width." $LAYER7_COLOR_TABLE_SIZE
	set_property tooltip  "Select whether the Color look-up-table (palette) will use Block Memory, Distributed Memory, or auto-configure based on size." $LAYER7_COLOR_TABLE_MEMORY_TYPE
	set_property tooltip  "Set the size number of characters in the font." $LAYER7_FONT_NUMBER_OF_CHARACTERS
	set_property tooltip  "Set the width (in pixels) of each character in the font." $LAYER7_FONT_CHARACTER_WIDTH
	set_property tooltip  "Set the height (in lines) of each character in the font." $LAYER7_FONT_CHARACTER_HEIGHT
	set_property tooltip  "Set the bits per pixel of each character in the font." $LAYER7_FONT_BITS_PER_PIXEL
	set_property tooltip  "Set ASCII Offset of the font. This value corresponds to the ASCII value of the first character in the font." $LAYER7_FONT_ASCII_OFFSET
	set_property tooltip  "Set number of strings supported by the Graphics Controller." $LAYER7_TEXT_NUMBER_OF_STRINGS
	set_property tooltip  "Set maximum string length supported by the Graphics Controller (including the NULL terminator)." $LAYER7_TEXT_MAX_STRING_LENGTH
}
 
	
proc validate_Component_Name {IpView } {
   set errStr [ipgui::component_validate [get_property value [ipgui::get_paramspec Component_Name -of $IpView ]] ]
   if  { $errStr == "" } { 
     return true 
   } else { 
     set_property errmsg $errStr  [ipgui::get_paramspec Component_Name -of $IpView ]
     return false 
   }
}
 
proc updateOf_LAYER_TYPE {IpView} { 
 set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
 set HAS_AXI4_LITE [get_param_value HAS_AXI4_LITE]
 
	foreach layer {0 1 2 3 4 5 6 7} {
		EvalSubstituting { layer } {
			set LAYER_TYPE [ipgui::get_paramspec -name LAYER${layer}_TYPE -of $IpView]
			if {$HAS_AXI4_LITE  == true } {
				set_property enabled true $LAYER_TYPE		
			} else {
				set_property enabled false $LAYER_TYPE		
				set_property value "External_AXIS" $LAYER_TYPE		
			}

			if {$NUMBER_OF_LAYERS  > $layer } {
				set_property visible true $LAYER_TYPE		
			} else {
				set_property visible false $LAYER_TYPE		
			}		
		} 0
	}
}
 
proc  HAS_AXI4_LITE_updated {IpView} {
	updateOf_LAYER_TYPE $IpView
	updateOfLAYER_ENABLE $IpView
}


  proc updateOfM_AXIS_VIDEO_WIDTH {IpView} {
				set M_AXIS_VIDEO_WIDTH [ipgui::get_paramspec -name M_AXIS_VIDEO_WIDTH -of $IpView]
      	set SCREEN_WIDTH [get_param_value SCREEN_WIDTH]

				set_property range 0,$SCREEN_WIDTH $M_AXIS_VIDEO_WIDTH

  }

proc  S_AXIS_VIDEO_FORMAT_updated {IpView} {
	updateOfBGcolors $IpView
}

proc  SCREEN_WIDTH_updated {IpView} {
	updateOfM_AXIS_VIDEO_WIDTH $IpView
	updateOfLAYER_HORIZONTAL_START_POSITION $IpView
	foreach layer {0 1 2 3 4 5 6 7} {
		updateOfLAYER${layer}_WIDTH $IpView
	}

}
proc  M_AXIS_VIDEO_WIDTH_updated {IpView} {
	updateOfLAYER_HORIZONTAL_START_POSITION $IpView
	foreach layer {0 1 2 3 4 5 6 7} {
		updateOfLAYER${layer}_WIDTH $IpView
	}
}
 
proc Data_Channel_Width_updated {IpView} {
	foreach layer {0 1 2 3 4 5 6 7} {
		updateOfLAYER${layer}_GLOBAL_ALPHA_VALUE $IpView
	}
	updateOfBGcolors $IpView
}
 
 
 
##########
# The hiding of table rows is done only at updateOfLAYER_HORIZONTAL_START_POSITION proc

	proc updateOfLAYER_HORIZONTAL_START_POSITION {IpView} {
	variable table
		foreach layer {0 1 2 3 4 5 6 7} {
			EvalSubstituting { layer } {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set M_AXIS_VIDEO_WIDTH [get_param_value M_AXIS_VIDEO_WIDTH]
				set LAYER_HORIZONTAL_START_POSITION [ipgui::get_paramspec -name LAYER${layer}_HORIZONTAL_START_POSITION -of $IpView]
				set max [ expr $M_AXIS_VIDEO_WIDTH  - 1 ]
        if {$max < 0} {
				  set SCREEN_WIDTH [get_param_value SCREEN_WIDTH]
				  set max [ expr $SCREEN_WIDTH - 1 ]
        }
				set_property range 0,$max $LAYER_HORIZONTAL_START_POSITION	
				 if { $NUMBER_OF_LAYERS   > $layer } {
					set list {2 3 4 5 6 7 8}
					set_property hidden_rows "" $table
					set index [tcl::lsearch $list [get_param_value NUMBER_OF_LAYERS ]]
					set list [tcl::lreplace $list 0 $index]
					set list [regsub -all " " $list ","]
					set_property hidden_rows "$list" $table
					set_property enabled true $LAYER_HORIZONTAL_START_POSITION	
					set_property visible true $LAYER_HORIZONTAL_START_POSITION	
			    set_property tooltip  "Set the Horizontal Pixel of the upper-left corner of layer $layer. Valid range is ([get_property range $LAYER_HORIZONTAL_START_POSITION])." $LAYER_HORIZONTAL_START_POSITION
				 } else {
					set_property enabled false $LAYER_HORIZONTAL_START_POSITION	
					set_property visible false $LAYER_HORIZONTAL_START_POSITION	
				 }
			} 0
		}
    }
 
 
	proc updateOfLAYER_VERTICAL_START_POSITION {IpView} {
		foreach layer {0 1 2 3 4 5 6 7} {
			EvalSubstituting { layer } {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]	
				set M_AXIS_VIDEO_HEIGHT [get_param_value M_AXIS_VIDEO_HEIGHT]
				set LAYER_VERTICAL_START_POSITION [ipgui::get_paramspec -name LAYER${layer}_VERTICAL_START_POSITION -of $IpView]				
				set max [ expr $M_AXIS_VIDEO_HEIGHT - 1 ]
				set_property range 0,$max $LAYER_VERTICAL_START_POSITION

				if { $NUMBER_OF_LAYERS   > $layer } {
					set_property enabled true $LAYER_VERTICAL_START_POSITION	
					set_property visible true $LAYER_VERTICAL_START_POSITION	
			    set_property tooltip  "Set the Vertical Line of the upper-left corner of layer $layer. Valid range is ([get_property range $LAYER_VERTICAL_START_POSITION])." $LAYER_VERTICAL_START_POSITION
				} else {
					set_property enabled false $LAYER_VERTICAL_START_POSITION	
					set_property visible false $LAYER_VERTICAL_START_POSITION	
				}
			} 0
		}
    }
 
	proc updateOfLAYER_ENABLE {IpView} {
		foreach layer {0 1 2 3 4 5 6 7} {
			EvalSubstituting { layer } {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]	
				set HAS_AXI4_LITE [get_param_value HAS_AXI4_LITE]	
				set LAYER_ENABLE [ipgui::get_paramspec -name LAYER${layer}_ENABLE -of $IpView]				
				if { $HAS_AXI4_LITE   == true } {
					set_property enabled true $LAYER_ENABLE	
					set_property value false $LAYER_ENABLE	
				} else {
					set_property enabled false $LAYER_ENABLE	
					set_property value true $LAYER_ENABLE
				}
				
				if { $NUMBER_OF_LAYERS  > $layer } {
					set_property visible true $LAYER_ENABLE	
				} else {
					set_property visible false $LAYER_ENABLE	
					set_property value false $LAYER_ENABLE
					set_property enabled false $LAYER_ENABLE
				}
							
			} 0
		}
	}
	
	proc updateOfLAYER_GLOBAL_ALPHA_ENABLE {IpView} {
		foreach layers {0 1 2 3 4 5 6 7} {
			EvalSubstituting { layers } {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]	
				set HAS_AXI4_LITE [get_param_value HAS_AXI4_LITE]	
				set LAYER_TYPE [get_param_value LAYER${layers}_TYPE]	
				set LAYER_GLOBAL_ALPHA_ENABLE [ipgui::get_paramspec -name LAYER${layers}_GLOBAL_ALPHA_ENABLE -of $IpView]				
				if { $LAYER_TYPE  == "Internal_Graphics_Controller" } {
					set_property value false $LAYER_GLOBAL_ALPHA_ENABLE
				} else {
					set_property value true $LAYER_GLOBAL_ALPHA_ENABLE
				}
				if {$NUMBER_OF_LAYERS  > $layers } {
					set_property visible true $LAYER_GLOBAL_ALPHA_ENABLE
					set_property enabled true $LAYER_GLOBAL_ALPHA_ENABLE
				} else {
					set_property visible false $LAYER_GLOBAL_ALPHA_ENABLE
					set_property enabled false $LAYER_GLOBAL_ALPHA_ENABLE
					set_property value false $LAYER_GLOBAL_ALPHA_ENABLE
				}
			} 0
		}
	}
	
	proc validate_BG_COLOR0 {IpView} {
		set maximum_value [ expr round (pow (2, [ get_param_value Data_Channel_Width  ])) - 1 ]
		if { [ get_param_value BG_COLOR0  ] > $maximum_value } {
			set_property errmsg  "The Background Color G/Y must be less than 2**(Data Channel Width)."  [ipgui::get_paramspec BG_COLOR0	-of	$IpView ]
			return false
		}
		return true
	} 
	
	proc validate_BG_COLOR1 {IpView} {
		set maximum_value [ expr round (pow (2, [ get_param_value Data_Channel_Width  ])) - 1 ]
		if { [ get_param_value BG_COLOR1  ] > $maximum_value } {
			set_property errmsg  "The Background Color B/Cb/U must be less than 2**(Data Channel Width)."  [ipgui::get_paramspec BG_COLOR1	-of	$IpView ]
			return false
		}
		return true
	} 
	
	proc validate_BG_COLOR2 {IpView} {
		set maximum_value [ expr round (pow (2, [ get_param_value Data_Channel_Width  ])) - 1 ]
		if { [ get_param_value BG_COLOR2  ] > $maximum_value } {
			set_property errmsg  "The Background Color R/Cr/V must be less than 2**(Data Channel Width)."  [ipgui::get_paramspec BG_COLOR2	-of	$IpView ]
			return false
		}
		return true
	} 
		
	
	foreach layer {0 1 2 3 4 5 6 7} {
		EvalSubstituting { layer } {	
			proc validate_LAYER$layer_PRIORITY {IpView} {
				set current_layer_PRIORITY_value [get_param_value LAYER$layer_PRIORITY ]       
				if {[get_param_value NUMBER_OF_LAYERS]	  > $layer } {        
					for {set slayer_index 0} {$slayer_index < [expr $layer] } {set slayer_index [expr $slayer_index+1] } {
						set slayer_index_PRIORITY_value  [get_param_value LAYER${slayer_index}_PRIORITY ]
						if {$slayer_index_PRIORITY_value == $current_layer_PRIORITY_value } {
							set_property errmsg  "The LAYER Priority must be unique."  [ipgui::get_paramspec LAYER$layer_PRIORITY	-of	$IpView ]
							return false
						}
					}
				}
				return true
			}
					
			proc validate_LAYER$layer_HORIZONTAL_START_POSITION {IpView} {
				set current_layer_HORIZONTAL_START_POSITION [get_param_value LAYER$layer_HORIZONTAL_START_POSITION ]       
				if {[get_param_value NUMBER_OF_LAYERS]	  > $layer } {        
						 if { $current_layer_HORIZONTAL_START_POSITION >= [get_param_value M_AXIS_VIDEO_WIDTH  ]  && $current_layer_HORIZONTAL_START_POSITION > 0} {
							set_property errmsg  "The LAYER Horizontal Start Position must be less than the Screen Width."  [ipgui::get_paramspec LAYER$layer_HORIZONTAL_START_POSITION	-of	$IpView ]
							return false
						}
				}						
				return true
			}
			
			proc validate_LAYER$layer_WIDTH {IpView} {
				if {[get_param_value NUMBER_OF_LAYERS]	  > $layer } {        
					 if { [get_param_value LAYER$layer_WIDTH  ] > [get_param_value M_AXIS_VIDEO_WIDTH  ] - [get_param_value LAYER$layer_HORIZONTAL_START_POSITION  ] } {
						set_property errmsg  "The LAYER Width exceeds the screen boundaries. Please adjust the Horizontal Start Position or the LAYER Width to fit the screen."  [ipgui::get_paramspec LAYER$layer_WIDTH	-of	$IpView ]						
						return false
					}
				}						
				return true
			}
			
			proc validate_LAYER$layer_GLOBAL_ALPHA_VALUE {IpView} {
				if {[get_param_value NUMBER_OF_LAYERS]	> $layer } {
					set maximum_value  [ expr round ( pow (2, [get_param_value Data_Channel_Width ])) ]				
					if { [get_param_value LAYER$layer_GLOBAL_ALPHA_VALUE  ] > $maximum_value } {					 
						set_property errmsg  "The Global Alpha Value must be less than 2**(Data Channel Width)."  [ipgui::get_paramspec LAYER$layer_GLOBAL_ALPHA_VALUE	-of	$IpView ]						
						return false
					}
				}						
				return true
			}
			
		
			proc updateOfLAYER$layer_GLOBAL_ALPHA_VALUE {IpView} {
				set Data_Channel_Width [get_param_value Data_Channel_Width]
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set LAYER_GLOBAL_ALPHA_VALUE [ipgui::get_paramspec -name LAYER$layer_GLOBAL_ALPHA_VALUE -of $IpView]
				set min [lindex [split [get_property range $LAYER_GLOBAL_ALPHA_VALUE] ,] 0]
				set max [ expr round ( pow (2, $Data_Channel_Width )) ]
				set_property range_value $max,$min,$max $LAYER_GLOBAL_ALPHA_VALUE

				if {$NUMBER_OF_LAYERS  > $layer } {
					set_property visible true $LAYER_GLOBAL_ALPHA_VALUE
			    set_property tooltip  "Sets the layer global alpha value for layer $layer. Valid when the Global Alpha Enable is set. Valid range is ([get_property range $LAYER_GLOBAL_ALPHA_VALUE])." $LAYER_GLOBAL_ALPHA_VALUE
				} else {
					set_property visible false $LAYER_GLOBAL_ALPHA_VALUE
				}

				if {   [get_param_value LAYER$layer_GLOBAL_ALPHA_ENABLE ] == "true" } {
					set_property enabled true $LAYER_GLOBAL_ALPHA_VALUE
				} else {
					set_property enabled false $LAYER_GLOBAL_ALPHA_VALUE
				}
			}
			
			proc LAYER$layer_TYPE_updated {IpView} {
				set pg_num [expr 2*$layer+3]
				variable Page$pg_num
				set LAYER_GLOBAL_ALPHA_ENABLE [ipgui::get_paramspec -name LAYER$layer_GLOBAL_ALPHA_ENABLE -of $IpView]
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set slayer_TYPE [get_param_value LAYER$layer_TYPE ]

				if {   $NUMBER_OF_LAYERS    > $layer
					  && [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller" } {
					set_property visible true [set Page$pg_num]	
				} else {
					set_property visible false [set Page$pg_num]	
					
				}
				
				updateOfLAYER_GLOBAL_ALPHA_ENABLE $IpView
				updateOfLAYER$layer_BOX_INSTRUCTION_ENABLE $IpView
				updateOfLAYER$layer_LINE_INSTRUCTION_ENABLE $IpView
				update_LAYER$layer_TEXT_INSTRUCTION_ENABLE $IpView
				update_LAYER$layer_FONT_NUMBER_OF_CHARACTERS $IpView
				updateOfLAYER$layer_COLOR_TABLE_SIZE $IpView
				updateOfLAYER$layer_COLOR_TABLE_MEMORY_TYPE $IpView
				update_LAYER$layer_FONT_CHARACTER_WIDTH  $IpView
				update_LAYER$layer_FONT_CHARACTER_HEIGHT  $IpView
				update_LAYER$layer_FONT_BITS_PER_PIXEL  $IpView
				update_LAYER$layer_FONT_ASCII_OFFSET  $IpView
				update_LAYER$layer_TEXT_NUMBER_OF_STRINGS  $IpView
				update_LAYER$layer_TEXT_MAX_STRING_LENGTH  $IpView
				updateOfLayer$layer_Instruction_Memory_Size $IpView
			}
			
			proc LAYER$layer_GLOBAL_ALPHA_ENABLE_updated {IpView} {
				updateOfLAYER$layer_GLOBAL_ALPHA_VALUE $IpView
			}
			
			proc updateOfLAYER$layer_BOX_INSTRUCTION_ENABLE {IpView} {
				set LAYER_BOX_INSTRUCTION_ENABLE [ipgui::get_paramspec -name LAYER$layer_BOX_INSTRUCTION_ENABLE -of $IpView]
				if {   [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
              && [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_BOX_INSTRUCTION_ENABLE	
				} else {
					set_property enabled false $LAYER_BOX_INSTRUCTION_ENABLE	
				}
			}
			
			proc updateOfLAYER$layer_LINE_INSTRUCTION_ENABLE {IpView} {
				set LAYER_LINE_INSTRUCTION_ENABLE [ipgui::get_paramspec -name LAYER$layer_LINE_INSTRUCTION_ENABLE -of $IpView]
				if { [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_LINE_INSTRUCTION_ENABLE	           
				} else {
					set_property enabled false $LAYER_LINE_INSTRUCTION_ENABLE	
				}
			}
			
			proc update_LAYER$layer_TEXT_INSTRUCTION_ENABLE {IpView} {
				set LAYER_TEXT_INSTRUCTION_ENABLE [ipgui::get_paramspec -name LAYER$layer_TEXT_INSTRUCTION_ENABLE -of $IpView]
				if {   [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_TEXT_INSTRUCTION_ENABLE	           
				} else {
					set_property enabled false $LAYER_TEXT_INSTRUCTION_ENABLE	
				}
			}
			
			proc updateOfLayer$layer_Instruction_Memory_Size {IpView} {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set Layer_Instruction_Memory_Size [ipgui::get_paramspec -name LAYER$layer_INSTRUCTION_MEMORY_SIZE -of $IpView]
				if {   [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller" 
				&& $NUMBER_OF_LAYERS    > $layer } {
				set_property enabled true $Layer_Instruction_Memory_Size
				} else {
				set_property enabled false $Layer_Instruction_Memory_Size
				}
			}
			
			proc update_LAYER$layer_FONT_NUMBER_OF_CHARACTERS {IpView} {
				set LAYER_FONT_NUMBER_OF_CHARACTERS [ipgui::get_paramspec -name LAYER$layer_FONT_NUMBER_OF_CHARACTERS -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_FONT_NUMBER_OF_CHARACTERS
				} else {
					set_property enabled false $LAYER_FONT_NUMBER_OF_CHARACTERS
				}
			}
			
			proc LAYER$layer_TEXT_INSTRUCTION_ENABLE_updated {IpView} {
				update_LAYER$layer_FONT_NUMBER_OF_CHARACTERS $IpView
				update_LAYER$layer_FONT_CHARACTER_WIDTH  $IpView
				update_LAYER$layer_FONT_CHARACTER_HEIGHT  $IpView
				update_LAYER$layer_FONT_ASCII_OFFSET  $IpView
				update_LAYER$layer_FONT_BITS_PER_PIXEL $IpView
				update_LAYER$layer_TEXT_NUMBER_OF_STRINGS $IpView
				update_LAYER$layer_TEXT_MAX_STRING_LENGTH $IpView
			}
			
			proc updateOfLAYER$layer_COLOR_TABLE_SIZE {IpView} {
				set LAYER_COLOR_TABLE_SIZE [ipgui::get_paramspec -name LAYER$layer_COLOR_TABLE_SIZE -of $IpView]		 
				if {   [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_COLOR_TABLE_SIZE	           
				} else {
					set_property enabled false $LAYER_COLOR_TABLE_SIZE	
				}
			}
			
			proc updateOfLAYER$layer_COLOR_TABLE_MEMORY_TYPE {IpView} {
				set LAYER_COLOR_TABLE_MEMORY_TYPE [ipgui::get_paramspec -name LAYER$layer_COLOR_TABLE_MEMORY_TYPE -of $IpView]		 
				if {   [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_COLOR_TABLE_MEMORY_TYPE	           
				} else {
					set_property enabled false $LAYER_COLOR_TABLE_MEMORY_TYPE	
				}
			}
			
			 
			proc update_LAYER$layer_FONT_CHARACTER_WIDTH  {IpView} {
				set LAYER_FONT_CHARACTER_WIDTH  [ipgui::get_paramspec -name LAYER$layer_FONT_CHARACTER_WIDTH  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_FONT_CHARACTER_WIDTH
				} else {
					set_property enabled false $LAYER_FONT_CHARACTER_WIDTH
				}
			}
			
			proc update_LAYER$layer_FONT_CHARACTER_HEIGHT  {IpView} {
				set LAYER_FONT_CHARACTER_HEIGHT  [ipgui::get_paramspec -name LAYER$layer_FONT_CHARACTER_HEIGHT  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_FONT_CHARACTER_HEIGHT
				} else {
					set_property enabled false $LAYER_FONT_CHARACTER_HEIGHT
				}
			}
			
			proc update_LAYER$layer_FONT_ASCII_OFFSET  {IpView} {
				set LAYER_FONT_ASCII_OFFSET  [ipgui::get_paramspec -name LAYER$layer_FONT_ASCII_OFFSET  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_FONT_ASCII_OFFSET
				} else {
					set_property enabled false $LAYER_FONT_ASCII_OFFSET
				}
			}
			
			proc update_LAYER$layer_FONT_BITS_PER_PIXEL  {IpView} {
				set LAYER_FONT_BITS_PER_PIXEL  [ipgui::get_paramspec -name LAYER$layer_FONT_BITS_PER_PIXEL  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_FONT_BITS_PER_PIXEL
				} else {
					set_property enabled false $LAYER_FONT_BITS_PER_PIXEL
				}
			}
			
			proc update_LAYER$layer_TEXT_NUMBER_OF_STRINGS  {IpView} {
				set LAYER_TEXT_NUMBER_OF_STRINGS  [ipgui::get_paramspec -name LAYER$layer_TEXT_NUMBER_OF_STRINGS  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_TEXT_NUMBER_OF_STRINGS
				} else {
					set_property enabled false $LAYER_TEXT_NUMBER_OF_STRINGS
				}
			}
			
			proc update_LAYER$layer_TEXT_MAX_STRING_LENGTH  {IpView} {
				set LAYER_TEXT_MAX_STRING_LENGTH  [ipgui::get_paramspec -name LAYER$layer_TEXT_MAX_STRING_LENGTH  -of $IpView]
				if {[get_param_value LAYER$layer_TEXT_INSTRUCTION_ENABLE ] == "true"
				&& [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"
				&& [get_param_value NUMBER_OF_LAYERS]  > $layer } {
					set_property enabled true $LAYER_TEXT_MAX_STRING_LENGTH
				} else {
					set_property enabled false $LAYER_TEXT_MAX_STRING_LENGTH
				}
			}
			
			proc updateOfLAYER$layer_PRIORITY {IpView} {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set LAYER_PRIORITY  [ipgui::get_paramspec -name LAYER$layer_PRIORITY  -of $IpView]
				set my_string {}
				set min 0
				for {set lay 0} {$lay < $NUMBER_OF_LAYERS } {set lay [expr $lay+1]} {
					lappend my_string $lay
				}
				set my_string [join $my_string ,]
				set max_prio [expr $NUMBER_OF_LAYERS  - 1]  
			
				set_property range_value $layer,$min,$max_prio $LAYER_PRIORITY
				if { $NUMBER_OF_LAYERS   > $layer } {
					set_property enabled true $LAYER_PRIORITY
					set_property visible true $LAYER_PRIORITY
			    set_property tooltip  "Set the priority of layer $layer. Higher priority layers will appear on top of lower priority layers. Valid range is ([get_property range $LAYER_PRIORITY])." $LAYER_PRIORITY
				} else {
					set_property enabled false $LAYER_PRIORITY
					set_property visible false $LAYER_PRIORITY
				}        
			}
			
			proc updateOfLAYER$layer_WIDTH {IpView} {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set M_AXIS_VIDEO_WIDTH [get_param_value M_AXIS_VIDEO_WIDTH]
				set LAYER_WIDTH [ipgui::get_paramspec -name LAYER$layer_WIDTH -of $IpView]
				set max [ expr $M_AXIS_VIDEO_WIDTH  - [get_param_value LAYER$layer_HORIZONTAL_START_POSITION ] ]
				set min [lindex [split [get_property range $LAYER_WIDTH] ,] 0]
				set_property range $min,$max $LAYER_WIDTH	
				if { $NUMBER_OF_LAYERS   > $layer } {
					set_property enabled true $LAYER_WIDTH	
					set_property visible true $LAYER_WIDTH	
			    set_property tooltip  "Set the width of layer $layer. Valid range is ([get_property range $LAYER_WIDTH])." $LAYER_WIDTH
				} else {
					set_property enabled false $LAYER_WIDTH	
					set_property visible false $LAYER_WIDTH	
				}
			}
			
			proc updateOfLAYER$layer_HEIGHT {IpView} {
				set NUMBER_OF_LAYERS [get_param_value NUMBER_OF_LAYERS]
				set M_AXIS_VIDEO_HEIGHT [get_param_value M_AXIS_VIDEO_HEIGHT]
				set LAYER_HEIGHT [ipgui::get_paramspec -name LAYER$layer_HEIGHT -of $IpView]
				set max [ expr $M_AXIS_VIDEO_HEIGHT  - [get_param_value LAYER$layer_VERTICAL_START_POSITION ] ]
				set min [lindex [split [get_property range $LAYER_HEIGHT] ,] 0]
				set_property range $min,$max $LAYER_HEIGHT	
				if { $NUMBER_OF_LAYERS   > $layer } {
					set_property enabled true $LAYER_HEIGHT	
					set_property visible true $LAYER_HEIGHT	
			    set_property tooltip  "Set the height of layer $layer. Valid range is ([get_property range $LAYER_HEIGHT])." $LAYER_HEIGHT
				} else {
					set_property enabled false $LAYER_HEIGHT	
					set_property visible false $LAYER_HEIGHT	
				}
			}
			
			proc LAYER$layer_HORIZONTAL_START_POSITION_updated {IpView} {
				updateOfLAYER$layer_WIDTH $IpView
			}

			proc LAYER$layer_VERTICAL_START_POSITION_updated {IpView} {
				updateOfLAYER$layer_HEIGHT $IpView
			}
		} 0
	}
		
	proc M_AXIS_VIDEO_HEIGHT_updated {IpView} {
		foreach layer {0 1 2 3 4 5 6 7} {
			updateOfLAYER${layer}_HEIGHT $IpView
		}
	}
  
	proc NUMBER_OF_LAYERS_updated {IpView} {
		updateOf_LAYER_TYPE $IpView
		updateOfLAYER_HORIZONTAL_START_POSITION $IpView
		updateOfLAYER_VERTICAL_START_POSITION $IpView
		updateOfLAYER_ENABLE $IpView
		updateOfLAYER_GLOBAL_ALPHA_ENABLE $IpView

		foreach layer {0 1 2 3 4 5 6 7} {
			updateOfLAYER${layer}_GLOBAL_ALPHA_VALUE $IpView
	
			updateOfLAYER${layer}_BOX_INSTRUCTION_ENABLE $IpView
			updateOfLAYER${layer}_LINE_INSTRUCTION_ENABLE $IpView
			update_LAYER${layer}_TEXT_INSTRUCTION_ENABLE $IpView
		
			update_LAYER${layer}_FONT_NUMBER_OF_CHARACTERS $IpView
			updateOfLAYER${layer}_COLOR_TABLE_SIZE $IpView
			updateOfLAYER${layer}_COLOR_TABLE_MEMORY_TYPE $IpView
			update_LAYER${layer}_FONT_CHARACTER_WIDTH  $IpView
			updateOfLayer${layer}_Instruction_Memory_Size $IpView
			update_LAYER${layer}_FONT_CHARACTER_HEIGHT  $IpView
			update_LAYER${layer}_FONT_BITS_PER_PIXEL  $IpView
			update_LAYER${layer}_FONT_ASCII_OFFSET  $IpView
			update_LAYER${layer}_TEXT_NUMBER_OF_STRINGS  $IpView
			update_LAYER${layer}_TEXT_MAX_STRING_LENGTH  $IpView
			updateOfLAYER${layer}_PRIORITY  $IpView
			updateOfLAYER${layer}_WIDTH  $IpView
			updateOfLAYER${layer}_HEIGHT  $IpView
			set layerOptionPage [expr 2 * $layer + 2]
			set layerControllerPage [expr 2 * $layer + 3]
			variable Page$layerOptionPage
			variable Page$layerControllerPage
			if {[get_param_value NUMBER_OF_LAYERS ] <= $layer} {
				set_property visible false [set Page$layerOptionPage]
				set_property visible false [set Page$layerControllerPage]
			} else {
				if {[get_param_value LAYER${layer}_TYPE] == "Internal_Graphics_Controller"} {
					set_property visible true [set Page$layerControllerPage]
				} else {
					set_property visible false [set Page$layerControllerPage]
				}
			}
	
		}
		
		# variable Page2
		# set_property visible true [set Page2]
	}
	
	proc updateOfBGcolors {IpView} {
		set max [ expr round (pow (2, [get_param_value Data_Channel_Width ])) - 1 ]
	    set val [ expr round (pow (2, [get_param_value Data_Channel_Width ] - 1)) ]
		set_property range_value $val,0,$max  [ipgui::get_paramspec -name BG_COLOR0 -of $IpView]
		set_property range_value $val,0,$max  [ipgui::get_paramspec -name BG_COLOR1 -of $IpView]
		set_property range_value $val,0,$max  [ipgui::get_paramspec -name BG_COLOR2 -of $IpView]

    if {[get_param_value S_AXIS_VIDEO_FORMAT] eq "RGB" || [get_param_value S_AXIS_VIDEO_FORMAT] eq "RGBa"} {
  	  set_property display_name "Green (G)" [ipgui::get_paramspec -name BG_COLOR0 -of $IpView]
	    set_property display_name "Blue (B)" [ipgui::get_paramspec -name BG_COLOR1 -of $IpView]
	    set_property display_name "Red (R)" [ipgui::get_paramspec -name BG_COLOR2 -of $IpView]
    } else {
  	  set_property display_name "Luma (Y)" [ipgui::get_paramspec -name BG_COLOR0 -of $IpView]
	    set_property display_name "Cb (U)" [ipgui::get_paramspec -name BG_COLOR1 -of $IpView]
	    set_property display_name "Cr (V)" [ipgui::get_paramspec -name BG_COLOR2 -of $IpView]
    }

	}
	
	proc s_axis_tdata_width_value {} {

			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		if {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_422"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_444"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "RGB"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_420"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_422"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_444"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "RGBa"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_420"} { # YUVa_420 not currently supported
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    1
		   }
		   
   
   		set video_data_in_width  [ expr {($Alpha_Channel_Enable + $Number_of_Data_Channels) * [get_param_value Data_Channel_Width]} ]
		  set s_axis_tdata_width $video_data_in_width
		  if {$s_axis_tdata_width > 40} {
			   set s_axis_tdata_width 48
		   } elseif {$s_axis_tdata_width > 32} {
			   set s_axis_tdata_width 40
		   } elseif {$s_axis_tdata_width > 24} {
			   set s_axis_tdata_width 32
		   } elseif {$s_axis_tdata_width > 16} {
			   set s_axis_tdata_width 24
		   } elseif {$s_axis_tdata_width > 8} {
			   set s_axis_tdata_width 16
		   } else {
			   set s_axis_tdata_width 8
		   }
		  return $s_axis_tdata_width
	}
	
	
	
proc m_axis_tdata_width_value {} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		if {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_422"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_444"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "RGB"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUV_420"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    0
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_422"} {
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_444"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "RGBa"} {
			 set Number_of_Data_Channels 3
			 set Alpha_Channel_Enable    1
		   } elseif {[get_param_value S_AXIS_VIDEO_FORMAT ] eq "YUVa_420"} { # YUVa_420 not currently supported
			 set Number_of_Data_Channels 2
			 set Alpha_Channel_Enable    1
		   }
		   
		set video_data_out_width  [ expr { $Number_of_Data_Channels * [get_param_value Data_Channel_Width ]} ]
		set m_axis_tdata_width $video_data_out_width
		if {$m_axis_tdata_width > 40} {
			   set m_axis_tdata_width 48
		   } elseif {$m_axis_tdata_width > 32} {
			   set m_axis_tdata_width 40
		   } elseif {$m_axis_tdata_width > 24} {
			   set m_axis_tdata_width 32
		   } elseif {$m_axis_tdata_width > 16} {
			   set m_axis_tdata_width 24
		   } elseif {$m_axis_tdata_width > 8} {
			   set m_axis_tdata_width 16
		   } else {
			   set m_axis_tdata_width 8
		   }
	  return $m_axis_tdata_width
}
	
#################################################################
#
#   Update Model Section
#
#################################################################
 
proc updateModel_C_COMPONENT_NAME {IpView} {
  set_property modelparam_value [get_param_value Component_Name] [ipgui::get_modelparamspec C_COMPONENT_NAME -of $IpView]
}

proc updateModel_C_FAMILY {IpView} {
  set_property modelparam_value [ipgui::get_cfamily [get_project_property ARCHITECTURE] ] [ipgui::get_modelparamspec C_FAMILY -of $IpView]
}

foreach {layer} { 0 1 2 3 4 5 6 7 } {
	EvalSubstituting {layer } {
		proc updateModel_C_LAYER$layer_TYPE {IpView} {
			if { [get_param_value NUMBER_OF_LAYERS  ] <= $layer } {
				set val 0
				set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$layer_TYPE -of $IpView]
			} elseif { [get_param_value LAYER$layer_TYPE ] == "Internal_Graphics_Controller"} {
				set val 1
				set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$layer_TYPE -of $IpView]
			} elseif { [get_param_value LAYER$layer_TYPE ] == "External_AXIS" } {
				set val 2
				set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$layer_TYPE -of $IpView]
			} elseif { [get_param_value LAYER$layer_TYPE ] == "External_XSVI" } {
				set val 3
				set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$layer_TYPE -of $IpView]
			}
		}
	} 0
}

foreach {Param ModelParam} { HAS_AXI4_LITE C_HAS_AXI4_LITE  HAS_INTC_IF C_HAS_INTC_IF } {
	EvalSubstituting {Param ModelParam } {
    proc updateModel_$ModelParam {IpView} {
      set value 0
      if { [ get_param_value  $Param  ] eq true } { set value 1 }
	    set_property modelparam_value $value [ipgui::get_modelparamspec $ModelParam -of $IpView]
    }
  } 0
}

foreach {Param ModelParam} { NUMBER_OF_LAYERS C_NUM_LAYERS Data_Channel_Width  C_S_AXIS_VIDEO_DATA_WIDTH SCREEN_WIDTH C_SCREEN_WIDTH M_AXIS_VIDEO_HEIGHT C_M_AXIS_VIDEO_HEIGHT M_AXIS_VIDEO_WIDTH C_M_AXIS_VIDEO_WIDTH  BG_COLOR0 C_BGCOLOR0 BG_COLOR1 C_BGCOLOR1 BG_COLOR2 C_BGCOLOR2} {
	EvalSubstituting {Param ModelParam } {
    proc updateModel_$ModelParam {IpView} {
      set value [ get_param_value  $Param  ] 
	    set_property modelparam_value $value [ipgui::get_modelparamspec $ModelParam -of $IpView]
    }
  } 0
}
 
proc updateModel_C_S_AXIS_VIDEO_FORMAT {IpView} {
	set val 0

	if { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUV_422"} {
	  set val 0
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUV_444"} {
  	set val 1
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "RGB"} {
	  set val 2
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUV_420"} {
	  set val 3
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUVa_422"} {
	  set val 4
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUVa_444"} {
	  set val 5
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "RGBa"} {
	  set val 6
	} elseif { [get_param_value S_AXIS_VIDEO_FORMAT] == "YUVa_420"} {
	  set val 7
	}
	set_property modelparam_value $val [ipgui::get_modelparamspec C_S_AXIS_VIDEO_FORMAT -of $IpView]
}
 
proc updateModel_C_S_AXIS_VIDEO_TDATA_WIDTH {IpView} {
	set_property modelparam_value [s_axis_tdata_width_value] [ipgui::get_modelparamspec C_S_AXIS_VIDEO_TDATA_WIDTH -of $IpView]
}
 
 
proc updateModel_C_M_AXIS_VIDEO_TDATA_WIDTH {IpView} {
	set_property modelparam_value [m_axis_tdata_width_value] [ipgui::get_modelparamspec C_M_AXIS_VIDEO_TDATA_WIDTH -of $IpView]
}
	
foreach i {0 1 2 3 4 5 6 7} {
	EvalSubstituting {i} {
	
	proc updateModel_C_LAYER$i_PRIORITY {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_PRIORITY] [ipgui::get_modelparamspec C_LAYER$i_PRIORITY -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_X_POS {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_HORIZONTAL_START_POSITION] [ipgui::get_modelparamspec C_LAYER$i_X_POS -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_Y_POS {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_VERTICAL_START_POSITION] [ipgui::get_modelparamspec C_LAYER$i_Y_POS -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_X_SIZE {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_WIDTH] [ipgui::get_modelparamspec C_LAYER$i_X_SIZE -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_Y_SIZE {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_HEIGHT] [ipgui::get_modelparamspec C_LAYER$i_Y_SIZE -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_ALPHA {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_GLOBAL_ALPHA_VALUE] [ipgui::get_modelparamspec C_LAYER$i_ALPHA -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_IMEM_SIZE {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_INSTRUCTION_MEMORY_SIZE] [ipgui::get_modelparamspec C_LAYER$i_IMEM_SIZE -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_CLUT_SIZE {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_COLOR_TABLE_SIZE] [ipgui::get_modelparamspec C_LAYER$i_CLUT_SIZE -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_FONT_NUM_CHARS {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_FONT_NUMBER_OF_CHARACTERS] [ipgui::get_modelparamspec C_LAYER$i_FONT_NUM_CHARS -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_FONT_WIDTH {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_FONT_CHARACTER_WIDTH] [ipgui::get_modelparamspec C_LAYER$i_FONT_WIDTH -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_FONT_HEIGHT {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_FONT_CHARACTER_HEIGHT] [ipgui::get_modelparamspec C_LAYER$i_FONT_HEIGHT -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_FONT_BPP {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_FONT_BITS_PER_PIXEL] [ipgui::get_modelparamspec C_LAYER$i_FONT_BPP -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_FONT_ASCII_OFFSET {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_FONT_ASCII_OFFSET] [ipgui::get_modelparamspec C_LAYER$i_FONT_ASCII_OFFSET -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_TEXT_NUM_STRINGS {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_TEXT_NUMBER_OF_STRINGS] [ipgui::get_modelparamspec C_LAYER$i_TEXT_NUM_STRINGS -of $IpView]
	}

	proc updateModel_C_LAYER$i_TEXT_MAX_STRING_LENGTH {IpView} {
		set_property modelparam_value [get_param_value LAYER$i_TEXT_MAX_STRING_LENGTH] [ipgui::get_modelparamspec C_LAYER$i_TEXT_MAX_STRING_LENGTH -of $IpView]
	}
	
	proc updateModel_C_LAYER$i_GALPHA_EN {IpView} {
	
		set val 0
		if {[get_param_value LAYER$i_GLOBAL_ALPHA_ENABLE] == false } {
		set val 0
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_GALPHA_EN -of $IpView]
		} else {
		set val 1
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_GALPHA_EN -of $IpView]
		}
	}
	
	proc updateModel_C_LAYER$i_ENABLE {IpView} {
	
		set val 0
		if {[get_param_value LAYER$i_ENABLE] == false } {
		set val 0
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_ENABLE -of $IpView]
		} else {
		set val 1
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_ENABLE -of $IpView]
		}
	}
		
	proc updateModel_C_LAYER$i_INS_BOX_EN {IpView} {
	
		set val 0
		if {[get_param_value LAYER$i_BOX_INSTRUCTION_ENABLE] == false } {
		set val 0
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_BOX_EN -of $IpView]
		} else {
		set val 1
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_BOX_EN -of $IpView]
		}
	}
	
	proc updateModel_C_LAYER$i_INS_LINE_EN {IpView} {
	
		set val 0
		if {[get_param_value LAYER$i_LINE_INSTRUCTION_ENABLE] == false } {
		set val 0
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_LINE_EN -of $IpView]
		} else {
		set val 1
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_LINE_EN -of $IpView]
		}
	}
	
	proc updateModel_C_LAYER$i_INS_TEXT_EN {IpView} {
	
		set val 0
		if {[get_param_value LAYER$i_TEXT_INSTRUCTION_ENABLE] == false } {
		set val 0
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_TEXT_EN -of $IpView]
		} else {
		set val 1
		set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_INS_TEXT_EN -of $IpView]
		}
	}
	
	proc updateModel_C_LAYER$i_CLUT_MEMTYPE {IpView} {
	
		if {[get_param_value LAYER$i_COLOR_TABLE_MEMORY_TYPE] == "Distributed Memory" } {
			set val 0
			set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_CLUT_MEMTYPE -of $IpView]
			} elseif { [get_param_value LAYER$i_COLOR_TABLE_MEMORY_TYPE] == "Block Memory" } {
			set val 1
			set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_CLUT_MEMTYPE -of $IpView]
			} elseif { [get_param_value LAYER$i_COLOR_TABLE_MEMORY_TYPE] == "Auto-Configure" } {
			set val 2
			set_property modelparam_value $val [ipgui::get_modelparamspec C_LAYER$i_CLUT_MEMTYPE -of $IpView]
			}
		}
	} 0
 }
