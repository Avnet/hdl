//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
//
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2015 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jul 21, 2015
// Design Name:         MicroZed Real Time Clock Demonstration
// Module Name:         zed_rtc_demo.c
// Project Name:        MicroZed + Real Time Clock Pmod
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     MicroZed + Real Time Clock Pmod
//
// Tool versions:       Xilinx Vivado 2014.4
//
// Description:         MicroZed Real Time Clock Demonstration
//
// Dependencies:
//
// Revision:            Jul 21, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "xil_cache.h"

#include "zed_rtc_demo.h"

/* The DS3231M is located at the 7-bit slave address 0xD0 so a write
 * operation occurs at 0xD0 and read operations occur at 0xD1.
 *
 *  MSB                          LSB
 * +---------------------------------+
 * | 1 | 1 | 0 | 1 | 0 | 0 | 0 | R/W |
 * +---------------------------------+
 *
 * The way this gets passed to the AXI IIC API is that the slave address
 * is just passed in as just 7-bits (0x68) and the API handles shifting the
 * address it the left by a bit and appending the read bit if a read operation
 * is occurring.  This is always a bit confusing so this would be a good place
 * to write this down so that time does not have to be spent figuring this out
 * with a scope in the lab at some point in the future.
 *
 */
#define DS3231M_SLAVE_ADDRESS                    0x68

/*  Maxim DS3231M register definitions.
 */
#define DS3231M_SECONDS                          0x00
#define DS3231M_MINUTES                          0x01
#define DS3231M_HOUR                             0x02
#define DS3231M_DAY                              0x03
#define DS3231M_DATE                             0x04
#define DS3231M_MONTH                            0x05
#define DS3231M_YEAR                             0x06
#define DS3231M_ALARM1_SECONDS                   0x07
#define DS3231M_ALARM1_MINUTES                   0x08
#define DS3231M_ALARM1_HOUR                      0x09
#define DS3231M_ALARM1_DATE                      0x0A
#define DS3231M_ALARM2_MINUTES                   0x0B
#define DS3231M_ALARM2_HOUR                      0x0C
#define DS3231M_ALARM2_DATE                      0x0D
#define DS3231M_CONTROL                          0x0E
#define DS3231M_STATUS                           0x0F
#define DS3231M_AGING_OFFSET                     0x10
#define DS3231M_TEMP_MSB                         0x11
#define DS3231M_TEMP_LSB                         0x12

/*  Maxim DS3231M Alarm Register bit definitions.
 */
#define DS3231M_ALARM1_SECONDS_A1M1              7
#define DS3231M_ALARM1_MINUTES_A1M2              7
#define DS3231M_ALARM1_HOUR_A1M3                 7
#define DS3231M_ALARM1_DATE_A1M4                 7
#define DS3231M_ALARM2_MINUTES_A2M2              7
#define DS3231M_ALARM2_HOUR_A2M3                 7
#define DS3231M_ALARM2_DATE_A2M4                 7

/*  Maxim DS3231M Control Register bit definitions.
 */
#define DS3231M_CONTROL_EOSC                     7
#define DS3231M_CONTROL_BBSQW                    6
#define DS3231M_CONTROL_CONV                     5
#define DS3231M_CONTROL_INTCN                    2
#define DS3231M_CONTROL_A2IE                     1
#define DS3231M_CONTROL_A1IE                     0

/*  Maxim DS3231M Control Register bit definitions.
 */
#define DS3231M_STATUS_OSF                       7
#define DS3231M_STATUS_EN32KHZ                   3
#define DS3231M_STATUS_BSY                       2
#define DS3231M_STATUS_A2F                       1
#define DS3231M_STATUS_A1F                       0

#define MAX_RTC_DATA_BYTES                       DS3231M_TEMP_LSB

void RTC_Isr(void *InstancePtr)
{
   int8u ChipAddress = DS3231M_SLAVE_ADDRESS;
   int8u RegAddress  = DS3231M_SECONDS;
   int8u RegData[MAX_RTC_DATA_BYTES];
   int8u ByteCount   = MAX_RTC_DATA_BYTES;

   int ret;

   zed_rtc_demo_t *pDemo = (zed_rtc_demo_t *)InstancePtr;

   // Increment the total count on the number of IRQs so that the user can see
   // how many interrupts occur in between actual alarm events.
   pDemo->rtc_irqs++;

   /* Retrieve the current status of the RTC by performing a dump of all
    * registers.
    */
   ret = pDemo->rtc_iic.fpIicRead(&(pDemo->rtc_iic), ChipAddress, RegAddress, RegData, ByteCount);
   if (!ret)
   {
      xil_printf("ERROR: Failed to read RTC\n\r");
      return;
   }

   /* Extract the relevant raw data from the retrieved register dump.
    */
   pDemo->rtc_date       = RegData[DS3231M_DATE];
   pDemo->rtc_day        = RegData[DS3231M_DAY];
   pDemo->rtc_hours      = RegData[DS3231M_HOUR];
   pDemo->rtc_minutes    = RegData[DS3231M_MINUTES];
   pDemo->rtc_month      = RegData[DS3231M_MONTH];
   pDemo->rtc_seconds    = RegData[DS3231M_SECONDS];
   pDemo->rtc_status     = RegData[DS3231M_STATUS];
   pDemo->rtc_year       = RegData[DS3231M_YEAR];
   pDemo->rtc_temp_upper = RegData[DS3231M_TEMP_MSB];
   pDemo->rtc_temp_lower = RegData[DS3231M_TEMP_LSB];
   pDemo->rtc_events++;

   /* If one of the alarms have been triggered, their flags must be cleared
    * in order for the interrupt to be serviced and re-armed for the next
    * alarm period.
    */
   if ((RegData[DS3231M_STATUS] & 0x03) > 0)
   {
	   RegData[0] = (1 << DS3231M_CONTROL_BBSQW) | (1 << DS3231M_CONTROL_INTCN) | (1 << DS3231M_CONTROL_A2IE) | (1 << DS3231M_CONTROL_A1IE) | 0;
	   RegData[1] = (pDemo->rtc_status & 0xFC);

	   /* Write the prepared registers to the target slave device.
	    */
	   ret = pDemo->rtc_iic.fpIicWrite(&(pDemo->rtc_iic), ChipAddress, DS3231M_CONTROL, RegData, 2);
	   if (!ret)
	   {
	       xil_printf( "ERROR : Failed to clear alarm flags\n\r" );
	       return;
	   }
   }

   return;
}

/****************************************************************************/
/**
* This function sets up the interrupt system for the example.  The processing
* contained in this funtion assumes the hardware system was built with
* and interrupt controller.
*
* @param	None.
*
* @return	A status indicating XST_SUCCESS or a value that is contained in
*		xstatus.h.
*
* @note		None.
*
*****************************************************************************/
int zed_rtc_demo_SetupInterruptSystem(zed_rtc_demo_t *pDemo)
{
	int ret;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	pDemo->pIntcConfig = XScuGic_LookupConfig(pDemo->uDeviceId_IRQ_RTC);
	if (NULL == pDemo->pIntcConfig)
	{
		return XST_FAILURE;
	}

	ret = XScuGic_CfgInitialize(&(pDemo->Intc), pDemo->pIntcConfig,
			pDemo->pIntcConfig->CpuBaseAddress);
	if (ret != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	XScuGic_SetPriorityTriggerType(&(pDemo->Intc), pDemo->uInterruptId_IRQ_RTC,
					0xA0, 0x3);

	/*
	 * Connect the interrupt handler that will be called when an
	 * interrupt occurs for the device.
	 */
	ret = XScuGic_Connect(&(pDemo->Intc), pDemo->uInterruptId_IRQ_RTC,
				 (Xil_ExceptionHandler)RTC_Isr, pDemo);
	if (ret != XST_SUCCESS)
	{
		return ret;
	}

	/*
	 * Enable the PS interrupts for the RTC hardware device.
	 */
	XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_RTC);

	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)XScuGic_InterruptHandler, &(pDemo->Intc));

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

int ds3231m_initialize(zed_rtc_demo_t *pDemo)
{
   int ret = 0;

   int8u ByteCount = 0;
   int8u ChipAddress = DS3231M_SLAVE_ADDRESS;
   int8u RegAddress  = DS3231M_SECONDS;
   int8u RegData[MAX_RTC_DATA_BYTES];

   /* Here the Maxim DS3231M device registers are initialized so that the
    * test application can begin.
    */

   /* Setup the value written to the Seconds Register.
    */
   RegData[ByteCount++] = 0x55; // 55 Seconds

   /* Setup the value written to the Minutes Register.
    */
   RegData[ByteCount++] = 0x28; // 28 Minutes

   /* Setup the value written to the Hour Register.
    */
   RegData[ByteCount++] = 0x19; // 24 Hour Mode + Hour 19

   /* Setup the value written to the Day Register.
    */
   RegData[ByteCount++] = 0x04; // Day 4 - Wednesday

   /* Setup the value written to the Date Register.
    */
   RegData[ByteCount++] = 0x21; // Date 21

   /* Setup the value written to the Month Register.
    */
   RegData[ByteCount++] = 0x10; // Month 10 - October

   /* Setup the value written to the Year Register.
    */
   RegData[ByteCount++] = 0x15; // Year 15 - 2015

   /* Setup the alarm registers with some placeholder data for now.
    */
   RegData[ByteCount++] = (1 << DS3231M_ALARM1_SECONDS_A1M1) | 0x59; // A1M1=0, Seconds - Alarm 1
   RegData[ByteCount++] = (1 << DS3231M_ALARM1_MINUTES_A1M2) | 0x59; // A1M2=0, Minutes - Alarm 1
   RegData[ByteCount++] = (1 << DS3231M_ALARM1_HOUR_A1M3) | 0x23; // A1M3=0, Hour - Alarm 1
   RegData[ByteCount++] = (1 << DS3231M_ALARM1_DATE_A1M4) | 0x10; // A1M4=0, Date - Alarm 1
   RegData[ByteCount++] = (0 << DS3231M_ALARM2_MINUTES_A2M2) | 0x59; // A2M2=0, Minutes - Alarm 2
   RegData[ByteCount++] = (0 << DS3231M_ALARM2_HOUR_A2M3) | 0x23; // A2M3=0, Hour - Alarm 2
   RegData[ByteCount++] = (0 << DS3231M_ALARM2_DATE_A2M4) | 0x10; // A2M4=0, Date - Alarm 2

   /* Setup the value written to the Control Register.  Enable the oscillator
    * to begin time keeping operation.  Interrupts from alarm functions are
    * enabled here also.  According to the device errata: "DS3231M BBSQW bit
    * (if = 1) enables SQW and RTC alarm interrupt when operating on VBAT
    * supply."
    */
   RegData[ByteCount++] = (1 << DS3231M_CONTROL_BBSQW) | (1 << DS3231M_CONTROL_INTCN) | (1 << DS3231M_CONTROL_A2IE) | (1 << DS3231M_CONTROL_A1IE) | 0;

   /* Setup the value written to the Status Register.  Clear the oscillator
    * stop flag since this could be the first time the device was powered on.
    * Set the 32kHz output to high impedance since this won't be used during
    * this testing.
    */
   RegData[ByteCount++] = (0 << DS3231M_STATUS_OSF) | (0 << DS3231M_STATUS_EN32KHZ) | 0;

   /* Write the prepared registers to the target slave device.
    */
   ret = pDemo->rtc_iic.fpIicWrite(&(pDemo->rtc_iic), ChipAddress, RegAddress, RegData, ByteCount);
   if (!ret)
   {
       xil_printf( "ERROR : Failed to write RTC Control Register \n\rVerify that device is connected to Pmod JC, Pins 1-6\n\r" );
       return -1;
   }

   return 0;
}

int zed_rtc_demo_calculate_datetime(zed_rtc_demo_t *pDemo)
{
   int8u rtc_date = 0;
   int8u rtc_hours = 0;
   int8u rtc_minutes = 0;
   int8u rtc_month = 0;
   int8u rtc_seconds = 0;
   int8u rtc_year = 0;
   double rtc_temp = 0;

   /* Extract the relevant seconds data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * |  0  |    10 seconds   |         seconds       |
    * +-----------------------------------------------+
    * |  0  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_seconds = ((((pDemo->rtc_seconds >> 4) & 0x07) * 10) + (pDemo->rtc_seconds & 0x0F));

   /* Extract the relevant minutes data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * |  0  |    10 minutes   |         minutes       |
    * +-----------------------------------------------+
    * |  0  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_minutes = ((((pDemo->rtc_minutes >> 4) & 0x07) * 10) + (pDemo->rtc_minutes & 0x0F));

   /* Extract the relevant hour data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * |  0  |12/24|20 hr|10 hr|          hour         |
    * +-----------------------------------------------+
    * |  0  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_hours = ((((pDemo->rtc_hours >> 5) & 0x01) * 20) + (((pDemo->rtc_hours >> 4) & 0x01) * 10) + (pDemo->rtc_hours & 0x0F));

   /* Extract the relevant date data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * |  0  |  0  |  10 date  |          date         |
    * +-----------------------------------------------+
    * |  0  |  0  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_date = ((((pDemo->rtc_date >> 4) & 0x03) * 10) + (pDemo->rtc_date & 0x0F));

   /* Extract the relevant month data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * | Cen |  0  |  0  |10 mo|        month          |
    * +-----------------------------------------------+
    * |  X  |  0  |  0  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_month = ((((pDemo->rtc_month >> 4) & 0x01) * 10) + (pDemo->rtc_month & 0x0F));

   /* Extract the relevant year data from the retrieved register dump.
    *
    * Data is in binary coded decimal format, stored as follows:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * |         10 year       |         year          |
    * +-----------------------------------------------+
    * |  X  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    */
   rtc_year = ((((pDemo->rtc_year >> 4) & 0x0F) * 10) + (pDemo->rtc_year & 0x0F));

   /* Extract the relevant year data from the retrieved register dump.
    *
    * Data is in twos compliment format, stored as follows:
    *
    * Upper Byte:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * | sign|           temperature (C)               |
    * +-----------------------------------------------+
    * |  X  |  X  |  X  |  X  |  X  |  X  |  X  |  X  |
    * +-----------------------------------------------+
    *
    * Lower Byte:
    *
    *  MSB                                         LSB
    * +-----------------------------------------------+
    * |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
    * +-----------------------------------------------+
    * | fractional|                                   |
    * +-----------------------------------------------+
    * |  0  |  0  |  0  |  0  |  0  |  0  |  0  |  0  |
    * +-----------------------------------------------+
    *
    */
   rtc_temp = ((((pDemo->rtc_temp_lower >> 6) & 0x03) * 0.25) + (char) pDemo->rtc_temp_upper);

   /* Copy all of the calculated date/time data back.
    */
   pDemo->rtc_date = rtc_date;
   pDemo->rtc_hours = rtc_hours;
   pDemo->rtc_minutes = rtc_minutes;
   pDemo->rtc_month = rtc_month;
   pDemo->rtc_seconds = rtc_seconds;
   pDemo->rtc_temp = rtc_temp;
   pDemo->rtc_year = rtc_year;

   return 0;
}

int zed_rtc_demo_status(zed_rtc_demo_t *pDemo)
{
   int8u ChipAddress = DS3231M_SLAVE_ADDRESS;
   int8u RegAddress  = DS3231M_SECONDS;
   int8u RegData[MAX_RTC_DATA_BYTES];
   int8u ByteCount   = MAX_RTC_DATA_BYTES;
   int ret;

   /* Setup for a read of all registers from the RTC device.
    */
   ret = pDemo->rtc_iic.fpIicRead(&(pDemo->rtc_iic), ChipAddress, RegAddress, RegData, (ByteCount + 1));
   if (!ret)
   {
      xil_printf("ERROR : Failed to read Touch Controller\n\r");
      return -1;
   }

   xil_printf("RTC: Maxim DS3231M RTC Detected\n\r");

   xil_printf("RTC: Seconds    = 0x%02X\n\r", RegData[DS3231M_SECONDS]);
   xil_printf("RTC: Minutes    = 0x%02X\n\r", RegData[DS3231M_MINUTES]);
   xil_printf("RTC: Hour       = 0x%02X\n\r", RegData[DS3231M_HOUR]);
   xil_printf("RTC: Date       = 0x%02X\n\r", RegData[DS3231M_DATE]);
   xil_printf("RTC: Month      = 0x%02X\n\r", RegData[DS3231M_MONTH]);
   xil_printf("RTC: Year       = 0x%02X\n\r", RegData[DS3231M_YEAR]);
   xil_printf("RTC: A1 Seconds = 0x%02X\n\r", RegData[DS3231M_ALARM1_SECONDS]);
   xil_printf("RTC: A1 Minutes = 0x%02X\n\r", RegData[DS3231M_ALARM1_MINUTES]);
   xil_printf("RTC: A1 Hour    = 0x%02X\n\r", RegData[DS3231M_ALARM1_HOUR]);
   xil_printf("RTC: A1 Date    = 0x%02X\n\r", RegData[DS3231M_ALARM1_DATE]);
   xil_printf("RTC: A2 Minutes = 0x%02X\n\r", RegData[DS3231M_ALARM2_MINUTES]);
   xil_printf("RTC: A2 Hour    = 0x%02X\n\r", RegData[DS3231M_ALARM2_HOUR]);
   xil_printf("RTC: A2 Date    = 0x%02X\n\r", RegData[DS3231M_ALARM2_DATE]);
   xil_printf("RTC: Control    = 0x%02X\n\r", RegData[DS3231M_CONTROL]);
   xil_printf("RTC: Status     = 0x%02X\n\r", RegData[DS3231M_STATUS]);
   xil_printf("RTC: Age Offset = 0x%02X\n\r", RegData[DS3231M_AGING_OFFSET]);
   xil_printf("RTC: Temp MSB   = 0x%02X\n\r", RegData[DS3231M_TEMP_MSB]);
   xil_printf("RTC: Temp LSB   = 0x%02X\n\r", RegData[DS3231M_TEMP_LSB]);

   return 0;
}

int zed_rtc_demo_init(zed_rtc_demo_t *pDemo)
{
   int ret;

   /* IIC initialization for communicating with the RTC slave hardware.
    */
   xil_printf("I2C RTC Initialization ...\n\r");
   ret = zed_iic_axi_init(&(pDemo->rtc_iic),"RTC I2C", pDemo->uBaseAddr_IIC_RTC);
   if (!ret)
   {
      xil_printf("ERROR : Failed to open AXI IIC device driver\n\r");
      return -1;
   }

   /* Initialize statistics for tracking test results.
    */
   pDemo->rtc_irqs       = 0;
   pDemo->rtc_events     = 0;

   xil_printf("ds3231m_initialize\n\r");
   /* Initialize the RTC device and set the alarm functions. */
   ds3231m_initialize(pDemo);

   xil_printf("zed_rtc_demo_SetupInterruptSystem\n\r");
   /* Initialize the interrupt handling so that alarm events can be captured.
    */
   zed_rtc_demo_SetupInterruptSystem(pDemo);

   xil_printf("zed_rtc_demo_status\n\r");
   millisleep(100);
   /* Check to see how the device has been configured. */
   zed_rtc_demo_status(pDemo);

   return 0;
}
