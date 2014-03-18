library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.Instructions_pack.all;

entity Instruction_Memory is
	generic(
		size : natural := 25 --number of instructions
	);
	port(
		pc_i  : in  std_logic_vector(31 DOWNTO 0);
		out_o : out std_logic_vector(31 DOWNTO 0)
	);
end entity Instruction_Memory;

architecture behaviour of Instruction_Memory is
	constant size2 : integer := size * 4;
	constant jump2 : J_Type := (opcode => c_j, address => "00" & x"000006"); --jump to pc = 24
	constant jump : J_Type := (opcode => c_j, address => "00" & x"000001"); --jump to pc==4
	constant jal : J_Type := (opcode => c_jal, address => "00" & x"000013"); --jump to pc76 and link to $ra
	constant jalr : R_Type := (opcode => c_jalr.opcode, rs => '1'&x"F", rt => c_jalr.rt, rd => '1'&x"F", shamt => '0'&x"0", funct => c_jalr.funct);
	constant jr   : R_Type := (opcode => c_jr.opcode, rs => '1'&x"F", rt => c_jr.rt, rd => '0'&x"0", shamt => '0'&x"0", funct => c_jr.funct);
	type memRegType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal memReg : memRegType := (
		
		"00000000",	"00000000",	"00000000",	"00000000",	--nop pc=0
		
		jump2.opcode & jump2.address(25 downto 24), jump2.address(23 downto 16), jump2.address(15 downto 8), jump2.address(7 downto 0), --jump to pc24, pc=4
		
		x"00", x"00", x"00", x"00",	--nop pc=8
		
		x"00", x"00", x"00", x"00", --nop pc=12
		
		x"00", x"00", x"00", x"00",	--nop pc=16
		
		"10101100",	"00000010",	"00000000",	"00000100", --pc=20
		
		jal.opcode & jal.address(25 downto 24), jal.address(23 downto 16), jal.address(15 downto 8), jal.address(7 downto 0),	--pc=24

		jr.opcode & jr.rs(4 downto 3), jr.rs(2 downto 0) & jr.rt, jr.rd & jr.shamt(4 downto 2), jr.shamt(1 downto 0) & jr.funct,	--pc=28 nop

		"00000000",	"00000000", "00000000",	"00000000", --nop pc=32

		"00000000",	"00000000",	"00000000",	"00000000", --nop pc=36
		
		"10001100",	"00000100",	"00000000",	"00000000",	--load pc=40
		
		"10001100",	"00000101",	"00000000",	"00000100", --pc=44

		"10001100",	"00000110",	"00000000",	"00001000", --pc=48

		"10001100",	"00000111",	"00000000",	"00001100",	--pc=52
		
		"00000000",	"00000000",	"00000000",	"00100000",	--nop pc=56

		"00000000",	"00000000",	"00000000",	"00100000",	--pc=60
		
		"00000000",	"00100010",	"00011000",	"00100000",	--add normal pc=64
		
		"00000000", "00100010",	"00111000",	"00100000",	--pc=68
		
		"00000000", "01100110",	"01111000",	"00100000",	--pc=72
		
		jalr.opcode & jalr.rs(4 downto 3), jalr.rs(2 downto 0) & jalr.rt, jalr.rd & jalr.shamt(4 downto 2), jalr.shamt(1 downto 0) & jalr.funct,	--sub pc=76
		
		jump.opcode & jump.address(25 downto 24), jump.address(23 downto 16), jump.address(15 downto 8), jump.address(7 downto 0),--jump pc=80
		 
		x"00", x"00", x"00", x"00", --pc84
		x"00", x"00", x"00", x"00", --pc88
		x"00", x"00", x"00", x"00", --pc92
		x"00", x"00", x"00", x"00" --pc96
	
	);
	signal output : std_logic_vector(31 DOWNTO 0);
	
	
begin
	
	output(31 DOWNTO 24) <= memReg(TO_INTEGER(UNSIGNED(pc_i)));
	output(23 DOWNTO 16) <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 1);
	output(15 DOWNTO 8)  <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 2);
	output(7 DOWNTO 0)   <= memReg(TO_INTEGER(UNSIGNED(pc_i)) + 3);

	out_o <= output;
end architecture;

