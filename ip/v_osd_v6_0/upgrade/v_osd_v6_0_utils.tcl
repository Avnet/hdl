namespace eval v_osd_v6_0_utils {

  proc upgrade_parameters_from_before_v6_0 {parameterArray} {

    upvar $parameterArray valueArray
    
    #  Version 5.01.a and earlier gave the Master Axis video width/height parameters the name M_AXIS_VIDEO_WIDTH/HEIGHT
    # but the IDs S_AXIS_VIDEO_WIDTH/HEIGHT.
    # Version 6.0 corrects this reversal, and makes the ID tag consistent with the name tag; this means that any use of
    # the old ID S_AXIS_VIDEO_WIDTH/HEIGHT should be replaced with the new ID M_AXIS_VIDEO_WIDTH/HEIGHT.

    if { [isParameter S_AXIS_VIDEO_WIDTH  valueArray] } {
      renameParameter S_AXIS_VIDEO_WIDTH  M_AXIS_VIDEO_WIDTH  valueArray
    }
    if { [isParameter S_AXIS_VIDEO_HEIGHT valueArray] } {
      renameParameter S_AXIS_VIDEO_HEIGHT M_AXIS_VIDEO_HEIGHT valueArray
    }

    #  Version 5.01.a and earlier gave the Master Axis video width a default value of 0.
    # Version 6.0 changes this default to the screen width (defaults to 1280).
    if { [getParameter M_AXIS_VIDEO_WIDTH valueArray] == 0 } {
      setParameter M_AXIS_VIDEO_WIDTH [getParameter SCREEN_WIDTH valueArray] valueArray
    }

    #  Remove the disabled layer parameters, to prevent any changes to their default
    # values from triggering customization warnings.
    set layerCount [getParameter NUMBER_OF_LAYERS valueArray]

    if { [expr ${layerCount} < 2] } {
      removeParameter LAYER1_ENABLE                    valueArray
      removeParameter LAYER1_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER1_PRIORITY                  valueArray
      removeParameter LAYER1_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER1_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER1_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER1_WIDTH                     valueArray
      removeParameter LAYER1_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 3] } {
      removeParameter LAYER2_ENABLE                    valueArray
      removeParameter LAYER2_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER2_PRIORITY                  valueArray
      removeParameter LAYER2_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER2_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER2_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER2_WIDTH                     valueArray
      removeParameter LAYER2_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 4] } {
      removeParameter LAYER3_ENABLE                    valueArray
      removeParameter LAYER3_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER3_PRIORITY                  valueArray
      removeParameter LAYER3_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER3_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER3_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER3_WIDTH                     valueArray
      removeParameter LAYER3_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 5] } {
      removeParameter LAYER4_ENABLE                    valueArray
      removeParameter LAYER4_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER4_PRIORITY                  valueArray
      removeParameter LAYER4_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER4_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER4_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER4_WIDTH                     valueArray
      removeParameter LAYER4_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 6] } {
      removeParameter LAYER5_ENABLE                    valueArray
      removeParameter LAYER5_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER5_PRIORITY                  valueArray
      removeParameter LAYER5_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER5_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER5_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER5_WIDTH                     valueArray
      removeParameter LAYER5_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 7] } {
      removeParameter LAYER6_ENABLE                    valueArray
      removeParameter LAYER6_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER6_PRIORITY                  valueArray
      removeParameter LAYER6_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER6_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER6_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER6_WIDTH                     valueArray
      removeParameter LAYER6_HEIGHT                    valueArray
    }
    if { [expr ${layerCount} < 8] } {
      removeParameter LAYER7_ENABLE                    valueArray
      removeParameter LAYER7_GLOBAL_ALPHA_ENABLE       valueArray
      removeParameter LAYER7_PRIORITY                  valueArray
      removeParameter LAYER7_GLOBAL_ALPHA_VALUE        valueArray
      removeParameter LAYER7_HORIZONTAL_START_POSITION valueArray
      removeParameter LAYER7_VERTICAL_START_POSITION   valueArray
      removeParameter LAYER7_WIDTH                     valueArray
      removeParameter LAYER7_HEIGHT                    valueArray
    }
  }

  proc upgrade_from_v_osd_v4_00_a {xciValues} {
    namespace import ::xcoUpgradeLib::*
    upvar $xciValues valueArray
 
    upgrade_parameters_from_before_v6_0 valueArray

    namespace forget ::xcoUpgradeLib::*
  }

  proc upgrade_from_v_osd_v5_00_a {xciValues} {
    namespace import ::xcoUpgradeLib::*
    upvar $xciValues valueArray
 
    upgrade_parameters_from_before_v6_0 valueArray

    namespace forget ::xcoUpgradeLib::*
  }

  proc upgrade_from_v_osd_v5_01_a {xciValues} {
    namespace import ::xcoUpgradeLib::*
    upvar $xciValues valueArray
 
    upgrade_parameters_from_before_v6_0 valueArray

    namespace forget ::xcoUpgradeLib::*
  }

} ;# end namespace

