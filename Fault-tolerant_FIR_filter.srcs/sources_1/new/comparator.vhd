library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity comparator is
    Generic ( input_data_width : natural := 24);
    Port ( in_0 : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           in_1 : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           error_signal : out STD_LOGIC );
           
    attribute dont_touch : string;
    attribute dont_touch of comparator : entity is "yes";
end comparator;


architecture Behavioral of comparator is

begin

process(in_0, in_1) begin
    if(in_0 = in_1) then
        error_signal <= '0';
    else
        error_signal <= '1';
    end if;
end process;

end Behavioral;