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
	port(	ALUOp : in std_logic_vector (2 downto 0);
			beq_control : in std_logic;
			PC_in, register_rs, register_rt, immediate : in std_logic_vector (31 downto 0);
			alu_result, branch_addr : out std_logic_vector (31 downto 0);
			branch_decision : out std_logic);
end execute;

architecture Behavioral of execute is
begin
	execute : process(ALUOp, immediate, register_rs, register_rt)
		variable alu_output : signed (31 downto 0);
		variable zero : std_logic := '0';
		
		case ALUOp is
			when "00" =>
				alu_output := signed(register_rs) + signed(immediate);
			when "01" =>
				alu_output := signed(register_rs) - signed(register_rt);
			when "10" =>
				case immediate(5 downto 0) is
					when "100000" => -- Addition
						alu_output := signed(register_rs) + signed(register_rt);
					when "100010" => -- Subtraction
						alu_output := signed(register_rs) - signed(register_rt);
					when "" => -- AND
						alu_output := register_rs and register_rt;
					when "" => -- OR
						alu_output := regiser_rs or register_rt;
					when "" => -- NOR
						alu_output := register_rs nor register_rt;
					when "" => -- SLT
						alu_output := 
					when "" => -- NAND
						alu_output := register_rs nand register_rt;
					when others -- Error
						alu_output := x"ffffffff";
				end case;
			when others
				alu_output := x"ffffffff";
				zero := '0';
		end case;

		branch_offset := immediate;
		branch_addr := std_logic_vector(signed(PC_in)) + signed(branch_offset));
		branch_decision <= (beq_conrol and zero);
		alu_result <= std_logic_vector(alu_output);
	end process;
end Behavioral;