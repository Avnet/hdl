**************************************************************************************************************************
Readme File for SPI Master Customer Pack

Created: 11/1/00  ALS
Revised: 12/11/02 JRH
Revised: 06/20/14 DWR - Modified for use in X-Fest Demo
                      - Some files removed, some reworked

**************************************************************************************************************************
**************************************************************************************************************************
DISCLAIMER
**************************************************************************************************************************
THIS DESIGN IS PROVIDED TO YOU "AS IS". XILINX MAKES AND YOU RECEIVE NO WARRANTIES OR 
CONDITIONS, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, AND XILINX SPECIFICALLY DISCLAIMS ANY 
IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR 
PURPOSE. This design has not been verified on hardware (as opposed to simulations), 
and it should be used only as an example design, not as a fully functional core. 
XILINX does not warrant the performance, functionality, or operation of 
this Design will meet your requirements, or that the operation of the Design 
will be uninterrupted or error free, or that defects in the Design will be corrected. 
Furthermore, XILINX does not warrant or make any representations regarding use or 
the results of the use of the Design in terms of correctness, accuracy, reliability or otherwise. 

THIRD PARTIES INCLUDING MOTOROLA MAY HAVE PATENTS ON THE SERIAL PERIPHERAL INTERFACE ("SPI") 
BUS.  BY PROVIDING THIS HDL CODE AS ONE POSSIBLE IMPLEMENTATION OF THIS STANDARD, XILINX IS 
MAKING NO REPRESENTATION THAT THE PROVIDED IMPLEMENTATION OF THE SPI BUS IS FREE FROM ANY 
CLAIMS OF INFRINGEMENT BY ANY THIRD PARTY.  XILINX EXPRESSLY DISCLAIMS ANY WARRANTY OR 
CONDITIONS, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, AND XILINX SPECIFICALLY DISCLAIMS ANY 
IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR 
PURPOSE. THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTY OR 
REPRESENTATION THAT THE IMPLEMENTATION IS FREE FROM CLAIMS OF ANY THIRD PARTY.  
FURTHERMORE, XILINX IS PROVIDING THIS REFERENCE DESIGNS "AS IS" AS A COURTESY TO YOU.

**************************************************************************************************************************
File Contents
**************************************************************************************************************************
This zip file contains the following folders:

	\work			-- XST and ModelSim compiled VHDL files

	-- VHDL Source Files:
					spi_master.vhd 		- top level structural VHDL file
					uc_interface.vhd	- 8051 interface
					spi_interface.vhd	- structural VHDL file
					sck_logic.vhd		- generates SCK
					spi_control_sm.vhd	- state machine controlling the SPI interface
					spi_xmit_shift_reg.vhd 	- SPI transmit shift register
					spi_rcv_shift_reg.vhd	- SPI receive shift register
					upcnt4.vhd		- 4-bit up counter
					upcnt5.vhd		- 5-bit up counter
					spi_master_timesim.vhd	- post fit timing model
					
	-- VHDL Testbench Files:	spi_master_tb.vhd	- testbench for the SPI Master which emulates
									8051 bus cycles and a simple SPI slave
	-- ModelSim DO files:	
					func_sim.do		- functional simulation script file
					wave_color.do		- configures wave window for functional simulation
					post_sim.do		- post-route simulation script file 
					wave_post_color.do	- configures wave window for post-route simulation

	-- Xilinx Project Navigator Files
					spi_master.npl		- SPI design file
					spi_master.cxt		- XPower design input file
					spi_master.jed		- Programming file for XC2C256-5-VQ100
					spi_master.rpt		- Device utilization report file

	-- Other Files
					readme.txt		- This file
					readme.doc		- The contents of this file formatted for Microsoft Word
**************************************************************************************************************************
Design Notes
**************************************************************************************************************************
The CoolRunner-II SPI Master design was designed from Section 8 Synchronous Serial Peripheral Interface of the 
specification for the MC68HC11 uC. Complete documentation for the design can be found in XAPP386 available for 
download from the Xilinx website.

All of the register addresses are defined as constants in the VHDL source files and can be easily customized for customer 
use. The BASE address is defined as a generic and can also be easily changed and customized for customer use. 
This design is targeted to the XC2C256 CoolRunner-II CPLD. This is a 1.8V, 256 macrocell device.

Please also note that this design has been verified through simulations, but not on actual hardware.

**************************************************************************************************************************
Technical Support
**************************************************************************************************************************
Technical support for this design and any other CoolRunner CPLD issues can be obtained as follows:

North American Support
(Mon,Tues,Wed,Fri 6:30am-5pm  
  Thr 6:30am - 4:00pm Pacific Standard Time)
Hotline: 1-800-255-7778 
or (408) 879-5199 
Fax: (408) 879-4442 
Email: hotline@xilinx.com 
 
United Kingdom Support
(Mon,Tues,Wed,Thr 9:00am-12:00pm, 1:00-5:30pm
  Fri 9:00am-12:00pm, 1:00-3:30pm)    
Hotline: +44 1932 820821
Fax: +44 1932 828522 
Email : ukhelp@xilinx.com 
 
France Support
(Mon,Tues,Wed,Thr,Fri 9:30am-12:30pm, 2:00-5:30pm)
Hotline: +33 1 3463 0100 
Fax: +33 1 3463 0959
Email : frhelp@xilinx.com 
 
Germany Support
(Mon,Tues,Wed,Thr 8:00am-12:00pm, 1:00-5:00pm, 
   Fri  8:00am-12:00pm, 1:00pm-3:00pm)
Hotline: +49 89 991 54930 
Fax: +49 89 904 4748 
Email : dlhelp@xilinx.com 
 
Japan Support
(Mon,Tues,Thu,Fri  9:00am -5:00pm ()
 Wed    9:00am -4:00pm)
Hotline: (81)3-3297-9163
Fax:: (81)3-3297-0067
Email: jhotline@xilinx.com
