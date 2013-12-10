library ieee;
use ieee.std_logic_1164.all;

entity ID_EX is                         --first pipeline stage with instruction_register
	port(
		clk_i                : in  std_logic;
		rst_i                : in  std_logic;
		enable_i             : in  std_logic;
		PCSource_idex_i      : in  std_logic_vector(1 DOWNTO 0);
		PC_idex_i            : in  std_logic_vector(31 downto 0);
		dataAddr_idex_i      : in  std_logic_vector(4 downto 0); --for r-type: destination address (register)


		ALUSrcB_idex_i       : in  std_logic_vector(1 DOWNTO 0); --EX
		ALUSrcA_idex_i       : in  std_logic;
		ALU_op_idex_i        : in  std_logic_vector(1 DOWNTO 0);
		function_code_idex_i : in  std_logic_vector(5 DOWNTO 0);

		branch_idex_i        : in  std_logic; --M
		memRead_idex_i       : in  std_logic;
		memWrite_idex_i      : in  std_logic;

		memToReg_idex_i      : in  std_logic; --WB
		regWrite_idex_i      : in  std_logic;

		PCSource_idex_o      : out std_logic_vector(1 DOWNTO 0);
		PC_idex_o            : out std_logic_vector(31 downto 0);
		dataAddr_idex_o      : out std_logic_vector(4 downto 0);

		ALUSrcB_idex_o       : out std_logic_vector(1 DOWNTO 0);
		ALUSrcA_idex_o       : out std_logic;
		ALU_op_idex_o        : out std_logic_vector(1 DOWNTO 0);
		function_code_idex_o : out std_logic_vector(5 DOWNTO 0);

		branch_idex_o        : out std_logic;
		memRead_idex_o       : out std_logic;
		memWrite_idex_o      : out std_logic;

		memToReg_idex_o      : out std_logic; --WB
		regWrite_idex_o      : out std_logic
	);
end entity ID_EX;

architecture behaviour of ID_EX is
	signal aluop        : std_logic_vector(1 DOWNTO 0);
	signal pcsource     : std_logic_vector(1 DOWNTO 0);
	signal pc           : std_logic_vector(31 downto 0);
	signal dataAddr     : std_logic_vector(4 downto 0);
	signal functioncode : std_logic_vector(5 downto 0);

	signal aluSrcA  : std_logic;
	signal aluSrcB  : std_logic_vector(1 DOWNTO 0);
	signal branch   : std_logic;
	signal memRead  : std_logic;
	signal memWrite : std_logic;
	signal memToReg : std_logic;
	signal regWrite : std_logic;

begin
	ID_EX_reg : process(clk_i, rst_i, enable_i) is
	begin
		if rst_i = '1' then
			aluop        <= (others => '0');
			pcsource     <= (others => '0');
			pc           <= (others => '0');
			dataAddr     <= (others => '0');
			functioncode <= (others => '0');

			aluSrcB  <= (others => '0');
			aluSrcA  <= '0';
			branch   <= '0';
			memRead  <= '0';
			memWrite <= '0';
			memToReg <= '0';
			regWrite <= '0';

		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				aluop        <= ALU_op_idex_i;
				pcsource     <= PCSource_idex_i;
				pc           <= PC_idex_i;
				dataAddr     <= dataAddr_idex_i;
				functioncode <= function_code_idex_i;

				aluSrcB  <= ALUSrcB_idex_i;
				aluSrcA  <= ALUSrcA_idex_i;
				branch   <= branch_idex_i;
				memRead  <= memRead_idex_i;
				memWrite <= memWrite_idex_i;
				memToReg <= memToReg_idex_i;
				regWrite <= regWrite_idex_i;

			end if;
		end if;
	end process ID_EX_reg;

	PCSource_idex_o <= pcsource;
	PC_idex_o       <= pc;
	dataAddr_idex_o <= dataAddr;

	ALUSrcB_idex_o       <= aluSrcB;
	ALUSrcA_idex_o       <= aluSrcA;
	ALU_op_idex_o        <= aluop;
	function_code_idex_o <= functioncode;

	branch_idex_o   <= branch;
	memRead_idex_o  <= memRead;
	memWrite_idex_o <= memWrite;
	memToReg_idex_o <= memToReg;
	regWrite_idex_o <= regWrite;

end architecture;