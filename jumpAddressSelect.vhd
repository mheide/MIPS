library ieee;
use ieee.std_logic_1164.all;

entity jumpAddressSelect is
	port(
		rst_i               : in  std_logic;
		PCSource_i          : in  std_logic_vector(1 downto 0);
		ALU_result 			: in  std_logic_vector(31 DOWNTO 0);
		ALU_zero_i          : in  std_logic;
		PC_modified			: in  std_logic_vector(31 DOWNTO 0);
		A_data_i            : in  std_logic_vector(31 downto 0);

		jumpAddress_o       : out std_logic_vector(31 DOWNTO 0)
	);
end entity jumpAddressSelect;

architecture behaviour of jumpAddressSelect is
begin
	jumpAddress_o <= PC_modified when PCSource_i = "10" ELSE 
	                 ALU_result  when PCSource_i = "00" ELSE
	                 A_data_i    when PCSource_i = "01" else
	                 (others => '0');
end architecture behaviour;