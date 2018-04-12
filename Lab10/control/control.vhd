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
        RegDst, RegWrite, ALUOp, ALUSrc : out std_logic;
        );
end control;

architecture Behavioral of control is

begin
    process
        variable opcode : std_logic_vector(5 downto 0);
begin
    opcode(5 downto 0) := instruction(31 downto 26);

    case Regdst is
        when opcode => "100000";
    case ALUSrc is
        when opcode => "011010";
    case MemToReg is
        when opcode => "010000";
    case RegWrite is
        when opcode => "110010";
    case MemRead is
        when opcode => "010000";
    case MemWrite is
        when opcode => "001000";
    case ALUOp is
        when opcode => "??????";
    case jump_decision is
        when opcode => "000001";
end process;
end Behavioral;

