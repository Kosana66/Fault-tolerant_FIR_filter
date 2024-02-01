library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity tb_mux is
    Generic ( input_data_width : natural := 64 );
    --  Port ( );
end tb_mux;

architecture Behavioral of tb_mux is

signal data_in : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal data_out : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal sel : STD_LOGIC;

begin

dut: entity work.mux
        generic map (   input_data_width => input_data_width)
        port map (      data_in => data_in,
                        sel => sel,
                        data_out => data_out);
                        
stim: process begin
    data_in <= "1111111111111101010101010101111110100001111001111111111000001111";
    sel <= '1';
    wait for 20ns;
    data_in <= "1111111111111111111111111111111111111111111111111111111111111111";
    sel <= '1';
    wait for 20ns;
    data_in <= "0000000000000000000000000000000000000000000000000000000000000000";
    sel <= '1';
    wait for 20ns;
    data_in <= "0100101010101001010110101010101010110101001001010100101010100101";
    sel <= '1';
    wait for 20ns;
    data_in <= "0101000111111000000111111110000000011000000000000000001111111111";
    sel <= '0';
    wait for 20ns;
    data_in <= "0101001111000001111111110000000000000000000000111110111001111111";
    sel <= '0';
    wait for 20ns;
    
end process;

end Behavioral;