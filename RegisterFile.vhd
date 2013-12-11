library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
	port(
		clk_i        : in  std_logic;
		rst_i        : in  std_logic;
			
		data_i       : in  std_logic_vector(31 downto 0);			
		dataAddr_i   : in  std_logic_vector(4 downto 0);			
		dataA_Addr_i : in  std_logic_vector(4 downto 0); --rs
		dataB_Addr_i : in  std_logic_vector(4 downto 0); --rt
			
		ALUSrcA_i    : in  std_logic; --1 for arithmetic op
		ALUSrcB_i    : in  std_logic_vector(1 DOWNTO 0); --00 for arithmetic op	
			
		dataA_o      : out std_logic_vector(31 downto 0);
		dataB_o      : out std_logic_vector(31 downto 0)
	);
end entity RegisterFile;

architecture behaviour of RegisterFile is
	type regFileType is array (0 to 31) of std_logic_vector(31 downto 0);
	signal registers     : regFileType;
	signal writeDataAddr : std_logic_vector(4 DOWNTO 0);
begin
	registers(0) <= (others => '0');    --register $0

	dataA_o <= registers(TO_INTEGER(UNSIGNED(dataA_Addr_i))) when ALUSrcA_i = '1' ELSE (others => '0');

	dataB_o <= registers(TO_INTEGER(UNSIGNED(dataB_Addr_i))) when ALUSrcB_i = "00" ELSE (others => '0');

	register_process : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			registers <= (others => (others => '0'));
		elsif rising_edge(clk_i) then
			if dataAddr_i /= "00000" then --no write op's to $0
				registers(TO_INTEGER(UNSIGNED(dataAddr_i))) <= data_i;
			end if;
		end if;
	end process register_process;

end architecture;
