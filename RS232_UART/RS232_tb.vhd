library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RS232_tb is
-- No ports in a testbench
end RS232_tb;

architecture Behavioral of RS232_tb is

    -- Component Declaration
    component RS232
        Port (
            clk          : in STD_LOGIC;
            rst          : in STD_LOGIC;
            trig         : in STD_LOGIC;
            data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
            tx           : out STD_LOGIC;
            tx_done      : out STD_LOGIC
        );
    end component;

    -- Signals to connect to Unit Under Test (UUT)
    signal clk          : STD_LOGIC := '0';
    signal rst          : STD_LOGIC := '1';
    signal trig         : STD_LOGIC := '0';
    signal data_to_send : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tx           : STD_LOGIC;
    signal tx_done      : STD_LOGIC;

    -- Clock period constant (assuming 100ns = 10 MHz)
    constant clk_period : time := 100 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: RS232
        Port map (
            clk => clk,
            rst => rst,
            trig => trig,
            data_to_send => data_to_send,
            tx => tx,
            tx_done => tx_done
        );

    -- Clock process
    clk_process :process
    begin
        while now < 10 ms loop  -- limit simulation
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset
        wait for 200 ns;
        rst <= '0';

        -- Wait for 1 cycle
        wait for clk_period;

        -- Apply input data
        data_to_send <= "10101010"; -- sample byte
        trig <= '1';
        wait for clk_period;
        trig <= '0';

        -- Wait long enough for transmission to finish
        wait for 2 ms;

        -- Send another byte
        data_to_send <= "11001100";
        trig <= '1';
        wait for clk_period;
        trig <= '0';

        -- Wait again for transmission
        wait for 2 ms;

        -- End simulation
        wait;
    end process;

end Behavioral;
