# Note: This file is produced automatically, and will be overwritten the next
# time you press "Generate" in System Generator. 
#


namespace eval ::xilinx::dsp::planaheaddriver {
	set Compilation {IP Catalog}
	set CompilationFlow {IP}
	set CreateInterfaceDocument {off}
	set DSPDevice {xc7z007s}
	set DSPFamily {zynq}
	set DSPPackage {clg225}
	set DSPSpeed {-1}
	set FPGAClockPeriod 6.25
	set GenerateTestBench 0
	set HDLLanguage {vhdl}
	set IPOOCCacheRootPath {C:/Users/Luc/AppData/Local/Xilinx/Sysgen/SysgenVivado/win64.o/ip}
	set IP_Auto_Infer {1}
	set IP_Categories_Text {System Generator for DSP}
	set IP_Common_Repos {0}
	set IP_Description {}
	set IP_Dir {}
	set IP_Library_Text {SysGen}
	set IP_LifeCycle_Menu {1}
	set IP_Logo {sysgen_icon_100.png}
	set IP_Name {dspsdadc_sg}
	set IP_Revision {128084736}
	set IP_Socket_IP {0}
	set IP_Socket_IP_Proj_Path {}
	set IP_Vendor_Text {Avnet Inc}
	set IP_Version_Text {1.0}
	set ImplStrategyName {Vivado Implementation Defaults}
	set PostProjectCreationProc {dsp_package_for_vivado_ip_integrator}
	set Project {pdm_filter_sysgen}
	set ProjectFiles {
		{{conv_pkg.vhd} -lib {xil_defaultlib}}
		{{synth_reg.vhd} -lib {xil_defaultlib}}
		{{synth_reg_w_init.vhd} -lib {xil_defaultlib}}
		{{srl17e.vhd} -lib {xil_defaultlib}}
		{{srl33e.vhd} -lib {xil_defaultlib}}
		{{synth_reg_reg.vhd} -lib {xil_defaultlib}}
		{{single_reg_w_init.vhd} -lib {xil_defaultlib}}
		{{xlclockdriver_rd.vhd} -lib {xil_defaultlib}}
		{{vivado_ip.tcl}}
		{{pdm_filter_sysgen_entity_declarations.vhd} -lib {xil_defaultlib}}
		{{pdm_filter_sysgen.vhd} -lib {xil_defaultlib}}
		{{pdm_filter_sysgen_clock.xdc}}
		{{pdm_filter_sysgen.xdc}}
	}
	set SimPeriod 6.25e-09
	set SimTime 0.523599
	set SimulationTime {523598981.84829885 ns}
	set SynthStrategyName {Vivado Synthesis Defaults}
	set SynthesisTool {Vivado}
	set TargetDir {C:/Avnet/hdl/IP/microphone_PDM/products}
	set TopLevelModule {pdm_filter_sysgen}
	set TopLevelSimulinkHandle 45.0004
	set VHDLLib {xil_defaultlib}
	set TopLevelPortInterface {}
	dict set TopLevelPortInterface pdm_in Name {pdm_in}
	dict set TopLevelPortInterface pdm_in Type Bool
	dict set TopLevelPortInterface pdm_in ArithmeticType xlUnsigned
	dict set TopLevelPortInterface pdm_in BinaryPoint 0
	dict set TopLevelPortInterface pdm_in Width 1
	dict set TopLevelPortInterface pdm_in DatFile {microphone_pdm_pdm_filter_sysgen_pdm_in.dat}
	dict set TopLevelPortInterface pdm_in IconText {PDM_in}
	dict set TopLevelPortInterface pdm_in Direction in
	dict set TopLevelPortInterface pdm_in Period 64
	dict set TopLevelPortInterface pdm_in Interface 0
	dict set TopLevelPortInterface pdm_in InterfaceName {}
	dict set TopLevelPortInterface pdm_in InterfaceString {DATA}
	dict set TopLevelPortInterface pdm_in ClockDomain {pdm_filter_sysgen}
	dict set TopLevelPortInterface pdm_in Locs {}
	dict set TopLevelPortInterface pdm_in IOStandard {}
	dict set TopLevelPortInterface audio_ce Name {audio_ce}
	dict set TopLevelPortInterface audio_ce Type Bool
	dict set TopLevelPortInterface audio_ce ArithmeticType xlUnsigned
	dict set TopLevelPortInterface audio_ce BinaryPoint 0
	dict set TopLevelPortInterface audio_ce Width 1
	dict set TopLevelPortInterface audio_ce DatFile {microphone_pdm_pdm_filter_sysgen_audio_ce.dat}
	dict set TopLevelPortInterface audio_ce IconText {Audio_CE}
	dict set TopLevelPortInterface audio_ce Direction out
	dict set TopLevelPortInterface audio_ce Period 1
	dict set TopLevelPortInterface audio_ce Interface 0
	dict set TopLevelPortInterface audio_ce InterfaceName {}
	dict set TopLevelPortInterface audio_ce InterfaceString {DATA}
	dict set TopLevelPortInterface audio_ce ClockDomain {pdm_filter_sysgen}
	dict set TopLevelPortInterface audio_ce Locs {}
	dict set TopLevelPortInterface audio_ce IOStandard {}
	dict set TopLevelPortInterface audio_out Name {audio_out}
	dict set TopLevelPortInterface audio_out Type Fix_16_13
	dict set TopLevelPortInterface audio_out ArithmeticType xlSigned
	dict set TopLevelPortInterface audio_out BinaryPoint 13
	dict set TopLevelPortInterface audio_out Width 16
	dict set TopLevelPortInterface audio_out DatFile {microphone_pdm_pdm_filter_sysgen_audio_out.dat}
	dict set TopLevelPortInterface audio_out IconText {Audio_out}
	dict set TopLevelPortInterface audio_out Direction out
	dict set TopLevelPortInterface audio_out Period 4096
	dict set TopLevelPortInterface audio_out Interface 0
	dict set TopLevelPortInterface audio_out InterfaceName {}
	dict set TopLevelPortInterface audio_out InterfaceString {DATA}
	dict set TopLevelPortInterface audio_out ClockDomain {pdm_filter_sysgen}
	dict set TopLevelPortInterface audio_out Locs {}
	dict set TopLevelPortInterface audio_out IOStandard {}
	dict set TopLevelPortInterface clk Name {clk}
	dict set TopLevelPortInterface clk Type -
	dict set TopLevelPortInterface clk ArithmeticType xlUnsigned
	dict set TopLevelPortInterface clk BinaryPoint 0
	dict set TopLevelPortInterface clk Width 1
	dict set TopLevelPortInterface clk DatFile {}
	dict set TopLevelPortInterface clk Direction in
	dict set TopLevelPortInterface clk Period 1
	dict set TopLevelPortInterface clk Interface 6
	dict set TopLevelPortInterface clk InterfaceName {}
	dict set TopLevelPortInterface clk InterfaceString {CLOCK}
	dict set TopLevelPortInterface clk ClockDomain {pdm_filter_sysgen}
	dict set TopLevelPortInterface clk Locs {}
	dict set TopLevelPortInterface clk IOStandard {}
	dict set TopLevelPortInterface clk AssociatedInterfaces {}
	dict set TopLevelPortInterface clk AssociatedResets {}
	set MemoryMappedPort {}
}

source SgPaProject.tcl
::xilinx::dsp::planaheadworker::dsp_create_project