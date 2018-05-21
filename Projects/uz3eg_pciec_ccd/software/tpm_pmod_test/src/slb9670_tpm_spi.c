
/************************************************************************
 *
 * Copyright (C) 2012 - 2016 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ************************************************************************/
/***********************************************************************/
/**
 *
 * @file main.c
 *
 * The main file for the SLB9670 TPM SPI Driver
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver	Who	Date		Changes
 * ----- ---- -------- -------------------------------------------------
 * 1.00a lss	09/04/16	Initial release
 *
 *
 ************************************************************************/

/************************** Include Files ******************************/

#include "slb9670_tpm_spi.h"
#include "tpm.h"

/*********************** Constant Definitions **************************/


/************************* Type Definitions ****************************/

/************** Macros (Inline Functions) Definitions ******************/


/*********************** Function Prototypes ***************************/

int XSpiPS_tx_rx(u32 BaseAddress, u32 SPI_Channel, u8 *TxBuffer, u8 *RxBuffer, u32 TxByteCount);

/*********************** Variable Definitions **************************/

extern u32 FsblLength;

/***********************************************************************/
/**
 *
 * This is the main function for the SLB9670 TPM SPI Driver code.
 *
 *
 * @param	None.
 *
 * @return
 *		- XST_SUCCESS to indicate success
 *		- XST_FAILURE.to indicate failure
 *
 * @note
 *
 **********************************************************************/
int tpm_spi_read_bytes (u32 addr, u8 len, u8 *result);
int tpm_spi_write_bytes (u32 addr, u8 len, u8 *value);


/*
 *
 * Status = GetFsblLength(ImageBaseAddress, &FsblLength);
 * fsbl_printf(DEBUG_GENERAL, "FsblLength = 0x%.8lx\r\n",FsblLength);
*/



void hexcram(uint8_t *buf, int bufsize){
	int i;
	for(i=0;i<bufsize;i++)
	{
		xil_printf("%02x",buf[i]);
	}
	xil_printf("\r\n");
}

void hexdump(uint8_t *buf, int bufsize){
	int i;
	for(i=0;i<bufsize;i++)
	{
		xil_printf("0x%02x, ",buf[i]);
	}
	xil_printf("\r\n");
}


#define BUF2U32(x) (x[0] << 24 | x[1] << 16 | x[2] << 8 | x[3]);
#define BUF2U16(x) (x[1] << 8 | x[0]) //bigendian to little

int tpm_get_burstcount(){
	u8 tmp[2] = {0};
	tpm_spi_read_bytes(TPM_BCNT,2, tmp);
	//hexdump(tmp,2);
	//xil_printf("BCNT %x\r\n",BUF2U16(tmp));
	return BUF2U16(tmp);
}

int tpm_get_stsreg(){
	u8 tmp;
	tpm_spi_read_bytes(TPM_STS, 1, &tmp);
	//xil_printf("STS %x\n",tmp);
	return tmp;
}

int tpm_get_accessreg(){
	u8 tmp;
	tpm_spi_read_bytes(TPM_ACCESS, 1, &tmp);
	return tmp;
}

int tpm_request_locality(){
	u8 tmp = 0x02;
	tpm_spi_write_bytes(TPM_ACCESS, 1, &tmp);
	return tmp;
}

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

int tpm_go(){
	u8 tmp = TPM_STS_GO;
	tpm_spi_write_bytes(TPM_STS,1, &tmp);
	return 0;
}


int tpm_cmdready(){
	u8 tmp = TPM_STS_COMMANDREADY;
	tpm_spi_write_bytes(TPM_STS,1, &tmp);
	return 0;
}


int tpm_wait_for_stat(u8 statusbit){
	while ((tpm_get_stsreg() & statusbit) != statusbit){
		usleep(100);
	}
	return 0;
}

#define min(x,y) (x<y)?x:y;
#define max(x,y) (x<y)?x:y;
#define TPM_MAX_SPI_FRAMESIZE 64
int tpm_transmit(u8 * buf, ssize_t buf_len, u8 *outbuf, ssize_t outbuf_len, size_t * response_length) {
	size_t bcnt;
	size_t transmit_size = 0; // all but last byte
	u8 sts;
	u32 paramsize;
	u32 remaining_data;
	*response_length = 0;
	tpm_request_locality();
	if ((tpm_get_accessreg() & TPM_ACTIVE_LOCALITY) != TPM_ACTIVE_LOCALITY) {
		return -1;
	}
	tpm_cmdready();

	tpm_wait_for_stat(TPM_STS_COMMANDREADY);
	while(buf_len > 1){
		bcnt = tpm_get_burstcount();
		transmit_size = min(bcnt, buf_len-1); //last byte is special
		transmit_size = min(transmit_size,TPM_MAX_SPI_FRAMESIZE);
		//		xil_printf("buffer_size %d, transmit_size %d , burstcount %x\n\r", buf_len,transmit_size, bcnt);
		tpm_spi_write_bytes(TPM_FIFO,transmit_size, buf);



		buf_len -= transmit_size;
		buf += transmit_size;
	}

	tpm_wait_for_stat(TPM_STS_VALID);
	sts = tpm_get_stsreg();
	if ((sts & TPM_STS_EXPECT) != TPM_STS_EXPECT){
		xil_printf("length was wrong - expect was not set L%s \n",__LINE__);
		return -1;
	}
	//write last byte

	tpm_spi_write_bytes(TPM_FIFO,transmit_size, buf);
	tpm_wait_for_stat(TPM_STS_VALID);
	sts = tpm_get_stsreg();
	if ((sts & TPM_STS_EXPECT) == TPM_STS_EXPECT){
		xil_printf("length was wrong - expect was still! set L%s \n",__LINE__);
		return -1;
	}

	tpm_go(); //let the fun begin
	tpm_wait_for_stat(TPM_STS_VALID | TPM_STS_DATA_AVAILABLE);

	bcnt = tpm_get_burstcount();
	while (bcnt < 6) {
		usleep(50); // wait a bit - the first transfer should be 10 bytes
		bcnt = tpm_get_burstcount();
	}

	tpm_spi_read_bytes(TPM_FIFO,6, outbuf); // we can always read first  6 byte in one response

	paramsize = outbuf[2]<<24| outbuf[3]<<16| outbuf[4] << 8| outbuf[5];
	//xil_printf("paramsize %d \n");
	remaining_data = paramsize - 6;
	outbuf +=6;
	outbuf_len -= 6;
	while (remaining_data > 1 && outbuf_len > 0) {
		bcnt = tpm_get_burstcount();
		transmit_size = min(remaining_data-1, bcnt);
		transmit_size = min(transmit_size, TPM_MAX_SPI_FRAMESIZE);
		tpm_spi_read_bytes(TPM_FIFO,transmit_size, outbuf);

		remaining_data -= transmit_size;
		outbuf_len -= transmit_size;
		outbuf += transmit_size;

		//xil_printf("remaining %d, transmit_size %d , burstcount %x\n\r", remaining_data,transmit_size, bcnt);
	}

	tpm_wait_for_stat(TPM_STS_VALID);
	sts =  tpm_get_stsreg();

	if ((sts & TPM_STS_DATA_AVAILABLE) !=  TPM_STS_DATA_AVAILABLE){
		xil_printf("no data left where there should be ? %x %s\r\n", sts, __LINE__);
		return -1;
	}
	bcnt = tpm_get_burstcount();
	while (bcnt < 1) {
		usleep(50); // wait a bit - the first transfer should be 10 bytes
		bcnt = tpm_get_burstcount();
	}

	tpm_spi_read_bytes(TPM_FIFO,1, outbuf);

	remaining_data -= 1;
	outbuf_len -= 1;
	outbuf += 1;

	//xil_printf("remaining %d, transmit_size %d , burstcount %x\n\r", remaining_data,transmit_size, bcnt);
	sts =  tpm_get_stsreg();



	if ((sts & TPM_STS_DATA_AVAILABLE) ==  TPM_STS_DATA_AVAILABLE){
		xil_printf("data leftover! %x %s\r\n", sts, __LINE__);
		return -1;
	}


	*response_length=paramsize;
	tpm_cmdready();


	return 0;
}

int startup_tpm_get_random()
{
	int retval = -1;

	u8 tpm2startup[] = {0x80,0x01,0x00,0x00,0x00,0x0c,0x00,0x00,0x01,0x44,0x00,0x00};
	u8 tpm2getrandom[] = {0x80,0x01,0x00,0x00,0x00,0x0c,0x00,0x00,0x1,0x7B,0x00,0x10};
	u8 response_buffer[50] = { 0 };
	size_t response_length = 0;

	memset(response_buffer, 0x00, ARRAY_SIZE(response_buffer));
	if (0 != tpm_transmit(tpm2startup, ARRAY_SIZE(tpm2startup), response_buffer, ARRAY_SIZE(response_buffer), &response_length))
		goto exit;

	print("TPM Startup: ");
	hexcram(response_buffer, response_length);

	memset(response_buffer, 0x00, ARRAY_SIZE(response_buffer));
	if (0 != tpm_transmit(tpm2getrandom, ARRAY_SIZE(tpm2getrandom), response_buffer, ARRAY_SIZE(response_buffer), &response_length))
		goto exit;

	print("TPM GetRandom: ");
	hexcram(response_buffer, response_length);
	
	u8 tmp = 0x20;
	tpm_spi_write_bytes(TPM_ACCESS, 1, &tmp);
	print("TPM control relinquished");
	retval = 0;
exit:
	return retval;
}
