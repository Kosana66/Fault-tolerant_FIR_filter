library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.util_pkg.all;

entity BRAM is
generic ( input_data_width : natural := 24;
          num_of_samples : natural := 4096);
port(
	clk : in std_logic;
	ena : in std_logic;
	enb : in std_logic;
	wea : in std_logic;
	addra : in std_logic_vector(log2c(num_of_samples)-1 downto 0);
	addrb : in std_logic_vector(log2c(num_of_samples)-1 downto 0);
	dia : in std_logic_vector(input_data_width-1 downto 0);
	dob : out std_logic_vector(input_data_width-1 downto 0)
);
end BRAM;

architecture Bihevioral of BRAM is
	type ram_type is array (num_of_samples-1 downto 0) of std_logic_vector(input_data_width-1 downto 0);
	shared variable RAM : ram_type := (others => (others => '0'));
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if ena = '1' then
				if wea = '1' then
					RAM(conv_integer(addra)) := dia;
				end if;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if enb = '1' then
				dob <= RAM(conv_integer(addrb));
		    else 
		        dob <= (others => '0');
			end if;
		end if;
	end process;

end Bihevioral;
