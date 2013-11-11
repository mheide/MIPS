library ieee;
use ieee.std_logic_1164.all;

entity DataMemory is
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		alu_result_i : in std_logic_vector(31 DOWNTO 0);
		writeData_i : in std_logic_vector(31 DOWNTO 0);
		memWrite_i : in std_logic;		--0 for arithmetic op's
		
		readData_o : out std_logic_vector(31 DOWNTO 0)
	);
end entity DataMemory;

architecture behaviour of DataMemory is


begin
	readData_o <= alu_result_i when memWrite_i = '0' else
					(others => '0');

end architecture;