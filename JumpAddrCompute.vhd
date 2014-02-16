library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity JumpAddrCompute is
	port(
		JorB_i	   : in  std_logic; --jump or branch
		jumpAddr_i : in  std_logic_vector(25 downto 0);
		pc_i       : in  std_logic_vector(31 downto 0);
		pc_o       : out std_logic_vector(31 downto 0)
	);
end entity JumpAddrCompute;

architecture RTL of JumpAddrCompute is
	signal pc_high   : std_logic_vector(31 downto 0);
	signal pc_j      : std_logic_vector(31 downto 0);
	signal pc_b 	 : std_logic_vector(31 downto 0);
begin
		
	pc_high <= std_logic_vector(unsigned(pc_i) + 4);
	pc_j <= pc_high(31 downto 28) & jumpAddr_i & "00";
	pc_b <= pc_i(31 downto 18) & jumpAddr_i(15 downto 0) & "00";
	pc_o <= pc_j when JorB_i = '1' else 
			pc_b;
			
end architecture RTL;
