
-- *********************************************************************
-- Author         : $Author: fwi $
-- Department     : MPD_BE
-- Date           : $Date: 2010-03-17 12:13:46 +0100 (Wed, 17 Mar 2010) $
-- Revision       : $Revision: 62 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

--------------------------------------------------------------------------------
-- Copyright (C) 1999-2008 Easics NV.
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains the original copyright notice
-- and the associated disclaimer.
--
-- THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--
-- Purpose : synthesizable CRC function
--   * polynomial: (0 1 2 3 6 9 10)
--   * data width: 10
--
-- Info : tools@easics.be
--        http://www.easics.com
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PCK_CRC10_D10 is
  -- polynomial: (0 1 2 3 6 9 10)
  -- data width: 10
  -- convention: the first serial bit is D[9]
  function nextCRC10_D10
    (Data: unsigned(9 downto 0);
     crc:  unsigned(9 downto 0))
    return unsigned;
end PCK_CRC10_D10;


package body PCK_CRC10_D10 is

  -- polynomial: (0 1 2 3 6 9 10)
  -- data width: 10
  -- convention: the first serial bit is D[9]
  function nextCRC10_D10
    (Data: unsigned(9 downto 0);
     crc:  unsigned(9 downto 0))
    return unsigned is

    variable d:      unsigned(9 downto 0);
    variable c:      unsigned(9 downto 0);
    variable newcrc: unsigned(9 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(5) xor d(3) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(3) xor c(5);
    newcrc(1) := d(6) xor d(5) xor d(4) xor d(0) xor c(0) xor c(4) xor c(5) xor c(6);
    newcrc(2) := d(7) xor d(6) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(6) xor c(7);
    newcrc(3) := d(8) xor d(7) xor d(5) xor d(4) xor d(2) xor d(0) xor c(0) xor c(2) xor c(4) xor c(5) xor c(7) xor c(8);
    newcrc(4) := d(9) xor d(8) xor d(6) xor d(5) xor d(3) xor d(1) xor c(1) xor c(3) xor c(5) xor c(6) xor c(8) xor c(9);
    newcrc(5) := d(9) xor d(7) xor d(6) xor d(4) xor d(2) xor c(2) xor c(4) xor c(6) xor c(7) xor c(9);
    newcrc(6) := d(8) xor d(7) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(7) xor c(8);
    newcrc(7) := d(9) xor d(8) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(8) xor c(9);
    newcrc(8) := d(9) xor d(4) xor d(3) xor d(2) xor c(2) xor c(3) xor c(4) xor c(9);
    newcrc(9) := d(4) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(4);
    return newcrc;
  end nextCRC10_D10;

end PCK_CRC10_D10;
