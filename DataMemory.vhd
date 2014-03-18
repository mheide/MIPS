library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Instructions_pack.all;

entity DataMemory is
	
	generic(
		size : natural := 8 --number of instructions
	);	
	port(
		clk_i        	: in  std_logic;
		rst_i        	: in  std_logic;
		alu_result_i 	: in  std_logic_vector(31 DOWNTO 0);
		writeData_i  	: in  std_logic_vector(31 DOWNTO 0);
		memWrite_i   	: in  std_logic;   
		memRead_i 	 	: in  std_logic;
		loadMode_i  : in  load_mode;
		storeMode_i : in store_mode;
		
		readData_o   : out std_logic_vector(31 DOWNTO 0)
	);
end entity DataMemory;

architecture behaviour of DataMemory is
	constant size2 : integer := size * 4;
	type dataMemType is array (0 to size2 - 1) of std_logic_vector(7 downto 0);
	signal dataMem : dataMemType := (
			"11111011","00000000","00000000","00000000",
			"11101111","01000010","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000",
			"00000000","00000000","00000000","00000000"
	);
	signal readout : std_logic_vector(31 downto 0);
	signal loadWordRaw : std_logic_vector(31 downto 0);
	signal loadHalfRaw : std_logic_vector(31 downto 0);
	signal loadByteRaw : std_logic_vector(31 downto 0);
	signal loadHalfSigned : std_logic_vector(31 downto 0);
	signal loadByteSigned : std_logic_vector(31 downto 0);
	
	begin

	--determines how much bytes are loaded
	loadWordRaw <= dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) &
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1) &
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 2) &
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 3) 	when memRead_i = '1' and loadMode_i = ld_lw ELSE
				(others => '-');
	loadHalfRaw <= ("00000000" & "00000000" & 
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) &
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1)) 	when (memRead_i = '1') and ((loadMode_i = ld_lh) or (loadMode_i = ld_lhu)) ELSE
				(others => '-');
	loadByteRaw <= "00000000" & "00000000" & "00000000" & 
				dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) 		when memRead_i = '1' and ((loadMode_i = ld_lb) or (loadMode_i = ld_lbu)) ELSE
				(others => '-');
	
	--signed: resize to 32 bit
	loadHalfSigned <= std_logic_vector(resize(signed(loadHalfRaw(15 downto 0)), 32)) when loadMode_i = ld_lh ELSE
				(others => '-');
	loadByteSigned <= std_logic_vector(resize(signed(loadByteRaw(7 downto 0)), 32))  when loadMode_i = ld_lb ELSE
				(others => '-');
	
	--which mode is chosen
	readout <= 	loadWordRaw 		when loadMode_i = ld_lw ELSE
				loadHalfRaw 		when loadMode_i = ld_lhu ELSE
				loadHalfSigned 	when loadMode_i = ld_lh ELSE
				loadByteRaw 		when loadMode_i = ld_lbu ELSE
				loadByteSigned; 
	
	dataMem_process : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			readData_o <= (others => '0');
		elsif rising_edge(clk_i) then
			readData_o <= readout;
			if memWrite_i = '1' then
				if storeMode_i = st_sw then	--store normal
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) <= writeData_i(31 DOWNTO 24);
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1) <= writeData_i(23 DOWNTO 16);
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 2) <= writeData_i(15 DOWNTO 8);
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 3) <= writeData_i(7 DOWNTO 0);
				elsif storeMode_i = st_sh then		--store half
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) <= writeData_i(15 DOWNTO 8);
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i)) + 1) <= writeData_i(7 DOWNTO 0);
				else	--store byte
					dataMem(TO_INTEGER(UNSIGNED(alu_result_i))) <= writeData_i(7 DOWNTO 0);
					end if;
			end if;
		end if;
	end process dataMem_process;				
	
end architecture;