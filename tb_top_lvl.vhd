library ieee;
use ieee.std_logic_1164.all;

entity tb_top_lvl is

end tb_top_lvl;

architecture tb of tb_top_lvl is

component TOP_Lvl
	port(clk_i    : in std_logic;
		 rst_i    : in std_logic;
		 enable_i : in std_logic);
end component TOP_Lvl;

	signal CLK : std_logic := '0';
	signal RST : std_logic := '1';
	signal ENABLE : std_logic := '1';
	constant PERIOD : time := 20 ns;
begin
	dut : TOP_Lvl
	port map(
		clk_i    => CLK,
		rst_i    => RST,
		enable_i => ENABLE
	);
	
	RST <= '0' after 55 ns;
	
	clock_generator : process is
	begin
		CLK <= '0';
		wait for PERIOD/2;
		CLK <= '1';
		wait for PERIOD/2;
	end process;
	
	

end architecture;
