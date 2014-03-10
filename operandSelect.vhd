library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity operandSelect is
	port(
		ALUSrcA_i            : in  std_logic;
		ALUSrcB_i 			: in  std_logic_vector(1 DOWNTO 0);
		
		PC_A_i : in  std_logic_vector(31 DOWNTO 0);
		RF_A_i : in std_logic_vector(31 DOWNTO 0);
		
		RF_B_i : in std_logic_vector(31 DOWNTO 0);
		SignExt_B_i : in std_logic_vector(31 DOWNTO 0);

		A_o : out std_logic_vector(31 DOWNTO 0);
		B_o : out std_logic_vector(31 DOWNTO 0)
	);
end entity operandSelect;

architecture behaviour of operandSelect is
	signal signext_b : std_logic_vector(31 downto 0);
	constant c_pccount : natural := 4;
begin
	signext_b <= SignExt_B_i;
	
	A_o <= RF_A_i when ALUSrcA_i = '1' ELSE 
	                 PC_A_i when ALUSrcA_i = '0' ELSE 
	                 (others => 'X');
	B_o <= RF_B_i when ALUSrcB_i = "00" ELSE
					SignExt_B_i when ALUSrcB_i = "10" ELSE
					signext_b(29 DOWNTO 0) & "00" when ALUSrcB_i = "11" ELSE
					std_logic_vector(to_unsigned(c_pccount,32)); -- when ALUSrcB_i = "01"

end architecture behaviour;