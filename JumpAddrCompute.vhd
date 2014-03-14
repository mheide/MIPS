library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity JumpAddrCompute is
	port(
		branch_i   : in  std_logic; --1 when branch
		jumpAddr_i : in  std_logic_vector(25 downto 0);
		pc_i       : in  std_logic_vector(31 downto 0);
		pc_o       : out std_logic_vector(31 downto 0)
	);
end entity JumpAddrCompute;

architecture RTL of JumpAddrCompute is
	signal pc_j      : std_logic_vector(31 downto 0);
	signal pc_b 	 : std_logic_vector(31 downto 0);
	signal jumpshift : std_logic_vector(17 downto 0);
begin		
		
	jumpshift <= jumpAddr_i(15 downto 0) & "00";	
		
	pc_j <= pc_i(31 downto 28) & jumpAddr_i & "00";
	pc_b <= std_logic_vector(signed(pc_i) + signed(jumpshift));
	
	pc_o <= pc_j when branch_i = '0' else 
			pc_b;
			
end architecture RTL;
