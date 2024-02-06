library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;

entity FIR_filter is
    generic(fir_ord : natural := 5;
            input_data_width : natural := 18;
            output_data_width : natural := 18);
    Port ( clk : in STD_LOGIC;
           rst : in std_logic;
           we_i : in STD_LOGIC;
           coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
           coef_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           data_i : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           data_o : out STD_LOGIC_VECTOR (output_data_width-1 downto 0));
           
    attribute dont_touch : string;
    attribute dont_touch of FIR_filter : entity is "yes";
end FIR_filter;

architecture Behavioral of FIR_filter is
    type std_2d is array (fir_ord downto 0) of std_logic_vector(2*input_data_width-1 downto 0);
    signal mac_inter : std_2d:=(others=>(others=>'0'));
    type coef_t is array (fir_ord downto 0) of std_logic_vector(input_data_width-1 downto 0);
    signal b_s : coef_t := (others=>(others=>'0')); 
                                                           
begin

    process(clk)
    begin
        if(rising_edge(clk))then
            if we_i = '1' then
                b_s(to_integer(unsigned(coef_addr_i))) <= coef_i;
            end if;
        end if;
    end process;
    
    first_section:
    entity work.MAC_module
    generic map(input_data_width=>input_data_width)
    port map(clk=>clk,
             rst => rst, 
             u_i=>data_i,
             b_i=>b_s(fir_ord),
             sec_i=>(others=>'0'),
             sec_o=>mac_inter(0));
                     
    other_sections:
    for i in 1 to fir_ord generate
        fir_section:
        entity work.MAC_module
        generic map(input_data_width=>input_data_width)
        port map(clk=>clk,
                 rst => rst, 
                 u_i=>data_i,
                 b_i=>b_s(fir_ord-i),
                 sec_i=>mac_inter(i-1),
                 sec_o=>mac_inter(i));
    end generate;
    
    process(clk)
    begin
        if(rising_edge(clk))then
            data_o <= mac_inter(fir_ord)(2*input_data_width-2 downto 2*input_data_width-output_data_width-1);
        end if;
    end process;
    
    
    
    
end Behavioral;
