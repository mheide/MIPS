library ieee;
use ieee.std_logic_1164.all;

entity jumpAddressSelect is
	port(
		PCSource_i          : in  std_logic_vector(1 DOWNTO 0);
		ALU_result 			: in  std_logic_vector(31 DOWNTO 0);
		ALU_result_modified : in  std_logic_vector(31 DOWNTO 0);
		PC_modified			: in  std_logic_vector(31 DOWNTO 0);

		jumpAddress_o       : out std_logic_vector(31 DOWNTO 0)
	);
end entity jumpAddressSelect;

architecture behaviour of jumpAddressSelect is
begin
	jumpAddress_o <= PC_modified when PCSource_i = "10" ELSE 
	                 ALU_result when PCSource_i = "00" ELSE 
					 ALU_result_modified when PCSource_i = "01" ELSE
	                 (others => 'X');

end architecture behaviour;