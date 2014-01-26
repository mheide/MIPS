library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
	
	generic(
		size : natural := 8 --number of instructions
	);	
	port(
		clk_i        : in  std_logic;
		rst_i        : in  std_logic;
		alu_result_i : in  std_logic_vector(31 DOWNTO 0);
		writeData_i  : in  std_logic_vector(31 DOWNTO 0);
		memWrite_i   : in  std_logic;   --0 for arithmetic op's
		memRead_i 	 : in  std_logic;
		
		readData_o   : out std_logic_vector(31 DOWNTO 0)
	);
end entity DataMemory;

architecture behaviour of DataMemory is
	constant size2 : integer := size * 4;
	type dataMemType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal dataMem : dataMemType := (
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000"
	);
	signal aluresult : std_logic_vector(31 downto 0);
	signal tempread : std_logic_vector(31 downto 0);
	signal readout : std_logic_vector(31 downto 0);
	begin

	readout <= tempread when memRead_i = '1' else 
				aluresult when memRead_i = '0' else
				(others => 'X');
	
	tempread(31 downto 24) <= dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) when memRead_i = '1';
	tempread(23 downto 16) <= dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1) when memRead_i = '1';
	tempread(15 downto 8) <= dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 2) when memRead_i = '1';
	tempread(7 downto 0) <= dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 3) when memRead_i = '1';						

	dataMem_process : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			readData_o <= (others => '0');
		elsif rising_edge(clk_i) then
			readData_o <= readout;
			if memWrite_i = '1' then
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) <= writeData_i(31 DOWNTO 24);
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1) <= writeData_i(23 DOWNTO 16);
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 2) <= writeData_i(15 DOWNTO 8);
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 3) <= writeData_i(7 DOWNTO 0);
			else
				aluresult <= alu_result_i;
			end if;
		end if;
	end process dataMem_process;				
	
end architecture;