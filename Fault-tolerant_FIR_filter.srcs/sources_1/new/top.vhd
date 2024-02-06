library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.util_pkg.all;


entity top is
    Generic(fir_ord : natural := 20;
        input_data_width : natural := 24;
        output_data_width : natural := 24;
        n_param : natural := 5;
        num_of_samples : natural := 4096);
    Port ( clk : in STD_LOGIC;
           rst      : in std_logic;
           we_i : std_logic;
           coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
           coef_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           init : in STD_LOGIC;
           ena : in std_logic;
           enb : in std_logic;
           wea : in std_logic;
           addra : in std_logic_vector(log2c(num_of_samples)-1 downto 0);
           addrb : in std_logic_vector(log2c(num_of_samples)-1 downto 0);
           dia : in std_logic_vector(input_data_width-1 downto 0);
           dob: out std_logic_vector(output_data_width-1 downto 0);
           START : in std_logic;
           READY : out std_logic
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
signal top_output: std_logic_vector(output_data_width-1 downto 0);
signal data_i: std_logic_vector(input_data_width-1 downto 0) := (others => '0');
signal addrb_in : std_logic_vector(log2c(num_of_samples)-1 downto 0);
signal addra_out : std_logic_vector(log2c(num_of_samples)-1 downto 0);
signal reg_s : std_logic_vector(3 downto 0) := (others => '0');
signal valid : std_logic;
signal wea_out : std_logic;
signal ena_out : std_logic;
signal enb_out : std_logic;

begin 

BRAM_input: entity work.BRAM
    generic map ( input_data_width  => input_data_width,
                  num_of_samples  => num_of_samples)
    port map( clk => clk,
              ena  => ena,
              enb  => enb, 
              wea  => wea,
              addra  => addra,
              addrb  => addrb_in,
              dia  => dia,
              dob  => data_i );           
            
input_logic: entity work.logic_unit
    Generic map( num_of_samples  => num_of_samples)
    Port map( START => START,
           clk => clk,
           addrb => addrb_in,  
           valid => valid);

redudant_filters_instances: for i in n_param-1 downto 0 generate
redudant_filters: entity work.FIR_filter
    generic map(fir_ord => fir_ord,
                input_data_width  => input_data_width,
                output_data_width  =>  output_data_width)
    port map(clk => clk,
             rst => rst, 
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
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            if(rst = '1') then
                for i in 3 downto 0 loop  
                    reg_s(i) <= '0';
                end loop;
            else
                for i in 3 downto 1 loop  
                    reg_s(i) <= reg_s(i-1);
                end loop;
                reg_s(0) <= valid;
            end if;
        end if;
    end process;
    
output_logic: entity work.output_logic_unit
    Generic map( num_of_samples  => num_of_samples)
    Port map( valid => reg_s(3),
           clk => clk,
           wea => wea_out,
           ena => ena_out,
           enb => enb_out,
           addra => addra_out,
           READY => READY);
           
BRAM_output: entity work.BRAM
    generic map ( input_data_width  => output_data_width,
                  num_of_samples  => num_of_samples)
    port map( clk => clk,
              ena  => ena_out,
              enb  => enb_out, 
              wea  => wea_out,
              addra  => addra_out,
              addrb  => addrb,
              dia  => voter_output,
              dob  => top_output );     
    
    dob <= top_output ;      

end Behavioral;
