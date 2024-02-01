
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_tb is
    Generic ( input_data_width : natural := 64);
    --  Port ( );
end comparator_tb;

architecture Behavioral of comparator_tb is
    signal in_0 : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
    signal in_1 : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
    signal error_signal : STD_LOGIC;
begin

dut: entity work.comparator 
    generic map ( input_data_width => input_data_width)
    port map ( in_0 => in_0,
               in_1 => in_1,
               error_signal => error_signal);
                  
stim: process begin
    -- identicne vrednosti
    in_0 <= "1111111100100011010001010110011111111001101010111100110111101111";
    in_1 <= "1111111100100011010001010110011111111001101010111100110111101111";
    wait for 20ns;
    -- razlicite vrednosti
    in_0 <= "1111111100100011010001010111111111111001101010111100110111101111";
    in_1 <= "0000000100100011010001010110011111111001101010111100110111101111";
    wait for 20ns;
    -- identicne vrednosti
    in_0 <= "1111111100100000010001010110011111111001101010100100110111101100";
    in_1 <= "1111111100100000010001010110011111111001101010100100110111101100";
    wait for 20ns;
    -- razlicite vrednosti
    in_0 <= "1111111100100011010001010111111111111001101010111100110101101100";
    in_1 <= "1111111100100011010001010110011111111001101010111100110111101110";
    wait for 20ns;
    wait;
end process;                 

end Behavioral;
