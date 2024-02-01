library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sr_ff is
    Port ( S : in    STD_LOGIC;
           R : in    STD_LOGIC;
           clk : in  STD_LOGIC;
           Q : out STD_LOGIC);
end sr_ff;

architecture Behavioral of sr_ff is
begin

process (clk) 
    variable tmp: std_logic;
    begin
    if(clk='1' and clk'event) then
        if(S='0' and R='0')then
        tmp:=tmp;
        elsif(S='1' and R='1')then
        tmp:='Z';
        elsif(S='0' and R='1')then
        tmp:='0';
        else
        tmp:='1';
        end if;
    end if;
    Q <= tmp;
end process;
end Behavioral;



