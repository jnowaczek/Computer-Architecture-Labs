----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:33:19 04/12/2018 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

entity control is
    port(
        instruction : in std_logic_vector (31 downto 0);
        jump_decision, beq_control : out std_logic;
        MemRead, MemWrite, MemToReg : out std_logic;
        RegDst, RegWrite, ALUSrc : out std_logic;
		  ALUOp : out std_logic_vector (1 downto 0));
end control;

architecture Behavioral of control is

begin
    process
        variable opcode : std_logic_vector(5 downto 0) := instruction(31 downto 26);
	begin
		case opcode is
			when "000000" => -- R Format
				RegDst 			<= '1';
				ALUSrc 			<= '0';
				MemToReg 		<= '0';
				RegWrite 		<= '1';
				MemRead 			<= '0';
				MemWrite 		<= '0';
				ALUOp 			<= "10";
				jump_decision 	<= '0';
				beq_control 	<= '0';
			when "100011" => -- LW
				RegDst 			<= '0';
				ALUSrc 			<= '1';
				MemToReg 		<= '1';
				RegWrite 		<= '1';
				MemRead 			<= '1';
				MemWrite 		<= '0';
				ALUOp 			<= "00";
				jump_decision 	<= '0';
				beq_control 	<= '0';
			when "101011" => -- SW
				RegDst 			<= '0';
				ALUSrc 			<= '1';
				MemToReg 		<= '0';
				RegWrite			<= '0';
				MemRead 			<= '0';
				MemWrite 		<= '1';
				ALUOp 			<= "00";
				jump_decision 	<= '0';
				beq_control 	<= '0';
			when "000100" => -- BEQ
				RegDst 			<= '0';
				ALUSrc 			<= '0';
				MemToReg 		<= '0';
				RegWrite			<= '0';
				MemRead 			<= '0';
				MemWrite 		<= '1';
				ALUOp 			<= "01";
				jump_decision 	<= '0';
				beq_control 	<= '1';
			when "001000" => -- ADDI
				RegDst 			<= '0';
				ALUSrc 			<= '1';
				MemToReg 		<= '0';
				RegWrite			<= '1';
				MemRead 			<= '0';
				MemWrite 		<= '0';
				ALUOp 			<= "00";
				jump_decision 	<= '0';
				beq_control 	<= '0';
			when "000010" => -- JMP
				RegDst 			<= '0';
				ALUSrc 			<= '0';
				MemToReg 		<= '0';
				RegWrite			<= '0';
				MemRead 			<= '0';
				MemWrite 		<= '0';
				ALUOp 			<= "00";
				jump_decision 	<= '1';
				beq_control 	<= '0';
			when others => -- halt and catch fire
				RegDst 			<= '0';
				ALUSrc 			<= '0';
				MemToReg 		<= '0';
				RegWrite			<= '0';
				MemRead 			<= '0';
				MemWrite 		<= '0';
				ALUOp 			<= "00";
				jump_decision 	<= '0';
				beq_control 	<= '0';
			end case;
	end process;
end Behavioral;

