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
use IEEE.NUMERIC_STD.ALL;

entity lab10_demo is
	port (	btn0, btn1, mclk : in std_logic;
				an : out std_logic_vector (3 downto 0);
				seg : out std_logic_vector (7 downto 0);
				RsTx : out std_logic;
				leds : out std_logic_vector (3 downto 0);
				switches : in std_logic_vector (3 downto 0);
				mem_select : in std_logic_vector (1 downto 0));
end lab10_demo;

architecture Behavioral of lab10_demo is
	signal sig_reg_rs, sig_reg_rt, sig_reg_rd : std_logic_vector (31 downto 0);
	signal sig_jump_decision, sig_branch_decision : std_logic;
	signal sig_clock, sig_reset : std_logic;
	signal sig_program_counter : std_logic_vector (31 downto 0);
	signal sig_instruction, sig_immediate : std_logic_vector (31 downto 0);
	signal sig_beq_control, sig_mem_read, sig_mem_write : std_logic;
	signal sig_reg_dest, sig_reg_write, sig_mem_to_reg : std_logic;
	signal sig_alu_op : std_logic_vector (1 downto 0);
	signal sig_branch_addr, sig_jump_addr : std_logic_vector (31 downto 0);
	signal sig_alu_result : std_logic_vector (31 downto 0);
	signal sig_write_data, sig_read_data : std_logic_vector (31 downto 0);
	
	signal select_debounced : std_logic;
	signal uart_data, uart_name : std_logic_vector (31 downto 0);
begin
	fetch : entity work.fetch(Behavioral)
		port map (	branch_decision => sig_branch_decision, 
						branch_addr => sig_branch_addr,
						jump_decision => sig_jump_decision,
						PC_out => sig_program_counter,
						jump_addr => sig_jump_addr,
						clock => sig_clock,
						instruction => sig_instruction,
						reset => sig_reset,
						mem_select => mem_select);

	decode : entity work.decode(Behavioral)
		port map (	instruction => sig_instruction,
						memory_data => sig_read_data,
						alu_result => sig_alu_result,
						register_rs => sig_reg_rs,
						register_rt => sig_reg_rt,
						register_rd => sig_reg_rd,
						write_data => sig_write_data,
						jump_addr => sig_jump_addr,
						immediate => sig_immediate,
						regdst => sig_reg_dest,
						regwrite => sig_reg_write,
						memtoreg => sig_mem_to_reg,
						reset => sig_reset,
						clock => sig_clock,
						writeClock => sig_clock);
						
	execute : entity work.execute(Behavioral)
		port map (	ALUOp => sig_alu_op,
						beq_control => sig_beq_control,
						PC_in => sig_program_counter,
						register_rs => sig_reg_rs,
						register_rt => sig_reg_rt,
						immediate => sig_immediate,
						alu_result => sig_alu_result,
						branch_addr => sig_branch_addr,
						branch_decision => sig_branch_decision);
						
	control : entity work.control(Behavioral)
		port map (	instruction => sig_instruction,
						jump_decision => sig_jump_decision,
						beq_control => sig_beq_control,
						MemRead => sig_mem_read,
						MemWrite => sig_mem_write,
						MemToReg => sig_mem_to_reg,
						RegDst => sig_reg_dest,
						RegWrite => sig_reg_write,
						ALUSrc => open,
						ALUOp => sig_alu_op);
						
	data_mem : entity work.data(Behavioral)
		port map (	address => sig_alu_result,
						write_data => sig_write_data,
						mem_write => sig_mem_write,
						mem_read => sig_mem_read,
						read_data => sig_read_data,
						wclock => sig_clock);
	
	uart_print : entity work.uart_print(Behavioral)
		port map (	clk => mclk,
						btn => select_debounced,
						data => uart_data,
						name => uart_name,
						tx => RsTx);

	btn_debounce_uart: entity work.debounce2(fsmd)
		port map (	clk => mclk,
						sw => btn1,
						db_level => open, 
						db_tick => select_debounced);
		
	btn_debounce_clock: entity work.debounce2(fsmd)
		port map (	clk => mclk, 
						sw => btn0, 
						db_level => sig_clock, 
						db_tick => open);

	sseg_out : entity work.sseg_display(Behavioral)
		port map (	cathode => seg, 
						anode => an, 
						mclk => mclk, 
						display => sig_program_counter (15 downto 0));
	
	uart_data <= 	sig_reg_rs 			when switches(2 downto 0) = "000" else
						sig_reg_rt 			when switches(2 downto 0) = "001" else
						sig_reg_rd 			when switches(2 downto 0) = "010" else
						sig_immediate 		when switches(2 downto 0) = "011" else
						sig_alu_result		when switches(2 downto 0) = "100" else
						sig_read_data		when switches(2 downto 0) = "101" else
						sig_write_data;
	
	uart_name <=	x"7273203d" 		when switches(2 downto 0) = "000" else
						x"7274203d" 		when switches(2 downto 0) = "001" else
						x"7264203d" 		when switches(2 downto 0) = "010" else
						x"696d6d3d" 		when switches(2 downto 0) = "011" else
						x"616c753d"			when switches(2 downto 0) = "100" else
						x"7264643d"			when switches(2 downto 0) = "101" else
						x"7772643d";
	
	sig_reset <= switches(3);
	leds <= switches;
end Behavioral;

