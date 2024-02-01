
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ThresholdVoter_tb is
    Generic (input_data_width : natural := 24;
             n_param : natural :=  5);
--  Port ( );
end ThresholdVoter_tb;

architecture Behavioral of ThresholdVoter_tb is

signal inputs : std_logic_vector(n_param*input_data_width-1 downto 0);
signal output :  std_logic_vector (input_data_width-1 downto 0);
           
begin

dut: entity work.ThresholdVoter
    generic map (n_param => n_param)
    port map (inputs => inputs,
              output => output);
    
stim: process
    begin
    
----    -- 10101
--    for i in inputs'range loop
--        if i mod 2 = 1 then
--            inputs(i) <= '1';
--        else
--            inputs(i) <= '0';
--        end if;
--    end loop;
--    wait for 20ns;
    
----    -- 01010
--    for i in inputs'range loop
--        if i mod 2 = 1 then
--            inputs(i) <= '0';
--        else
--            inputs(i) <= '1';
--        end if;
--    end loop;
--    wait for 20ns;
    
    -- 00000
    inputs <= (others => '0');
    wait for 20ns;
    
    -- 11111
    inputs <= (others => '1');
    wait for 20ns;
    
    
--    -- 00001
--    for i in 0 to n_param-1 loop
--            inputs(i) <= '0';
--    end loop;
--    inputs(n_param-1) <= '1';
--    wait for 20ns;
    
--    -- 11110
--    for i in 0 to n_param-1 loop
--            inputs(i) <= '1';
--    end loop;
--    inputs(n_param-1) <= '0';
--    wait for 20ns;
    
    wait;
end process;
        
end Behavioral;
