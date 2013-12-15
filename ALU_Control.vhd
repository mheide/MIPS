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

begin
	alu_code_o <= rtype_alu_code when ALU_Op_i(1) = '1' else "ZZZZ";

	with functioncode_i select rtype_alu_code <=
		"0010" when "100000",
		"0110" when "100010",
		"0000" when "100100",
		"0001" when "100101",
		"XXXX" when others;

end architecture RTL;
