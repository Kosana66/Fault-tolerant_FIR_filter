library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.txt_util.all;
use work.util_pkg.all;

entity top_tb is
    Generic(fir_ord : natural := 20;
            input_data_width : natural := 24;
            output_data_width : natural := 24;
            n_param : natural := 5);
    --  Port ( );
end top_tb;

architecture Behavioral of top_tb is
constant period : time := 20 ns;

signal  clk : STD_LOGIC;
signal we_i : STD_LOGIC;
signal coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
signal coef_i : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal data_i : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal init : STD_LOGIC;
signal top_output: std_logic_vector(output_data_width-1 downto 0);

file input_test_vector : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/input.txt";
file output_check_vector : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/expected.txt";
file input_coef : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/coef.txt";

signal start_check : std_logic := '0';

begin

    redudant_system_instances: entity work.top
        Generic map(fir_ord => fir_ord,
            input_data_width => input_data_width,
            output_data_width => output_data_width,
            n_param => n_param)
        Port map(clk => clk,
               we_i => we_i,
               coef_addr_i => coef_addr_i,
               coef_i => coef_i,
               data_i => data_i,
               init => init,
               top_output => top_output
        );

    clk_process:
    process
    begin
        clk <= '0';
        wait for period/2;
        clk <= '1';
        wait for period/2;
    end process;
    
    stim_process:
    process
        variable tv : line;
    begin
        --upis koeficijenata
        data_i <= (others=>'0');
        init <= '1';
        wait until falling_edge(clk);
        for i in 0 to fir_ord loop
            we_i <= '1';
            coef_addr_i <= std_logic_vector(to_unsigned(i,log2c(fir_ord)));
            readline(input_coef,tv);
            coef_i <= to_std_logic_vector(string(tv));
            wait until falling_edge(clk);
            init <= '0';
        end loop;
        --ulaz za filtriranje
        while not endfile(input_test_vector) loop
            readline(input_test_vector,tv);
            data_i <= to_std_logic_vector(string(tv));
            wait until falling_edge(clk);
            start_check <= '1';
        end loop;
        start_check <= '0';
        report "verification done!" severity failure;
    end process;
    
    check_process:
    process
        variable check_v : line;
        variable tmp : std_logic_vector(input_data_width-1 downto 0);
    begin
        wait until start_check = '1';
        while(true)loop
            wait until rising_edge(clk);
            readline(output_check_vector,check_v);
            tmp := to_std_logic_vector(string(check_v));
            if(abs(signed(tmp) - signed(top_output)) > "000000000000000000000111")then
                report "result mismatch!" severity failure;
            end if;
        end loop;
    end process;
    

end Behavioral;
