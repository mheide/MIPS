library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity ALU_Control is
	port(
		rst_i          : in  std_logic;
		ALU_Op_i       : in  std_logic_vector(1 downto 0);
		functioncode_i : in  std_logic_vector(5 downto 0);
		alu_code_o     : out std_logic_vector(3 downto 0)
	);
end entity ALU_Control;

architecture RTL of ALU_Control is
	signal rtype_alu_code : std_logic_vector(3 downto 0);
	
	constant c_alu_add   : std_logic_vector(3 downto 0)  := "0010";
	constant c_alu_addu  : std_logic_vector(3 downto 0)  := "1010";
	constant c_alu_sub   : std_logic_vector(3 downto 0)  := "0110";
	constant c_alu_subu  : std_logic_vector(3 downto 0)  := "1110";
	constant c_alu_and   : std_logic_vector(3 downto 0)  := "0000";
	constant c_alu_or    : std_logic_vector(3 downto 0)  := "0001";
	constant c_alu_nor   : std_logic_vector(3 downto 0)  := "0011";
	constant c_alu_xor   : std_logic_vector(3 downto 0)  := "0100";	
	constant c_alu_error : std_logic_vector(3 downto 0) := (others => 'X');
	constant c_alu_zero  : std_logic_vector(3 downto 0) := (others => '0');	

begin
	alu_code_o <= rtype_alu_code when ALU_Op_i(1) = '1' else
					c_alu_add when ALU_Op_i = "00" else
					c_alu_error;

	with functioncode_i select rtype_alu_code <=
		c_alu_add when c_add.funct,		--add
		c_alu_addu when c_addu.funct,	--addu
		c_alu_sub when c_sub.funct,		--sub
		c_alu_subu when c_subu.funct,	--subu
		c_alu_and when c_and.funct,		--and
		c_alu_or  when c_or.funct,		--or
		c_alu_nor when c_nor.funct,		--nor
		c_alu_xor when c_xor.funct,		--xor
		c_alu_error when others;

end architecture RTL;
