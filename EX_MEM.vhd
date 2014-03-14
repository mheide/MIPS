library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity EX_MEM is                        --first pipeline stage with instruction_register
	port(
		clk_i              : in  std_logic;
		rst_i              : in  std_logic;
		enable_i           : in  std_logic;
		PC_exmem_i         : in  std_logic_vector(31 downto 0);
		ALU_result_exmem_i : in  std_logic_vector(31 downto 0);
		A_data_exmem_i     : in  std_logic_vector(31 downto 0);
		B_data_exmem_i	   : in  std_logic_vector(31 downto 0);
		neg_flag_exmem_i   : in  std_logic;
		zero_flag_exmem_i  : in  std_logic;
		dataAddr_exmem_i   : in  std_logic_vector(4 downto 0);
		PCSource_exmem_i   : in  std_logic_vector(1 DOWNTO 0);
		jumpAddr_exmem_i   : in  std_logic_vector(31 downto 0);

		branch_exmem_i     : in  std_logic; --M
		memRead_exmem_i    : in  std_logic;
		memWrite_exmem_i   : in  std_logic;
		PCWrite_exmem_i    : in  std_logic;

		memToReg_exmem_i   : in  std_logic; --WB
		regWrite_exmem_i   : in  std_logic;
		branchCond_exmem_i : in  branch_condition;

		PC_exmem_o         : out std_logic_vector(31 downto 0);
		ALU_result_exmem_o : out std_logic_vector(31 downto 0);
		A_data_exmem_o     : out std_logic_vector(31 downto 0);
		B_data_exmem_o	   : out std_logic_vector(31 downto 0);	
		neg_flag_exmem_o   : out std_logic;
		zero_flag_exmem_o  : out std_logic;
		dataAddr_exmem_o   : out std_logic_vector(4 downto 0);
		PCSource_exmem_o   : out std_logic_vector(1 DOWNTO 0);
		jumpAddr_exmem_o   : out std_logic_vector(31 downto 0);

		branch_exmem_o     : out std_logic;
		memRead_exmem_o    : out std_logic;
		memWrite_exmem_o   : out std_logic;
		PCWrite_exmem_o    : out std_logic;

		memToReg_exmem_o   : out std_logic;
		regWrite_exmem_o   : out std_logic;
		branchCond_exmem_o : out branch_condition
	);
end entity EX_MEM;

architecture behaviour of EX_MEM is
	signal pc         : std_logic_vector(31 DOWNTO 0);
	signal alu_result : std_logic_vector(31 DOWNTO 0);
	signal dataAddr   : std_logic_vector(4 downto 0);
	signal adata      : std_logic_vector(31 downto 0);
	signal bdata	  : std_logic_vector(31 downto 0);
	signal neg_flag	  : std_logic;
	signal zero_flag  : std_logic;
	signal branch     : std_logic;
	signal memRead    : std_logic;
	signal memWrite   : std_logic;
	signal pcWrite    : std_logic;
	signal memToReg   : std_logic;
	signal regWrite   : std_logic;
	signal branchC	  : branch_condition;
	signal pcsource   : std_logic_vector(1 DOWNTO 0);
	signal jaddr      : std_logic_vector(31 downto 0);

begin
	EX_MEM_reg : process(clk_i, rst_i, enable_i) is
	begin
		if rst_i = '1' then
			pc         <= (others => '0');
			alu_result <= (others => '0');
			dataAddr   <= (others => '0');
			adata	   <= (others => '0');
			bdata	   <= (others => '0');
			neg_flag   <= '0';
			zero_flag  <= '0';
			branch     <= '0';
			memRead    <= '0';
			memWrite   <= '0';
			pcWrite    <= '0';
			memToReg   <= '0';
			regWrite   <= '0';
			branchC	   <= bc_bne;
			pcsource   <= (others => '0');
			jaddr      <= (others => '0');

		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				pc         <= PC_exmem_i;
				alu_result <= ALU_result_exmem_i;
				adata      <= A_data_exmem_i;
				bdata	   <= B_data_exmem_i;
				neg_flag   <= neg_flag_exmem_i;
				zero_flag  <= zero_flag_exmem_i;
				dataAddr   <= dataAddr_exmem_i;
				branch     <= branch_exmem_i;
				memRead    <= memRead_exmem_i;
				memWrite   <= memWrite_exmem_i;
				pcWrite    <= PCWrite_exmem_i;
				memToReg   <= memToReg_exmem_i;
				regWrite   <= regWrite_exmem_i;
				branchC	   <= branchCond_exmem_i;
				pcsource   <= PCSource_exmem_i;
				jaddr      <= jumpAddr_exmem_i;
			end if;
		end if;
	end process EX_MEM_reg;

	PC_exmem_o         <= pc;
	ALU_result_exmem_o <= alu_result;
	A_data_exmem_o     <= adata;
	B_data_exmem_o	   <= bdata;
	neg_flag_exmem_o   <= neg_flag;
	zero_flag_exmem_o  <= zero_flag;
	branch_exmem_o     <= branch;
	memRead_exmem_o    <= memRead;
	memWrite_exmem_o   <= memWrite;
	PCWrite_exmem_o    <= pcWrite;
	memToReg_exmem_o   <= memToReg;
	regWrite_exmem_o   <= regWrite;
	branchCond_exmem_o <= branchC;
	dataAddr_exmem_o   <= dataAddr;
	PCSource_exmem_o   <= pcsource;
	jumpAddr_exmem_o   <= jaddr;

end architecture;