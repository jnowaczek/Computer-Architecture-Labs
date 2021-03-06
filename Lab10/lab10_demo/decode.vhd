----------------------------------------------------------------------------------
-- Engineer: Julian Nowaczek and Sam Larson
-- 
-- Create Date:    12:02:53 03/27/2018 
-- Module Name:    decode - Behavioral 
-- Description: mips decode module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode is
	port(	instruction, memory_data, alu_result : in std_logic_vector (31 downto 0);
			register_rs, register_rt, write_data : out std_logic_vector (31 downto 0);
			register_rd, jump_addr, immediate : out std_logic_vector (31 downto 0);
			regdst, regwrite, memtoreg, reset, clock, writeClock : in std_logic);
end decode;

architecture Behavioral of decode is
type reg_array is array (0 to 15) of std_logic_vector (31 downto 0);
signal reg : reg_array := (x"00000000", x"00000000", x"00000000", x"00000000",
	x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
	x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");
begin

	reg_write : process
		variable write_value : std_logic_vector (31 downto 0);
		variable addr2, addr3 : std_logic_vector (4 downto 0);
		variable index : integer;
		
		begin
		wait until (writeClock'event and writeClock = '0');
		
		if reset = '1' then
			reg(0) <= x"00000000";
			reg(1) <= x"00000000";
			reg(2) <= x"00000000";
			reg(3) <= x"00000000";
			reg(4) <= x"00000000";
			reg(5) <= x"00000000";
			reg(6) <= x"00000000";
			reg(7) <= x"00000000";
			reg(8) <= x"00000000";
			reg(9) <= x"00000000";
			reg(10) <= x"00000000";
			reg(11) <= x"00000000";
			reg(12) <= x"00000000";
			reg(13) <= x"00000000";
			reg(14) <= x"00000000";
			reg(15) <= x"00000000";
		end if;
		
		addr2 := instruction(20 downto 16);
		addr3 := instruction(15 downto 11);
		if regdst = '0' then
			addr3 := addr2;
		end if;
		
		if regwrite = '1' then
			if memtoreg = '1' then
				write_value := memory_data;
			else
				write_value := alu_result;
			end if;

			if addr3 = "00000" then
				reg(0) <= x"00000000";
			else
				index := to_integer(unsigned(addr3));
				reg(index) <= write_value;
			end if;
			write_data <= write_value;
		end if;
	end process;

	reg_read : process (instruction, reg)
		variable addr1, addr2, addr3 : std_logic_vector (4 downto 0);
		variable index_rs, index_rt, index_rd : integer;
		
		begin
		addr1 := instruction(25 downto 21);
		addr2 := instruction(20 downto 16);
		addr3 := instruction(15 downto 11);
		
		if regdst = '0' then
				addr3 := addr2;
		end if;
		
		index_rs := to_integer(unsigned(addr1));
		register_rs <= reg(index_rs);
		
		index_rt := to_integer(unsigned(addr2));
		register_rt <= reg(index_rt);
		
		index_rd := to_integer(unsigned(addr3));
		register_rd <= reg(index_rd);
			
		if instruction(15) = '1' then
			immediate <= x"ffff" & instruction(15 downto 0);
		else
			immediate <= x"0000" & instruction(15 downto 0);
		end if;
		
		jump_addr <= "000000" & instruction(25 downto 0);
	end process;
end Behavioral;

