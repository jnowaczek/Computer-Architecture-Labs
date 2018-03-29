----------------------------------------------------------------------------------
-- Engineer: Julian Nowaczek and Sam Larson
-- 
-- Create Date:    14:11:33 03/27/2018 
-- Module Name:    decode_test - Behavioral 
-- Description: test decode and fetch modules
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode_test is
	port(	btn0, btn1, mclk, branch_decision, jump_decision : in std_logic;
			an : out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (7 downto 0);
			RsTx : out std_logic;
			leds : out std_logic_vector (4 downto 0);
			switches : in std_logic_vector (4 downto 0));
end decode_test;

architecture Behavioral of decode_test is
	signal register_rs, register_rd, register_rt : std_logic_vector (31 downto 0);
	signal immediate, instruction, jump_addr, pc_out : std_logic_vector (31 downto 0);
	signal clock_debounced : std_logic;
	signal select_debounced : std_logic;
	signal uart_data, uart_name : std_logic_vector (31 downto 0);
	
begin
	decode : entity work.decode(Behavioral)
		port map (instruction => instruction, memory_data => x"deadbeef", 
			alu_result => x"33335555", register_rs => register_rs,
			register_rt => register_rt, register_rd => register_rd,
			jump_addr => jump_addr, immediate => immediate,
			regdst => '1', regwrite => switches(3), memtoreg => '0',
			reset => switches(4), clock => clock_debounced);
		
	fetch : entity work.fetch(Behavioral)
		port map(clock => clock_debounced, reset => switches(4),
			branch_addr => x"00000000", jump_addr => x"00000000",
			branch_decision => '0', jump_decision => '0', pc_out => pc_out,
			instruction => instruction);
			
	uart_print : entity work.uart_print(Behavioral)
		port map(clk => mclk, btn => select_debounced, data => uart_data,
		name => uart_name, tx => RsTx);

	btn_debounce_uart: entity work.debounce2(fsmd)
		port map(clk => mclk, sw => btn1, db_level => open, db_tick => select_debounced);
		
	btn_debounce_clock: entity work.debounce2(fsmd)
		port map(clk => mclk, sw => btn0, db_level => clock_debounced, db_tick => open);

	sseg_out : entity work.sseg_display(Behavioral)
		port map(cathode => seg, anode => an, mclk => mclk, display => pc_out(15 downto 0));
	
	uart_data <= 	register_rs when switches(2 downto 0) = "000" else
						register_rt when switches(2 downto 0) = "001" else
						register_rd when switches(2 downto 0) = "010" else
						jump_addr when switches(2 downto 0) = "011" else
						immediate;
	
	uart_name <=	x"7273203d" when switches(2 downto 0) = "000" else
						x"7274203d" when switches(2 downto 0) = "001" else
						x"7264203d" when switches(2 downto 0) = "010" else
						x"6a61643d" when switches(2 downto 0) = "011" else
						x"696d6d3d";
	
	leds <= switches;
end Behavioral;

