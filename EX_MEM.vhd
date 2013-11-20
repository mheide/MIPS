library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is			--first pipeline stage with instruction_register
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		enable_i : in std_logic;
		PC_i : in std_logic_vector(31 downto 0);
				
		PC_o : out std_logic_vector(31 downto 0)
	);
end entity EX_MEM;