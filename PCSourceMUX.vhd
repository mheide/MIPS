library ieee;
use ieee.std_logic_1164.all;

entity PCSourceMUX is
	port(
		rst_i      : in  std_logic;
		pcSource_i : in  std_logic;
		PC_i       : in  std_logic_vector(31 downto 0);
		PC_jump_i  : in  std_logic_vector(31 downto 0);
		PC_o       : out std_logic_vector(31 downto 0)
	);
end entity PCSourceMUX;

architecture Behavioral of PCSourceMUX is
begin
	PC_o <= (others => '0') when rst_i = '1' else
	              PC_jump_i when pcSource_i = '1' else 
	              PC_i;
end architecture Behavioral;
