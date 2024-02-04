library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity ThresholdVoter is
    Generic (input_data_width : natural := 24;
             n_param : natural :=  8);
    Port ( 
           inputs : in std_logic_vector(n_param*input_data_width-1 downto 0);
           output : out std_logic_vector(input_data_width-1 downto 0);
           module_is_fault: in std_logic_vector(n_param-1 downto 0));
           
    attribute dont_touch : string;
    attribute dont_touch of ThresholdVoter : entity is "yes";   
end ThresholdVoter;

architecture Behavioral of ThresholdVoter is

-- Count the ones on the outputs of n modules for each bit individually
-- The count of ones is represented with (log2c(n_param)+1) bits because, for example, there are 5 possibilities (0,1,2,3,4) for n_param=4.
-- So the +1 exists to ensure that the representation of the number when all bits are set to one
signal count : std_logic_vector(input_data_width*(log2c(n_param)+1)-1 downto 0);
-- The threshold is represented with (log2c(n_param/2)+1) bits because the maximum value of the threshold can be n_param/2
-- If n_param is a exponent of 2, then with log2c(n_param), at most n_param-1 units will be represented
-- So the +1 exists to ensure that the representation of the number when all modules are soperational
signal threshold : std_logic_vector(log2c(n_param/2) downto 0);

begin    
    -- Iterating through all bits.
    outer: for i in 0 to input_data_width-1 generate   
    
        process(inputs, module_is_fault) is
        variable cnt_count : integer := 0;
        begin
            cnt_count := 0;
            -- Counting ones in each module for individual bit
            inner: for j in 0 to n_param-1 loop
                  if(inputs(j*input_data_width+i) = '1' and module_is_fault(j) = '0') then
                    cnt_count := cnt_count + 1;
                  end if;
            end loop inner;
            -- Assigning counted ones to the appropriate range of the count signal
            -- This range corresponds to the number of ones for the corresponding bit.
            count(i*(log2c(n_param)+1)+log2c(n_param) downto i*(log2c(n_param)+1)) <= std_logic_vector(to_unsigned(cnt_count, log2c(n_param)+1));
        end process;
        
        process(module_is_fault) is
        variable cnt_active_module : integer := 0;
        begin
            cnt_active_module := 0;
            -- Counting active modules
            active: for j in 0 to n_param-1 loop
                if(module_is_fault(j) = '0') then
                    cnt_active_module := cnt_active_module + 1;
                end if;
            end loop active;
            -- The threshold is always half of the active modules
            threshold <= std_logic_vector(to_unsigned(cnt_active_module/2, log2c(n_param/2)+1));
        end process;    
         
        process(count, threshold) is  
        begin  
        if(count(i*(log2c(n_param)+1)+log2c(n_param) downto i*(log2c(n_param)+1)) <= threshold) then
                output(i) <= '0';           
        else
                output(i) <= '1';
        end if;
        end process;
        
    end generate outer;
end Behavioral;

