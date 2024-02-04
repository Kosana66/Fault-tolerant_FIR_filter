library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sr_ff_tb is
end entity;

architecture Behavioural of sr_ff_tb is

signal S, R, Q, clk : STD_LOGIC;

begin
uut: entity work.sr_ff 
    port map(
    S => S,
    R => R,
    Q => Q,
    clk => clk
   );

clock : process
begin
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
end process;

stim : process
begin
    S <= '0' ; R<='0';
    wait for 20 ns;
    S <= '0' ; R<='1';
    wait for 20 ns;
    S <= '0' ; R<='0';
    wait for 20 ns;
    S <= '1' ; R<='0';
    wait for 20 ns;
    S <= '0' ; R<='0';
    wait for 20 ns;
    S <= '1' ; R<='1';
    wait for 20 ns;
    wait;
end process;
end Behavioural;


