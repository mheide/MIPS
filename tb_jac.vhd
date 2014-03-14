library ieee;
use ieee.std_logic_1164.all;

entity tb_jac is

end tb_jac;

architecture tb of tb_jac is

component JumpAddrCompute is
	port(
		branch_i   : in  std_logic; --1 when branch
		jumpAddr_i : in  std_logic_vector(25 downto 0);
		pc_i       : in  std_logic_vector(31 downto 0);
		pc_o       : out std_logic_vector(31 downto 0)
	);
end component JumpAddrCompute;

	signal BRANCH_I : std_logic := '0';
	signal JUMPADDR_I : std_logic_vector(25 downto 0) := "00" & x"000002";
	signal PC_I  : std_logic_vector(31 downto 0) := x"00000000";
	signal PC_O : std_logic_vector(31 downto 0);
	
begin
	dut : JumpAddrCompute
	port map(branch_i => BRANCH_I,
			jumpAddr_i => JUMPADDR_I,
			pc_i => PC_I,
			pc_o => PC_O);
			
	BRANCH_I <= '1' after 20 ns, '0' after 100 ns;
	PC_I <= x"000000FE" after 40 ns;
	JUMPADDR_I <= "00" & x"000007" after 60 ns, "11" & x"FFFFFE" after 80 ns, 
				"00" & x"001DA6" after 90 ns;
	

end architecture;