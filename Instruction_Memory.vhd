library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Memory is
	generic(
		size : natural := 4
	);	
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		pc_i : in std_logic_vector(31 DOWNTO 0);
		
		out_o : out std_logic_vector(31 DOWNTO 0)
		
		
	);
end entity Instruction_Memory;

architecture behaviour of Instruction_Memory is

	constant  size2 : integer := size * 4;
	type memRegType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal memReg : memRegType;
	signal output : std_logic_vector(31 DOWNTO 0);
begin
	output(31 DOWNTO 24) <= memReg(TO_INTEGER(UNSIGNED(pc_i)));
	output(23 DOWNTO 16) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 1);
	output(15 DOWNTO 8) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 2);
	output(7 DOWNTO 0) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 3);

	out_o <= output;
end architecture;

