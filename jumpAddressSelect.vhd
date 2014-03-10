library ieee;
use ieee.std_logic_1164.all;

entity jumpAddressSelect is
	port(
		PCSource_i          : in  std_logic_vector(1 downto 0);
		ALU_result 			: in  std_logic_vector(31 DOWNTO 0);
		ALU_zero_i          : in  std_logic;
		PC_modified			: in  std_logic_vector(31 DOWNTO 0);
		pc_from_reg_i       : in  std_logic_vector(31 downto 0);

		jumpAddress_o       : out std_logic_vector(31 DOWNTO 0);
		PCSource_o          : out std_logic
	);
end entity jumpAddressSelect;

architecture behaviour of jumpAddressSelect is
	signal pc_source_tmp : std_logic;
begin
	jumpAddress_o <= PC_modified when PCSource_i = "11" ELSE 
	                 ALU_result when PCSource_i = "01" ELSE
	                 pc_from_reg_i when PCSource_i = "10" else
	                 (others => 'X');
	pc_source_tmp <= PCSource_i(0) and ALU_zero_i;
	
	PCSource_o <= PCSource_i(1) or pc_source_tmp;
	
end architecture behaviour;