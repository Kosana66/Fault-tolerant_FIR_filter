
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.util_pkg.all;

entity ThresholdVoter_tb is
    Generic (input_data_width : natural := 3;
             n_param : natural :=  5);
--  Port ( );
end ThresholdVoter_tb;

architecture Behavioral of ThresholdVoter_tb is

signal inputs : std_logic_vector(n_param*input_data_width-1 downto 0);
signal output :  std_logic_vector (input_data_width-1 downto 0);
signal module_is_fault: std_logic_vector(n_param-1 downto 0);
begin

dut: entity work.ThresholdVoter
    generic map (input_data_width => input_data_width,
                n_param => n_param)
    port map (inputs => inputs,
              output => output,
              module_is_fault => module_is_fault);
    
stim: process
    begin
    
    module_is_fault <= (others => '0');
    
    -- 101
    -- 010
    -- 101
    -- 010
    -- 101
    module_is_fault(4) <= '1';
    for i in inputs'range loop
        if i mod 2 = 1 then
            inputs(i) <= '1';
        else
            inputs(i) <= '0';
        end if;
    end loop;
    wait for 20ns;
    module_is_fault(4) <= '0';
    
    -- 010
    -- 101
    -- 010
    -- 101
    -- 010
    for i in inputs'range loop
        if i mod 2 = 1 then
            inputs(i) <= '0';
        else
            inputs(i) <= '1';
        end if;
    end loop;
    wait for 20ns;
    

    --111
    --111
    --111
    --000
    --000
    module_is_fault(2) <= '1';
    for i in n_param*input_data_width-1 downto 6 loop
            inputs(i) <= '1';
    end loop;
    inputs(5 downto 3) <= "000";
    inputs(2 downto 0) <= "000";
    wait for 20ns;
    
    --111
    --111
    --111
    --111
    --000
    
    module_is_fault(3) <= '1';
    module_is_fault(1) <= '1';
    for i in n_param*input_data_width-1 downto 3 loop
            inputs(i) <= '1';
    end loop;
    inputs(2 downto 0) <= "000";
    wait for 20ns;
    
    --111
    --111
    --111
    --111
    --111
    
    module_is_fault <= (others => '1');
    inputs <= (others => '1');
    wait for 20ns;
    
    -- 000
    -- 000
    -- 000
    -- 000
    -- 000
    module_is_fault <= (others => '0');
    inputs <= (others => '0');
    wait for 20ns;
    
    wait;
end process;
        
end Behavioral;
