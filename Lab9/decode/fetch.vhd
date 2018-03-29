----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:35:09 03/21/2018 
-- Design Name: 
-- Module Name:    fetch - Behavioral 
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

entity fetch is
	port(	branch_addr, jump_addr : in std_logic_vector (31 downto 0);
			branch_decision, jump_decision, clock, reset : in std_logic;
			pc_out, instruction : out std_logic_vector (31 downto 0));
			
end fetch;

architecture Behavioral of fetch is
	type mem_array is array (0 to 15) of std_logic_vector (31 downto 0);
	signal mem : mem_array := (
		x"8c220000", x"8c640001", x"00622022", x"ac640000", x"1022fffb",
		x"00612064", x"08000000", x"00000000", x"00000000", x"00000000",
		x"00000000", x"00000000", x"00000000",	x"00000000", x"00000000",
		x"00000000");
begin
	process
		variable PC : std_logic_vector (31 downto 0) := (others => '0');
		variable index : integer := 0;
	begin
		wait until rising_edge(clock);
		if (reset = '1') then
			PC := (others => '0');
			index := 0;
		else
			if (branch_decision = '1') then
				PC := branch_addr;
			elsif (jump_decision = '1') then
				PC := jump_addr;
			else
				index := to_integer(unsigned(PC));
			end if;
		end if;
		
		instruction <= mem(index);
		
		PC := std_logic_vector(unsigned(PC) +  1);
		pc_out <= PC;
	end process;
end Behavioral;
