library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_counter is
	port(
		clk_i       : in  std_logic;
		rst_i       : in  std_logic;
		PC_i     : in  std_logic_vector(1 DOWNTO 0);
		PC_o        : out std_logic_vector(31 downto 0)
	);
end pc_counter;
--TODO:use ALU for counter
architecture behavior of pc_counter is
	signal pc : std_logic_vector(31 downto 0) := (others => '0');
begin
	PC_cntr : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			pc <= (others => '0');
		elsif rising_edge(clk_i) then
			pc <= std_logic_vector(unsigned(PC_i) + 4);
		end if;
	end process PC_cntr;

	PC_o <= pc;

end architecture behavior;
