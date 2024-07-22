# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ASK_SAMPLE_OFF" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ASK_SAMPLE_ON" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PER_SCLK" -parent ${Page_0}


}

proc update_PARAM_VALUE.ASK_SAMPLE_OFF { PARAM_VALUE.ASK_SAMPLE_OFF } {
	# Procedure called to update ASK_SAMPLE_OFF when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASK_SAMPLE_OFF { PARAM_VALUE.ASK_SAMPLE_OFF } {
	# Procedure called to validate ASK_SAMPLE_OFF
	return true
}

proc update_PARAM_VALUE.ASK_SAMPLE_ON { PARAM_VALUE.ASK_SAMPLE_ON } {
	# Procedure called to update ASK_SAMPLE_ON when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASK_SAMPLE_ON { PARAM_VALUE.ASK_SAMPLE_ON } {
	# Procedure called to validate ASK_SAMPLE_ON
	return true
}

proc update_PARAM_VALUE.PER_SCLK { PARAM_VALUE.PER_SCLK } {
	# Procedure called to update PER_SCLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PER_SCLK { PARAM_VALUE.PER_SCLK } {
	# Procedure called to validate PER_SCLK
	return true
}

proc update_PARAM_VALUE.SEND_CLK { PARAM_VALUE.SEND_CLK } {
	# Procedure called to update SEND_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEND_CLK { PARAM_VALUE.SEND_CLK } {
	# Procedure called to validate SEND_CLK
	return true
}


proc update_MODELPARAM_VALUE.ASK_SAMPLE_OFF { MODELPARAM_VALUE.ASK_SAMPLE_OFF PARAM_VALUE.ASK_SAMPLE_OFF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASK_SAMPLE_OFF}] ${MODELPARAM_VALUE.ASK_SAMPLE_OFF}
}

proc update_MODELPARAM_VALUE.ASK_SAMPLE_ON { MODELPARAM_VALUE.ASK_SAMPLE_ON PARAM_VALUE.ASK_SAMPLE_ON } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASK_SAMPLE_ON}] ${MODELPARAM_VALUE.ASK_SAMPLE_ON}
}

proc update_MODELPARAM_VALUE.PER_SCLK { MODELPARAM_VALUE.PER_SCLK PARAM_VALUE.PER_SCLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PER_SCLK}] ${MODELPARAM_VALUE.PER_SCLK}
}

proc update_MODELPARAM_VALUE.SEND_CLK { MODELPARAM_VALUE.SEND_CLK PARAM_VALUE.SEND_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEND_CLK}] ${MODELPARAM_VALUE.SEND_CLK}
}

