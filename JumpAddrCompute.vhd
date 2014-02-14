library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity JumpAddrCompute is
	port(
		clk_i      : in  std_logic;
		rst_i      : in  std_logic;
		jumpAddr_i : in  std_logic_vector(25 downto 0);
		pc_i       : in  std_logic_vector(31 downto 0);
		pc_o       : out std_logic_vector(31 downto 0)
	);
end entity JumpAddrCompute;

architecture RTL of JumpAddrCompute is
	signal pc_high : std_logic_vector(31 downto 0) := (others => '0');
	signal pc      : std_logic_vector(31 downto 0) := (others => '0');
begin
	process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			pc_high <= (others => '0');
			pc      <= (others => '0');
		elsif rising_edge(clk_i) then
			pc_high <= std_logic_vector(unsigned(pc_i) + 4);
			pc      <= pc_high(31 downto 28) & jumpAddr_i & "00";
		end if;
	end process;
	pc_o <= pc;
end architecture RTL;
