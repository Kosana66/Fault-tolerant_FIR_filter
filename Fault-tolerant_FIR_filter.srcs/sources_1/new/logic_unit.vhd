library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity logic_unit is
    Generic( num_of_samples : natural := 4096);
    Port ( START : in STD_LOGIC;
           clk : in std_logic;
           addrb : out std_logic_vector(log2c(num_of_samples)-1 downto 0);
           valid: out std_logic);
end logic_unit;

architecture Behavioral of logic_unit is
signal cnt: std_logic_vector(log2c(num_of_samples)-1 downto 0) := (others => '0');
signal tmp : std_logic;

begin

process(clk) is
begin
    if(rising_edge(clk)) then
        if (START = '1') then
            if unsigned(cnt) /= to_unsigned(num_of_samples-1, log2c(num_of_samples)) then
                tmp <= '1';
                cnt <= std_logic_vector(unsigned(cnt) + to_unsigned(1, log2c(num_of_samples)));
            else
                tmp <= '0';
            end if;
        else
            tmp <= '0';
        end if;
    end if;
end process;

valid <= tmp;
addrb <= cnt;

end Behavioral;
