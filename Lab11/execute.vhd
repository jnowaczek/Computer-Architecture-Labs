----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:40 04/02/2018 
-- Design Name: 
-- Module Name:    execute - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity execute is
	port(	ALUOp : in std_logic_vector (1 downto 0);
			beq_control : in std_logic;
			PC_in, register_rs, register_rt, immediate : in std_logic_vector (31 downto 0);
			alu_result, branch_addr : out std_logic_vector (31 downto 0);
			branch_decision : out std_logic);
end execute;

architecture Behavioral of execute is
begin
	execute : process(ALUOp, immediate, PC_in, register_rs, register_rt, beq_control)
		variable alu_output : signed (31 downto 0);
		variable zero : std_logic := '0';
		variable branch_offset : std_logic_vector := immediate;
		
		begin
			case ALUOp is
				when "00" =>
					alu_output := signed(register_rs) + signed(immediate);
				when "01" =>
					alu_output := signed(register_rs) - signed(register_rt);
					
					if (alu_output = x"00000000") then
						zero := '1';
					else
						zero := '0';
					end if;
				when "10" =>
					case immediate(5 downto 0) is
						when "100000" => -- Addition
							alu_output := signed(register_rs) + signed(register_rt);
						when "100010" => -- Subtraction
							alu_output := signed(register_rs) - signed(register_rt);
						when "100100" => -- AND
							alu_output := signed(register_rs and register_rt);
						when "100101" => -- OR
							alu_output := signed(register_rs or register_rt);
						when "100111" => -- NOR
							alu_output := signed(register_rs nor register_rt);
						when "101010" => -- SLT
							if register_rs < register_rt then
								alu_output := x"00000001";
							else
								alu_output := x"00000000";
							end if;
						when others => -- Error
							alu_output := x"ffffffff";
					end case;
				when others =>
					alu_output := x"ffffffff";
					zero := '0';
			end case;

			branch_addr <= std_logic_vector(signed(PC_in) + signed(branch_offset));
			branch_decision <= (beq_control and zero);
			alu_result <= std_logic_vector(alu_output);
	end process;
end Behavioral;