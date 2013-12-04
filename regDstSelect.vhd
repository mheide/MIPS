library ieee;
use ieee.std_logic_1164.all;

entity regDstSelect is
	port(
		regDst_i            : in  std_logic;
		instruction_20_16_i : in  std_logic_vector(4 DOWNTO 0);
		instruction_15_11_i : in  std_logic_vector(4 DOWNTO 0);

		instruction_o       : out std_logic_vector(4 DOWNTO 0)
	);
end entity regDstSelect;

architecture behaviour of regDstSelect is
begin
	instruction_o <= instruction_15_11_i when regDst_i = '1' ELSE 
	                 instruction_20_16_i when regDst_i = '0' ELSE 
	                 (others => 'X');

end architecture behaviour;