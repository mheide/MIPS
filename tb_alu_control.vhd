library ieee;
use ieee.std_logic_1164.all;

entity tb_alu_control is
end tb_alu_control;

architecture tb of tb_alu_control is
	component ALU_Control is
		port(
			rst_i          : in  std_logic;
			ALU_Op_i       : in  std_logic_vector(1 downto 0);
			functioncode_i : in  std_logic_vector(5 downto 0);
			alu_code_o     : out std_logic_vector(3 downto 0)
		);
	end component ALU_Control;

	signal RST          : std_logic                    := '0';
	signal ALU_OP       : std_logic_vector(1 downto 0) := "00";
	signal FUNCTIONCODE : std_logic_vector(5 downto 0) := "000000";
	signal ALU_CODE     : std_logic_vector(3 downto 0);

begin
	dut : ALU_Control
		port map(rst_i          => RST,
			     ALU_Op_i       => ALU_OP,
			     functioncode_i => FUNCTIONCODE,
			     alu_code_o     => ALU_CODE);

	ALU_OP       <= "10" after 20 ns;
	FUNCTIONCODE <= "100000" after 40 ns, "100101" after 70 ns;

end architecture;