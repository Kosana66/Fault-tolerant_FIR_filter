library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.util_pkg.all;

entity logic_unit_tb is
    Generic(
        num_of_samples : natural := 4096);
--  Port ( );
end logic_unit_tb;

architecture Behavioral of logic_unit_tb is

signal START :  STD_LOGIC;
signal clk :  std_logic;
signal addrb :  std_logic_vector(log2c(num_of_samples)-1 downto 0);
signal valid:  std_logic;

begin

input_unit: entity work.logic_unit
        Generic map(num_of_samples => num_of_samples)
        Port map(clk => clk,
               START => START,
               addrb => addrb,
               valid => valid
        );
        
clk_process:
    process
    begin
        clk <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
    end process;
    
stim_process:
    process
    begin
        START <= '0';
        wait for 60ns;
        START <= '1';
        wait;
        
    end process;
    
end Behavioral;
