library ieee;
use ieee.std_logic_1164.all;

entity tb_dataMemory is

end tb_dataMemory;

architecture behaviour of tb_dataMemory is

component DataMemory is
	
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
end component;

	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	constant PERIOD : time := 20 ns;
	
	signal ALURESULT : std_logic_vector(31 downto 0);
	signal WRITEDATA : std_logic_vector(31 downto 0);
	signal MEMWRITE : std_logic := '0';
	signal MEMREAD : std_logic := '0';
	signal READDATA : std_logic_vector(31 downto 0);
	
	
	
	
	begin
	
	dut : DataMemory 
	port map(
			clk_i => CLK,
			rst_i => RST,
			alu_result_i => ALURESULT,
			writeData_i => WRITEDATA,
			memWrite_i => MEMWRITE,
			memRead_i => MEMREAD,
			readData_o => READDATA
	);
	
	clock_generator : process is
	begin
		CLK <= '0';
		wait for PERIOD/2;
		CLK <= '1';
		wait for PERIOD/2;
	end process;

	ALURESULT <= x"00000000" after 30 ns, x"00000004" after 70 ns, x"00000000" after 110 ns,
	             x"33333333" after 130 ns;
	WRITEDATA <= x"A05054F4" after 35 ns, x"DDDDDA6A" after 80 ns;
	MEMWRITE <= '1' after 35 ns, '0' after 100 ns;
	MEMREAD <= '1' after 95 ns, '0' after 120 ns;
	
	
		

end architecture;