----------------------------------------------------------------------------------
-- Engineer: Julian Nowaczek
-- 
-- Create Date:    14:11:29 03/14/2018 
-- Module Name:    sseg_display - Behavioral 
-- Project Name: lab7
-- Description: display 4 hex digits on ssd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sseg.ALL;

entity sseg_display is
	port(	anode : out std_logic_vector (3 downto 0);
			cathode : out std_logic_vector (7 downto 0);
			display : in std_logic_vector (15 downto 0);
			mclk : in std_logic);
end sseg_display;

architecture Behavioral of sseg_display is
	signal clk, clk_next : unsigned (19 downto 0) := (others => '0');
	signal digit_select : std_logic_vector (1 downto 0);
begin
	process (mclk)
	begin
		if rising_edge(mclk) then
			clk <= clk_next;
		end if;
	end process;
	
	clk_next <= clk + 1;
	digit_select <= std_logic_vector(clk(19 downto 18));
	
	process (digit_select, display)
	begin
		case digit_select is
			when "00" =>
				anode <= "0111";
				sseg_decode(hex => display(15 downto 12), sseg_out => cathode);
			when "01" =>
				anode <= "1011";
				sseg_decode(hex => display(11 downto 8), sseg_out => cathode);
			when "10" =>
				anode <= "1101";
				sseg_decode(hex => display(7 downto 4), sseg_out => cathode);
			when others =>
				anode <= "1110";
				sseg_decode(hex => display(3 downto 0), sseg_out => cathode);
		end case;
	end process;
	
end Behavioral;

