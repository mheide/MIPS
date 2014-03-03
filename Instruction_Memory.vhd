library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Instructions_pack.all;

entity Instruction_Memory is
	generic(
		size : natural := 20 --number of instructions
	);
	port(
		pc_i  : in  std_logic_vector(31 DOWNTO 0);
		out_o : out std_logic_vector(31 DOWNTO 0)
	);
end entity Instruction_Memory;

architecture behaviour of Instruction_Memory is
	constant size2 : integer := size * 4;
	constant jump : J_Type := (opcode => c_j, address => x"40"); --jump to pc==64 (add normal)
	type memRegType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal memReg : memRegType := (
		
		"00000000",	"00000000",	"00000000",	"00100000",	--nop pc=0
		
		"00100000", "00100010", "00000000", "00001111", --addi pc=4
		
		"00110000", "10000011", "11111111", "11111000",	--andi pc=8
		
		"00110100", "10100100", "01010101", "10101010", --ori pc=12
		
		"10101100",	"00000001",	"00000000",	"00000000",	--store pc=16
		
		"10101100",	"00000010",	"00000000",	"00000100", --pc=20
		
		"10101100",	"00001011",	"00000000",	"00001000",	--pc=24

		"10101100",	"00010010",	"00000000",	"00001100",	--pc=28

		"00000000",	"00000000", "00000000",	"00100000", --nop pc=32

		"00000000",	"00000000",	"00000000",	"00100000", --nop pc=36
		
		"10001100",	"00000100",	"00000000",	"00000000",	--load pc=40
		
		"10001100",	"00000101",	"00000000",	"00000100", --pc=44

		"10001100",	"00000110",	"00000000",	"00001000", --pc=48

		"10001100",	"00000111",	"00000000",	"00001100",	--pc=52
		
		"00000000",	"00000000",	"00000000",	"00100000",	--nop pc=56

		"00000000",	"00000000",	"00000000",	"00100000",	--pc=60
		
		"00000000",	"00100010",	"00011000",	"00100000",	--add normal pc=64
		
		"00000000", "00100010",	"00111000",	"00100000",	--pc=68
		
		"00000000", "01100110",	"01111000",	"00100000",	--pc=72
		
		"00000000", "01100110",	"11111000",	"00100010",	--sub pc=76
		
		 jump(31 downto 24), jump(23 downto 16), jump(15 downto 8), jump(7 downto 0)--jump pc=80

		
	);
	signal output : std_logic_vector(31 DOWNTO 0);
	
	
begin
	
	output(31 DOWNTO 24) <= memReg(TO_INTEGER(UNSIGNED(pc_i)));
	output(23 DOWNTO 16) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 1);
	output(15 DOWNTO 8)  <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 2);
	output(7 DOWNTO 0)   <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 3);

	out_o <= output;
end architecture;

