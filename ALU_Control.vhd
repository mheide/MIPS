library ieee;
use ieee.std_logic_1164.all;

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
	
	constant c_add   : std_logic_vector(3 downto 0)  := "0010";
	constant c_addu  : std_logic_vector(3 downto 0)  := "1010";
	constant c_sub   : std_logic_vector(3 downto 0)  := "0110";
	constant c_subu  : std_logic_vector(3 downto 0)  := "1110";
	constant c_and   : std_logic_vector(3 downto 0)  := "0000";
	constant c_or    : std_logic_vector(3 downto 0)  := "0001";
	constant c_nor   : std_logic_vector(3 downto 0)  := "0011";
	constant c_xor   : std_logic_vector(3 downto 0)  := "0100";	
	constant c_error : std_logic_vector(3 downto 0) := (others => 'X');
	constant c_zero  : std_logic_vector(3 downto 0) := (others => '0');	

begin
	alu_code_o <= rtype_alu_code when ALU_Op_i(1) = '1' else
					c_add when ALU_Op_i = "00" else
					c_error;

	with functioncode_i select rtype_alu_code <=
		c_add when "100000",	--add
		c_addu when "100001",	--addu
		c_sub when "100010",	--sub
		c_subu when "100011",	--subu
		c_and when "100100",	--and
		c_or  when "100101",	--or
		c_nor when "100111",	--nor
		c_xor when "100110",	--xor
		c_error when others;

end architecture RTL;
