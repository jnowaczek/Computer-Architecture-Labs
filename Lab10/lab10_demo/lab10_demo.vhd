----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:09:51 04/12/2018 
-- Design Name: 
-- Module Name:    lab10_demo - Behavioral 
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

entity lab10_demo is
end lab10_demo;

architecture Behavioral of lab10_demo is
	signal sig_reg_rs, sig_reg_rt, sig_reg_rd : std_logic_vector (31 downto 0);
	signal sig_jump_decision, sig_branch_decision : std_logic;
	signal clock, write_clock : std_logic;
	
	signal sig_instruction : std_logic_vector (31 downto 0);
	
begin
	fetch : work.fetch(Behavioral)
		port map (	branch_decision => sig_branch_decision, 
						branch_addr,
						jump_decision => sig_jump_decision,
						PC_out,
						jump_addr,
						clock,
						instruction,
						reset);

	decode : work.decode(Behavioral)
		port map (	instruction,
						memory_data,
						alu_result,
						register_rs => sig_reg_rs,
						register_rt => sig_reg_rt,
						register_rd => sig_reg_rd,
						write_data,
						jump_addr,
						immediate,
						regdst,
						regwrite,
						memtoreg,
						reset,
						clock,
						writeClock);
						
	execute : work.execute(Behavioral)
		port map (	ALUOp,
						beq_control,
						PC_in,
						register_rs => sig_reg_rs,
						register_rt => sig_reg_rt,
						register_rd => sig_reg_rd,
						immediate,
						alu_result,
						branch_addr,
						branch_decision => sig_branch_decision);
						
	control : work.control(Behavioral)
		port map (	instruction,
						jump_decision,
						beq_control,
						MemRead,
						MemWrite,
						MemToReg,
						RegDst,
						RegWrite,
						ALUSrc,
						ALUOp);
						
	data_mem : work.data(Behavioral)
		port map (	address,
						write_data,
						mem_write,
						mem_read,
						read_data,
						wclock);
						
end Behavioral;

