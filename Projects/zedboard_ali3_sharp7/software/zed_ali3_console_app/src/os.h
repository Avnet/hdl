#if defined(LINUX_CODE)

  // Linux
  #define OS_PRINTF     printf
  #define OS_GETCHAR()  getchar()
  #define OS_PUTCHAR(a) putchar(a)

#else

  extern void xil_printf( const char *ctrl1, ...);
  extern char inbyte(void);
  extern void outbyte(char c);

  // Stand-alone
  #define OS_PRINTF     xil_printf
  #define OS_GETCHAR()  inbyte()
  #define OS_PUTCHAR(a) outbyte(a)

#endif

