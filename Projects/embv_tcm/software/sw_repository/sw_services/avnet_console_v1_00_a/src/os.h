#if defined(LINUX_CODE)

  // Linux
  #define OS_PRINTF     printf
  #define OS_GETCHAR()  getchar()
  #define OS_PUTCHAR(a) putchar(a)

#else

  // Stand-alone
  #define OS_PRINTF     xil_printf
  #define OS_GETCHAR()  inbyte()
  #define OS_PUTCHAR(a) outbyte(a)

#endif

