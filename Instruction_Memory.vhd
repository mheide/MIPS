library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Instructions_pack.all;

entity Instruction_Memory is
	generic(
		size : natural := 29 --number of instructions
	);
	port(
		pc_i  : in  std_logic_vector(31 DOWNTO 0);
		out_o : out std_logic_vector(31 DOWNTO 0)
	);
end entity Instruction_Memory;

architecture behaviour of Instruction_Memory is
	constant size2 : integer := size * 4;
	type memRegType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal memReg : memRegType := (
		
		"00000000",	"00000000",	"00000000",	"00100000",	--nop
		
		"00100000", "00000010", "00000000", "00000000", --addi 
		
		"00011100", "00100000", "00000000", "00000000", --bgtz yes
		
		"00011111", "11000000", "00000000", "00000000", --bgtz no
		
		
		"00011100", "00000000", "00000000", "00000000", --bgtz no
		
		"00011011", "11000000", "00000000", "00000000", --blez yes
		
		"00011000", "00000000", "00000000", "00000000", --blez yes
		
		"00011000", "01100000", "00000000", "00000000", --blez no
		
		
		"00010000", "01100100", "00000000", "00000000", --beq yes
		
		"00010000", "01100001", "00000000", "00000000", --beq no
		
		"00010100", "11100001", "00000000", "00000000", --bne yes
		
		"00010100", "01100100", "00000000", "00000000", --bne no
		
		
		"00110100", "10100100", "01010101", "10101010", --ori		
		
		"10101100",	"00000001",	"00000000",	"00000000",	--store
		
		"10101100",	"00000010",	"00000000",	"00000100",
		
		"10101100",	"00001011",	"00000000",	"00001000",		
		

		"10101100",	"00010010",	"00000000",	"00001100",		

		"00000000",	"00000000", "00000000",	"00100000", --nop

		"00000000",	"00000000",	"00000000",	"00100000", --nop
		
		"10001100",	"00000100",	"00000000",	"00000000",	--load
		
		
		"10001100",	"00000101",	"00000000",	"00000100",

		"10001100",	"00000110",	"00000000",	"00001000",

		"10001100",	"00000111",	"00000000",	"00001100",		
		
		"00000000",	"00000000",	"00000000",	"00100000",	--nop
		

		"00000000",	"00000000",	"00000000",	"00100000",		
		
		"00000000",	"00100010",	"00011000",	"00100000",	--add normal
		
		"00000000", "00100010",	"00111000",	"00100000",	
		
		"00000000", "01100110",	"01111000",	"00100000",	
		
		
		"00000000", "01100110",	"11111000",	"00100010"	--sub

		
	);
	signal output : std_logic_vector(31 DOWNTO 0);
	
	
begin
	
	output(31 DOWNTO 24) <= memReg(TO_INTEGER(UNSIGNED(pc_i)));
	output(23 DOWNTO 16) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 1);
	output(15 DOWNTO 8)  <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 2);
	output(7 DOWNTO 0)   <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 3);

	out_o <= output;
end architecture;

