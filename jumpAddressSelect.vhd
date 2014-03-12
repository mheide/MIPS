library ieee;
use ieee.std_logic_1164.all;

entity jumpAddressSelect is
	port(
		rst_i               : in  std_logic;
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
	jumpAddress_o <= PC_modified when PCSource_i = "10" ELSE 
	                 ALU_result when PCSource_i = "00" ELSE
	                 pc_from_reg_i when PCSource_i = "11" else
	                 (others => '0');
	pc_source_tmp <= '0' when rst_i = '1' else
	                 '1' when PCSource_i(0) = '1' and ALU_zero_i = '1'
	                     else '0';
	
	PCSource_o <= '0' when rst_i = '1' else
	              '1' when PCSource_i(1) = '1' or pc_source_tmp = '1'
	                  else '0';
	
end architecture behaviour;