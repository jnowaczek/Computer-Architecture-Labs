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
			pc_out, instruction : out std_logic_vector (31 downto 0);
			mem_select : in std_logic_vector (1 downto 0));
			
end fetch;

architecture Behavioral of fetch is
	type mem_array is array (0 to 15) of std_logic_vector (31 downto 0);
	signal mem0 : mem_array := (
		x"20010066", x"20020021", x"00221820", x"00221822", x"00221825",
		x"08000000", x"00000000", x"00000000", x"00000000", x"00000000",
		x"00000000", x"00000000", x"00000000",	x"00000000", x"00000000",
		x"00000000");
	signal mem1 : mem_array := (
		x"20032013", x"ac030005", x"8c040005", x"08000000", x"00000000",
		x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
		x"00000000", x"00000000", x"00000000",	x"00000000", x"00000000",
		x"00000000");
	signal mem2 : mem_array := (
		x"20010000", x"20020004", x"20210001", x"1022fffc", x"08000002",
		x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
		x"00000000", x"00000000", x"00000000",	x"00000000", x"00000000",
		x"00000000");
	signal mem3 : mem_array := (
		x"20020040", x"20040101", x"20050000", x"00452820", x"20420001",
		x"10440001", x"08000003", x"ac050003", x"8c050003", x"08000008",
		x"00000000", x"00000000", x"00000000",	x"00000000", x"00000000",
		x"00000000");
begin
	process
		variable PC : std_logic_vector (31 downto 0);
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
			end if;
			index := to_integer(unsigned(PC));
		end if;
		
		case mem_select is 
			when "00" =>
				instruction <= mem0(index);
			when "01" =>
				instruction <= mem1(index);
			when "10" =>
				instruction <= mem2(index);
			when others =>
				instruction <= mem3(index);
		end case;
		
		PC := std_logic_vector(unsigned(PC) +  1);
		pc_out <= PC;
	end process;
end Behavioral;

