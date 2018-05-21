
#include "slb9670_tpm_spi.h"
#define MAX_SPI_FRAMESIZE 64

//error.h
#define EPERM        1  /* Operation not permitted */
#define ENOENT       2  /* No such file or directory */
#define ESRCH        3  /* No such process */
#define EINTR        4  /* Interrupted system call */
#define EIO      5  /* I/O error */
#define ENXIO        6  /* No such device or address */
#define E2BIG        7  /* Argument list too long */
#define ENOEXEC      8  /* Exec format error */
#define EBADF        9  /* Bad file number */
#define ECHILD      10  /* No child processes */
#define EAGAIN      11  /* Try again */
#define ENOMEM      12  /* Out of memory */
#define EACCES      13  /* Permission denied */
#define EFAULT      14  /* Bad address */
#define ENOTBLK     15  /* Block device required */
#define EBUSY       16  /* Device or resource busy */
#define EEXIST      17  /* File exists */
#define EXDEV       18  /* Cross-device link */
#define ENODEV      19  /* No such device */
#define ENOTDIR     20  /* Not a directory */
#define EISDIR      21  /* Is a directory */
#define EINVAL      22  /* Invalid argument */
#define ENFILE      23  /* File table overflow */
#define EMFILE      24  /* Too many open files */
#define ENOTTY      25  /* Not a typewriter */
#define ETXTBSY     26  /* Text file busy */
#define EFBIG       27  /* File too large */
#define ENOSPC      28  /* No space left on device */
#define ESPIPE      29  /* Illegal seek */
#define EROFS       30  /* Read-only file system */
#define EMLINK      31  /* Too many links */
#define EPIPE       32  /* Broken pipe */
#define EDOM        33  /* Math argument out of domain of func */
#define ERANGE      34  /* Math result not representable */




int XSpiPS_tx_rx(u32 BaseAddress, u32 SPI_Channel, u8 *TxBuffer, u8 *RxBuffer, u32 TxByteCount);


static int spi_transfer(u8 *TxBuffer, u8 *RxBuffer, u32 TxByteCount) {
	return XSpiPS_tx_rx(SPI_BASEADDR, SPI_CHANNEL_SEL_0, TxBuffer, RxBuffer, TxByteCount);
}

int tpm_spi_read_bytes (u32 addr, u8 len,  u8 *result) {
	u8 tx_buf[len+4];
	u8 rx_buf[len+4];

	if (len > MAX_SPI_FRAMESIZE) {
		print("too large\n");
		return -E2BIG;
}

	memset(tx_buf, 0, 4 + len);
	tx_buf[0] = 0x80 | (len-1); //0x80 = read  | 0=1byte
	tx_buf[1] = 0xD4; // part of the FED4 address
	tx_buf[2] = (addr>>8)  & 0xFF;
	tx_buf[3] = (addr)     & 0xFF;

	spi_transfer(tx_buf, rx_buf, len+4 );

	memcpy(result, &rx_buf[4], len);
	return 0;
}

int tpm_spi_write_bytes (u32 addr, u8 len, u8 *value) {
	u8 tx_buf[len+4];
	u8 rx_buf[len+4];
	if (len > MAX_SPI_FRAMESIZE) {
		print("write request too large\n");
		return -E2BIG;
	}
	memset(tx_buf, 0, 4 + len);

	tx_buf[0] = 0x00 | (len-1); //0x00 = write | 0 = 1byte
	tx_buf[1] = 0xD4;  // part of the FED4 address
	tx_buf[2] = (addr>>8)  & 0xFF;
	tx_buf[3] = (addr)     & 0xFF;
	memcpy(&tx_buf[4], value, len);

	spi_transfer(tx_buf, rx_buf, len+4 );
	return 0;
}
