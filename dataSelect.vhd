library ieee;
use ieee.std_logic_1164.all;

entity dataSelect is
	port(
		ALU_result_i     : in  std_logic_vector(31 downto 0);
		memoryReadData_i : in  std_logic_vector(31 downto 0);
		memToReg_i       : in  std_logic;

		data_o           : out std_logic_vector(31 downto 0)
	);
end entity dataSelect;

architecture behaviour of dataSelect is
begin
	data_o <= ALU_result_i when memToReg_i = '0' ELSE memoryReadData_i when memToReg_i = '1' ELSE (others => 'X');

end architecture behaviour;