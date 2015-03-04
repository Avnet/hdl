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
--   * polynomial: (0 2 3 6 8)
--   * data width: 8
--
-- Info : tools@easics.be
--        http://www.easics.com
--------------------------------------------------------------------------------
--
-- *********************************************************************
-- File           : $RCSfile: pck_crc8_d8.vhd.rca $
-- Author         : $Author: fec $
-- Author's Email : fec@cypress.com
-- Department     : MPD_BE
-- Date           : $Date: Thu Oct  8 18:40:45 2009 $
-- Revision       : $Revision: 1.1 $
-- *********************************************************************
-- Modification History Summary
-- Date        By   Version  Change Description
-- *********************************************************************
-- $Log: pck_crc8_d8.vhd.rca $
-- 
--  Revision: 1.1 Thu Oct  8 18:40:45 2009 fec
--  {CRC 8 polynome}
--
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PCK_CRC8_D8 is
  -- polynomial: (0 2 3 6 8)
  -- data width: 8
  -- convention: the first serial bit is D[7]
  function nextCRC8_D8
    (data: unsigned(7 downto 0);
     crc:  unsigned(7 downto 0))
    return unsigned;
end PCK_CRC8_D8;


package body PCK_CRC8_D8 is

  -- polynomial: (0 2 3 6 8)
  -- data width: 8
  -- convention: the first serial bit is D[7]
  function nextCRC8_D8
    (data: unsigned(7 downto 0);
     crc:  unsigned(7 downto 0))
    return unsigned is

    variable d:      unsigned(7 downto 0);
    variable c:      unsigned(7 downto 0);
    variable newcrc: unsigned(7 downto 0);

  begin
    d := data;
    c := crc;

    newcrc(0) := d(5) xor d(4) xor d(2) xor d(0) xor c(0) xor c(2) xor
                 c(4) xor c(5);

    newcrc(1) := d(6) xor d(5) xor d(3) xor d(1) xor c(1) xor c(3) xor
                 c(5) xor c(6);

    newcrc(2) := d(7) xor d(6) xor d(5) xor d(0) xor c(0) xor c(5) xor
                 c(6) xor c(7);

    newcrc(3) := d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor
                 d(0) xor c(0) xor c(1) xor c(2) xor c(4) xor c(5) xor
                 c(6) xor c(7);

    newcrc(4) := d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor
                 c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(7);

    newcrc(5) := d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(2) xor
                 c(3) xor c(4) xor c(6) xor c(7);

    newcrc(6) := d(7) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor
                 c(3) xor c(7);

    newcrc(7) := d(4) xor d(3) xor d(1) xor c(1) xor c(3) xor c(4);

    return newcrc;

  end nextCRC8_D8;

end PCK_CRC8_D8;
