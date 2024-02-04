
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity switch is
    Generic ( input_data_width : natural := 24);
    Port ( voter_output : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           module_output : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           init : in STD_LOGIC;
           switch_out : out STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           module_is_fault: out STD_LOGIC;
           clk: in STD_LOGIC
           );
           
    attribute dont_touch : string;
    attribute dont_touch of switch : entity is "yes";
end switch;

architecture Behavioral of switch is

signal comp_output, sr_output: std_logic;

begin

comp: entity work.comparator
    generic map ( input_data_width => input_data_width)
    port map ( in_0 => voter_output,
               in_1 => module_output,
               error_signal => comp_output);

sr_ff: entity work.sr_ff 
    port map( S => init,
              R => comp_output,
              Q => sr_output,
              clk => clk
             );
              
mux: entity work.mux
        generic map (input_data_width => input_data_width)
        port map ( data_in => module_output,
                   sel => sr_output,
                   data_out => switch_out);

process (sr_output) 
begin
    if(sr_output = '0') then
        module_is_fault <= '1';
    else
        module_is_fault <= '0';
    end if;
end process;

end Behavioral;
