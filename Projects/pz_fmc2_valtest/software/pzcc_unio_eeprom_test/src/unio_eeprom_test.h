
#ifndef __UNIO_EEPROM_TEST_H__
#define __UNIO_EEPROM_TEST_H__

#include "xparameters.h"
#include "types.h"

#include "sleep.h"

// PS GPIO related.
#include "xgpiops.h"

int dump_eeprom_memory(unio_eeprom_t *pDevice);
int read_mac_address(unio_eeprom_t *pDevice);
int run_unio_eeprom_test(void);

#endif // __UNIO_EEPROM_TEST_H__
