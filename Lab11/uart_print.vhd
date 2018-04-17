----------------------------------------------------------------------------------
-- Engineer: Julian Nowaczek
-- 
-- Create Date:    16:12:43 02/21/2018 
-- Module Name:    uart_print - Behavioral 
-- Project Name: Lab6
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_print is
	port(	clk, btn : in std_logic;
			tx : out std_logic;
			data, name : std_logic_vector (31 downto 0));
end uart_print;

architecture Behavioral of uart_print is
	signal uartReady, tx_enable : std_logic;
	signal send_data: std_logic_vector (7 downto 0);
	 
	type state_type is (idle, n0, n1, n2, n3, d0, d1, d2, d3, d4, d5, d6, d7, d8, newline0, newline1);
   signal state_reg, state_next : state_type;
	
	signal hex_digit : std_logic_vector (3 downto 0);
	signal ascii_digit : std_logic_vector (7 downto 0);
begin
Imp_UART_tx_chr: entity work.UART_tx_chr(Beh)
	port map(SEND => tx_enable, DATA => send_data, 
				CLK => clk, READY => uartReady, UART_TX => tx);

Hex_to_ascii: entity work.hex_to_ascii(Behavioral)
	port map(hex => hex_digit, ascii => ascii_digit);

	process(clk)
	begin
		if rising_edge(clk) then
			if btn = '1' then
				state_reg <= n0;
			else
				state_reg <= state_next;
			end if;
		end if;
	end process;
	
	process(state_reg, uartReady, name, data, hex_digit, ascii_digit)
	begin
		case state_reg is
			when idle =>
				state_next <= idle;
				tx_enable <= '0';
			when n0 =>
				if uartReady = '1' then
					send_data <= name(31 downto 24);
					state_next <= n1;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= n0;
				end if;
			when n1 =>
				if uartReady = '1' then
					send_data <= name(23 downto 16);
					state_next <= n2;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= n1;
				end if;
			when n2 =>
				if uartReady = '1' then
					send_data <= name(15 downto 8);
					state_next <= n3;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= n2;
				end if;
			when n3 =>
				if uartReady = '1' then
					send_data <= name(7 downto 0);
					state_next <= d0;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= n3;
				end if;
			when d0 =>
				if uartReady = '1' then
					hex_digit <= data(31 downto 28);
					send_data <= ascii_digit;
					state_next <= d1;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d0;
				end if;
			when d1 =>
				if uartReady = '1' then
					hex_digit <= data(27 downto 24);
					send_data <= ascii_digit;
					state_next <= d2;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d1;
				end if;
			when d2 =>
				if uartReady = '1' then
					hex_digit <= data(23 downto 20);
					send_data <= ascii_digit;
					state_next <= d3;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d2;
				end if;
			when d3 =>
				if uartReady = '1' then
					hex_digit <= data(19 downto 16);
					send_data <= ascii_digit;
					state_next <= d4;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d3;
				end if;
			when d4 =>
				if uartReady = '1' then
					hex_digit <= data(15 downto 12);
					send_data <= ascii_digit;
					state_next <= d5;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d4;
				end if;
			when d5 =>
				if uartReady = '1' then
					hex_digit <= data(11 downto 8);
					send_data <= ascii_digit;
					state_next <= d6;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d5;
				end if;
			when d6 =>
				if uartReady = '1' then
					hex_digit <= data(7 downto 4);
					send_data <= ascii_digit;
					state_next <= d7;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d6;
				end if;
			when d7 =>
				if uartReady = '1' then
					hex_digit <= data(3 downto 0);
					send_data <= ascii_digit;
					state_next <= newline0;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= d7;
				end if;
			when newline0 =>
				if uartReady = '1' then
					send_data <= x"0a";
					state_next <= newline1;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= newline0;
				end if;
			when newline1 =>
				if uartReady = '1' then
					send_data <= x"0d";
					state_next <= idle;
					tx_enable <= '1';
				else
					tx_enable <= '0';
					state_next <= newline1;
				end if;
			when others =>
				tx_enable <= '0';
		end case;
	end process;
end Behavioral;

