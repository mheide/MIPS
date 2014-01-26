library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity JumpAddrCompute is
	port(
		jumpAddr_i : in  std_logic(25 downto 0);
		pc_i       : in  std_logic(31 downto 0);
		pc_o       : out std_logic(31 downto 0)
	);
end entity JumpAddrCompute;

architecture RTL of JumpAddrCompute is
	signal pc_high : std_logic_vector(3 downto 0);
	signal pc      : std_logic_vector(31 downto 0);
begin
	pc_high <= std_logic_vector(unsigned(pc) + to_unsigned(4, 31))(31 downto 28);
	pc <= pc_high & jumpAddr_i & "00";
end architecture RTL;
