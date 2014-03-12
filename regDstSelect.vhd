library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regDstSelect is
	port(
		regDst_i            : in  std_logic_vector(1 downto 0);
		instruction_20_16_i : in  std_logic_vector(4 DOWNTO 0);
		instruction_15_11_i : in  std_logic_vector(4 DOWNTO 0);

		instruction_o       : out std_logic_vector(4 DOWNTO 0)
	);
end entity regDstSelect;

architecture behaviour of regDstSelect is
	constant c_ra : natural := 31;
begin
	instruction_o <= instruction_15_11_i when regDst_i = "11" ELSE 
	                 instruction_20_16_i when regDst_i = "10" ELSE
	                 std_logic_vector(to_unsigned(c_ra, 5)) when regDst_i = "00" else
	                 (others => 'X');

end architecture behaviour;