library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity MAC_module is
    generic( input_data_width  : natural := 24);
    Port ( clk     : in std_logic;
           rst      : in std_logic;
           u_i     : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           b_i     : in STD_LOGIC_VECTOR (input_data_width-1 downto 0);
           sec_i     : in STD_LOGIC_VECTOR (2*input_data_width-1 downto 0);
           sec_o    : out STD_LOGIC_VECTOR (2*input_data_width-1 downto 0));
end MAC_module;

architecture Behavioral of MAC_module is

signal a_reg, a_next, b_reg, b_next : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal m_reg, m_next                : STD_LOGIC_VECTOR (2*input_data_width-1 downto 0);
signal p_reg, p_next                : STD_LOGIC_VECTOR (2*input_data_width-1 downto 0);

begin

pr: process(clk) is
    begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            a_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, input_data_width));
            b_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, input_data_width));
            m_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2*input_data_width));
            p_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2*input_data_width));
        else
            a_reg <= a_next;
            b_reg <= b_next;
            m_reg <= m_next;
            p_reg <= p_next;
        end if;
    end if;
    end process;
    
    a_next <= u_i;
    b_next <= b_i;
    -- Multiplier
    m_next <= STD_LOGIC_VECTOR(signed(a_reg) * signed(b_reg));
    -- Adder
    p_next <= STD_LOGIC_VECTOR(signed(m_reg) + signed(sec_i));
   
    sec_o <= p_reg;

end Behavioral;