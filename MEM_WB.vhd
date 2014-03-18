library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB is                        --first pipeline stage with instruction_register
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		enable_i               : in  std_logic;
		ALU_result_memwb_i     : in  std_logic_vector(31 downto 0);
		dataAddr_memwb_i       : in  std_logic_vector(4 downto 0);

		memToReg_memwb_i       : in  std_logic; --WB
		regWrite_memwb_i       : in  std_logic;

		ALU_result_memwb_o     : out std_logic_vector(31 downto 0);
		dataAddr_memwb_o       : out std_logic_vector(4 downto 0);

		memToReg_memwb_o       : out std_logic;
		regWrite_memwb_o       : out std_logic
	);
end entity MEM_WB;

architecture behaviour of MEM_WB is

	signal aluResult      : std_logic_vector(31 downto 0);
	signal dataAddr       : std_logic_vector(4 downto 0);

	signal memToReg : std_logic;
	signal regWrite : std_logic;

begin
	MEM_WB_reg : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			dataAddr       <= (others => '0');
			aluResult      <= (others => '0');

			memToReg <= '0';
			regWrite <= '0';

		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				aluResult      <= ALU_result_memwb_i;
				dataAddr       <= dataAddr_memwb_i;

				memToReg <= memToReg_memwb_i;
				regWrite <= regWrite_memwb_i;
			end if;
		end if;
	end process MEM_WB_reg;

	ALU_result_memwb_o     <= aluResult;
	dataAddr_memwb_o       <= dataAddr;

	memToReg_memwb_o <= memToReg;
	regWrite_memwb_o <= regWrite;
end architecture;