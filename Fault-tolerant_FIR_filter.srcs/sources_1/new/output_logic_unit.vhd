library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity output_logic_unit is
    Generic( num_of_samples : natural := 4096);
    Port ( valid : in STD_LOGIC;
           clk : in std_logic;
           wea: out std_logic;
           ena : out std_logic;
           enb : out std_logic;
           addra : out std_logic_vector(log2c(num_of_samples)-1 downto 0);
           READY: out std_logic);
end output_logic_unit;

architecture Behavioral of output_logic_unit is
signal cnt: std_logic_vector(log2c(num_of_samples)-1 downto 0) := (others => '0');

begin

process(clk) is
begin
    if(rising_edge(clk)) then
        if (valid = '1') then
            if unsigned(cnt) /= to_unsigned(num_of_samples-1, log2c(num_of_samples)) then
                wea <= '1';
                ena <= '1';
                enb <= '0';
                cnt <= std_logic_vector(unsigned(cnt) + to_unsigned(1, log2c(num_of_samples)));
            else
                wea <= '0';
                ena <= '0';
                enb <= '1';
            end if;
        else
            wea <= '0';
            ena <= '0';
            enb <= '1';
            cnt <= (others => '0');
        end if;
    end if;
end process;

process(valid) is
begin
        if(falling_edge (valid)) then
           READY <= '1';
        else
           READY <= '0';
        end if;
end process;

addra <= cnt;


end Behavioral;
