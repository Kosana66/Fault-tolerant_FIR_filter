
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity switch_tb is
    generic(input_data_width : natural := 5);
    --  Port ( );
end switch_tb;

architecture Behavioral of switch_tb is
 
signal voter_output, module_output, switch_out: STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal init, clk, module_is_fault: STD_LOGIC;

begin

dut: entity work.switch
    generic map(input_data_width => input_data_width)
    port map (voter_output => voter_output, 
              module_output => module_output,
              init => init,
              switch_out => switch_out,
              module_is_fault => module_is_fault,
              clk => clk
              );
clock: process
    begin
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    wait for 10ns;
end process;

stim: process
    begin
    
    init <= '1';
    voter_output <= "11111";
    module_output <= "11111";
    wait for 20ns;
    
    init <= '0';
    voter_output <= "00000";
    module_output <= "00000";
    wait for 20ns;
    
    voter_output <= "10101";
    module_output <= "10101";
    wait for 20ns;
    
    module_output <= "11111";
    wait for 20ns;

    voter_output <= "00000";
    module_output <= "00000";
    wait for 20ns;
    
    voter_output <= "10001";
    module_output <= "10101";
    wait for 20ns;
    
    init <= '1';
    voter_output <= "11111";
    module_output <= "11111";
    wait for 20ns;
   
    
    wait;
end process;




end Behavioral;
