----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.07.2025 12:35:54
-- Design Name: RS232 Transmitter
-- Module Name: RS232 - Behavioral
-- Description: UART TX - 1 Start Bit, 8 Data Bits, 1 Stop Bit
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS232 is
    Port (
        clk          : in STD_LOGIC;
        rst          : in STD_LOGIC;
        trig         : in STD_LOGIC;
        data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
        tx           : out STD_LOGIC;
        tx_done      : out STD_LOGIC
    );
end RS232;

architecture Behavioral of RS232 is

    type state_type is (idle, start_tx, st0, st1, st2, st3, st4, st5, st6, st7, stop);
    signal present_state, next_state : state_type := idle;

    signal data_reg : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- State register
    pl: process(clk, rst)
    begin
        if rst = '1' then
            present_state <= idle;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    -- Next state logic and output logic
    p2: process(present_state, trig)
    begin
        -- Default values
        tx       <= '1';  -- idle state for TX line
        tx_done  <= '0';
        next_state <= present_state;

        case present_state is

            when idle =>
                tx <= '1';
                tx_done <= '0';
                if trig = '1' then
                    next_state <= start_tx;
                    data_reg <= data_to_send;
                else
                    next_state <= idle;
                end if;

            when start_tx =>
                tx <= '0';  -- Start bit
                next_state <= st0;

            when st0 =>
                tx <= data_reg(0);
                next_state <= st1;

            when st1 =>
                tx <= data_reg(1);
                next_state <= st2;

            when st2 =>
                tx <= data_reg(2);
                next_state <= st3;

            when st3 =>
                tx <= data_reg(3);
                next_state <= st4;

            when st4 =>
                tx <= data_reg(4);
                next_state <= st5;

            when st5 =>
                tx <= data_reg(5);
                next_state <= st6;

            when st6 =>
                tx <= data_reg(6);
                next_state <= st7;

            when st7 =>
                tx <= data_reg(7);
                next_state <= stop;

            when stop =>
                tx <= '1';  -- Stop bit
                tx_done <= '1';
                next_state <= idle;

            when others =>
                tx <= '1';
                next_state <= idle;

        end case;
    end process;

end Behavioral;
