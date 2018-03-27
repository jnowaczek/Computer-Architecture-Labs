----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:08:18 02/21/2018 
-- Design Name: 
-- Module Name:    hex_to_ascii - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hex_to_ascii is
	port(	hex : in std_logic_vector (3 downto 0);
			ascii : out std_logic_vector (7 downto 0));
end hex_to_ascii;

architecture Behavioral of hex_to_ascii is

begin
ascii <= "00110000" when (hex = x"0") else
			"00110001" when (hex = x"1") else
			"00110010" when (hex = x"2") else
			"00110011" when (hex = x"3") else
			"00110100" when (hex = x"4") else
			"00110101" when (hex = x"5") else
			"00110110" when (hex = x"6") else
			"00110111" when (hex = x"7") else
			"00111000" when (hex = x"8") else
			"00111001" when (hex = x"9") else
			"01000001" when (hex = x"a") else
			"01000010" when (hex = x"b") else
			"01000011" when (hex = x"c") else
			"01000100" when (hex = x"d") else
			"01000101" when (hex = x"e") else
			"01000110";

end Behavioral;

