library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity ThresholdVoter is
    Generic (input_data_width : natural := 24;
             n_param : natural :=  5);
    Port ( inputs : in std_logic_vector(n_param*input_data_width-1 downto 0);
           output : out std_logic_vector(input_data_width-1 downto 0));
end ThresholdVoter;

architecture Behavioral of ThresholdVoter is

signal count : std_logic_vector(log2c(n_param)-1 downto 0);

begin

    process
   -- variable count : integer := 0;
    begin
    for i in 0 to input_data_width-1 loop
        count <= (others => '0');
        for j in 0 to n_param-1 loop
          if(inputs(j*input_data_width+i) = '1') then
            count <= count + '1'; 
          end if;
        end loop;
        if(unsigned(count) <= n_param/2) then
                output(i) <= '0';
        else
                output(i) <= '1';
        end if;
    end loop;
    end process;






              -- threshold <= std_logic_vector(to_unsigned(n_param/2, threshold'length));

        
--        -- ne povecava threshold se ako se modul popravi
--        for i in inputs'range loop
--            if inputs(i) = '0' then
--                if threshold > 1 then
--                    threshold := threshold - 1;
--                else
--                    threshold := threshold;
--                end if;
--            end if;
--        end loop;
--    end process;

end Behavioral;
