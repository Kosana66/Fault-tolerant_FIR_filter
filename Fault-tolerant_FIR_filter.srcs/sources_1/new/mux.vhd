library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;


entity mux is
    Generic ( input_data_width : natural := 24);
    Port ( data_in : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           sel : in STD_LOGIC
           );
           
    attribute dont_touch : string;
    attribute dont_touch of mux : entity is "yes";
    
end mux;

architecture Behavioral of mux is
begin

process (sel, data_in)
begin
if(sel = '0') then 
    data_out <= (others => '0');
else 
    data_out <= data_in;
end if;
end process;

end Behavioral;