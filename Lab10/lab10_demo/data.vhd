----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:34:50 04/12/2018 
-- Design Name: 
-- Module Name:    data - Behavioral 
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

entity data is
	port(	address : in std_logic_vector (31 downto 0);
			write_data : in std_logic_vector (31 downto 0);
			mem_write, mem_read : in std_logic;
			read_data : out std_logic_vector (31 downto 0);
			wclock : in std_logic);
end data;

architecture Behavioral of data is
	type mem_array is array (0 to 7) of std_logic_vector (31 downto 0);
begin
	ReadWrite1 : process
		variable data_mem : mem_array := (
			x"00000000",
			x"00000000",
			x"00000000",
			x"00000000",
			x"00000000",
			x"00000000",
			x"00000000",
			x"00000000");
		variable addr : unsigned (2 downto 0);
		variable mem_content : std_logic_vector (31 downto 0);
		
		begin
		wait until falling_edge(wclock);
		
		addr := unsigned(address(2 downto 0));
		mem_content := write_data;
		
		if mem_write = '1' then
			data_mem(to_integer(addr)) := mem_content;
			read_data <= mem_content;
		end if;
	end process;
end Behavioral;

