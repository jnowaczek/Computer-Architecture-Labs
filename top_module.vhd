----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:03 03/21/2018 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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

entity top_module is
	port(	btn, mclk, reset, branch_decision, jump_decision : in std_logic;
			an : out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (7 downto 0);
			RsTx, led0, led1, led7 : out std_logic);
end top_module;

architecture Behavioral of top_module is
	signal clean_btn : std_logic;
	signal pc_out : std_logic_vector (31 downto 0);
	signal instruction : std_logic_vector (31 downto 0);
begin
	fetch : entity work.fetch(Behavioral)
		port map(clock => clean_btn, reset => reset, branch_addr => x"7", 
			jump_addr => x"d", branch_decision => branch_decision,
			jump_decision => jump_decision, pc_out => pc_out,
			instruction => instruction);

	uart_print : entity work.uart_print(Behavioral)
		port map(clk => mclk, btn => clean_btn, data => instruction, name => x"00000000",
			tx => RsTx);

	btn_debounce: entity work.debounce2(fsmd)
		port map(clk => mclk, sw => btn, db_level => open, db_tick => clean_btn);

	sseg_out : entity work.sseg_display(Behavioral)
		port map(cathode => seg, anode => an, mclk => mclk, display => pc_out(15 downto 0));
	
	led0 <= branch_decision;
	led1 <= jump_decision;
	led7 <= reset;

end Behavioral;

