library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sr_ff is
    Port ( S : in    STD_LOGIC;
           R : in    STD_LOGIC;
           clk : in  STD_LOGIC;
           Q : out STD_LOGIC);
           
    attribute dont_touch : string;
    attribute dont_touch of sr_ff : entity is "yes";
end sr_ff;

architecture Behavioral of sr_ff is
begin

process (clk) 
    variable tmp: std_logic;
    begin
    if(rising_edge(clk)) then
        if(S='1' and R='0')then
        tmp := '1';
        elsif(S='0' and R='1')then
        tmp := '0';
        elsif(S='1' and R='1')then
        tmp := 'Z';
        else
        tmp := tmp;
        end if;
    end if;
    Q <= tmp;
end process;

end Behavioral;
