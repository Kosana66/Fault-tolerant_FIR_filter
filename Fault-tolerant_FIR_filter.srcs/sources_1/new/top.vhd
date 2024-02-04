library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.util_pkg.all;


entity top is
    Generic(fir_ord : natural := 5;
        input_data_width : natural := 24;
        output_data_width : natural := 24;
        n_param : natural := 5);
    Port ( clk : in STD_LOGIC;
           we_i : in STD_LOGIC;
           coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
           coef_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           data_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           init : in STD_LOGIC;
           top_output: out std_logic_vector(output_data_width-1 downto 0)
    );
    
    attribute dont_touch : string;
    attribute dont_touch of top : entity is "yes";
end top;

architecture Behavioral of top is

type type_redudant_output is array (n_param-1 downto 0) of std_logic_vector(output_data_width-1 downto 0);
signal module_output : type_redudant_output := (others => (others => '0'));
signal switch_out : std_logic_vector(n_param*output_data_width-1 downto 0);
signal module_is_fault : std_logic_vector(n_param-1 downto 0);
signal voter_output : std_logic_vector(output_data_width-1 downto 0);

begin

redudant_filters_instances: for i in n_param-1 downto 0 generate
redudant_filters: entity work.FIR_filter
    generic map(fir_ord => fir_ord,
                input_data_width  => input_data_width,
                output_data_width  =>  output_data_width)
    port map(clk_i => clk,
             we_i => we_i,
             coef_i => coef_i,
             coef_addr_i => coef_addr_i,
             data_i => data_i,
             data_o => module_output(i));
end generate redudant_filters_instances;
             
switches_instances: for i in n_param-1 downto 0 generate
switches: entity work.switch
    generic map(input_data_width => input_data_width)
    port map (voter_output => voter_output, 
              module_output => module_output(i),
              init => init,
              switch_out => switch_out(i*output_data_width+(output_data_width-1) downto i*output_data_width),
              module_is_fault => module_is_fault(i),
              clk => clk
              );
end generate switches_instances;       
              
voter: entity work.ThresholdVoter
    generic map (input_data_width => input_data_width,
                n_param => n_param)
    port map (inputs => switch_out,
              output => voter_output,
              module_is_fault => module_is_fault);           
              
top_output <= voter_output;

end Behavioral;
