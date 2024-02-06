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
            n_param : natural := 7;
            num_of_samples : natural := 4096);
    --  Port ( );
end top_tb;

architecture Behavioral of top_tb is
constant period : time := 20 ns;

signal  clk : STD_LOGIC;
signal rst : std_logic;
signal coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
signal coef_i : STD_LOGIC_VECTOR (input_data_width-1 downto 0);
signal init : STD_LOGIC;

file input_test_vector : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/input.txt";
file output_check_vector : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/expected.txt";
file input_coef : text open read_mode is "/home/kosana/Desktop/DSONG/Fault-tolerant_FIR_filter/Fault-tolerant_FIR_filter.srcs/sim_1/new/coef.txt";

signal start_check : std_logic := '0';

signal ena :  std_logic;
signal enb :  std_logic;
signal wea :  std_logic;
signal we_i :  std_logic;
signal addra :  std_logic_vector(log2c(num_of_samples)-1 downto 0);
signal addrb :  std_logic_vector(log2c(num_of_samples)-1 downto 0);
signal dia :  std_logic_vector(input_data_width-1 downto 0);
signal dob :  std_logic_vector(output_data_width-1 downto 0);
signal START, READY : std_logic;

begin

    redudant_system_instances: entity work.top
        Generic map(fir_ord => fir_ord,
            input_data_width => input_data_width,
            output_data_width => output_data_width,
            n_param => n_param)
        Port map(clk => clk,
               rst => rst,
               we_i => we_i,
               coef_addr_i => coef_addr_i,
               coef_i => coef_i,
               init => init,
               ena  => ena,
               enb  => enb, 
               wea  => wea,
               addra  => addra,
               addrb  => addrb,
               dia  => dia,
               dob => dob,
               START => START,
               READY => READY
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
        variable pos_in_BRAM : natural := 0;
    begin
    
        init <= '1';
        enb <= '0';
        addrb <= (others => '0');
        START <= '0';
        coef_addr_i <= (others => '0');
        coef_i <= (others => '0');
        wait until falling_edge(clk);
        
        --upis u ulazni BRAM
        pos_in_BRAM := 0;
        ena <= '1';
        wea <= '1';
        for i in 0 to num_of_samples-1 loop
            readline(input_test_vector,tv);
            dia <= to_std_logic_vector(string(tv));
            addra <= std_logic_vector(to_unsigned(pos_in_BRAM, log2c(num_of_samples)));
            wait until falling_edge(clk);
            pos_in_BRAM := pos_in_BRAM + 1;
        end loop;
        addra <= (others => '0');
        dia <= (others => '0');
        ena <= '0';
        wea <= '0';
        
        --upis koeficijenata u filtar
        for i in 0 to fir_ord loop
            we_i <= '1';
            coef_addr_i <= std_logic_vector(to_unsigned(i,log2c(fir_ord)));
            readline(input_coef,tv);
            coef_i <= to_std_logic_vector(string(tv));
            wait until falling_edge(clk);
        end loop;
        
        -- pocetak obrade u filtru
        -- paralelan upis u izlazni BRAM
        START <= '1';
        init <= '0';
        enb <= '1';
        for i in 0 to pos_in_BRAM-1 loop   
            wait until falling_edge(clk);
        end loop; 
        
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        
        -- citanje iz izlaznog BRAM-a
        for i in 0 to pos_in_BRAM-1 loop   
            addrb <= std_logic_vector(to_unsigned(i,log2c(num_of_samples)));
            wait until falling_edge(clk);
            if(i = 0) then
                start_check <= '1';
            end if;
            pos_in_BRAM := pos_in_BRAM + 1;
        end loop; 
        
        report "verification done!" severity failure;
    end process;
    
    -- provera da li su podaci na izlazu validni
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
            if(abs(signed(tmp) - signed(dob)) > "000000000000000000000111")then    
                report "result mismatch!" severity failure;
            end if;
        end loop;
    end process;
    

end Behavioral;
