library ieee;
use ieee.std_logic_1164.all;

entity ID_EX is			--first pipeline stage with instruction_register
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		enable_i : in std_logic;
		DataA_idex_i : in std_logic_vector(31 downto 0);
		DataB_idex_i : in std_logic_vector(31 downto 0);
		PCSource_idex_i : in std_logic_vector(1 DOWNTO 0);
		PC_idex_i : in std_logic_vector(31 downto 0);
		dataAddr_idex_i : in std_logic_vector(4 downto 0);	--for r-type: destination address (register)
		
		regDst_idex_i : in std_logic;		--EX
		ALUSrcB_idex_i : out std_logic_vector(1 DOWNTO 0);		
		ALUSrcA_idex_i : out std_logic;			
		ALU_op_idex_i : in std_logic_vector(1 DOWNTO 0); 		

		branch_idex_i : in std_logic;		--M
		memRead_idex_i : in std_logic;
		memWrite_idex_i : in std_logic;
		
		memToReg_idex_i : in std_logic;		--WB
		regWrite_idex_i : in std_logic;
		
		DataA_idex_o : out std_logic_vector(31 downto 0);
		DataB_idex_o : out std_logic_vector(31 downto 0);
		PCSource_idex_o : out std_logic_vector(1 DOWNTO 0);		
		PC_idex_o : out std_logic_vector(31 downto 0);
		dataAddr_idex_o : out std_logic_vector(4 downto 0);
		ALU_op_idex_o : out std_logic;
		regDst_idex_o : out std_logic;
		ALUSrcB_idex_o : out std_logic_vector(1 DOWNTO 0);		
		ALUSrcA_idex_o : out std_logic;	
		
		branch_idex_o : out std_logic;		
		memRead_idex_o : out std_logic;
		memWrite_idex_o : out std_logic;	

		memToReg_idex_o : out std_logic;		--WB
		regWrite_idex_o : out std_logic		
	);
end entity ID_EX;

architecture behaviour of ID_EX	 is
	signal dataA : std_logic_vector(31 DOWNTO 0);
	signal dataB : std_logic_vector(31 DOWNTO 0);
	signal aluop : std_logic_vector(1 DOWNTO 0);
	signal pcsource : std_logic_vector(1 DOWNTO 0);
	signal pc : std_logic_vector(31 downto 0);
	signal dataAddr : std_logic_vector(4 downto 0);
	
	signal regDst : std_logic;
	signal aluSrcA : std_logic;	
	signal aluSrcB : std_logic_vector(1 DOWNTO 0);	
	signal branch : std_logic;	
	signal memRead : std_logic;	
	signal memWrite : std_logic;	
	signal memToReg : std_logic;	
	signal regWrite : std_logic;		
	
begin

ID_EX_reg : process (clk_i, rst_i, enable_i) is
begin
	if rst_i = '1' then
		dataA <= (others => '0');
		dataB <= (others => '0');
		aluop <= (others => '0');
		pcsource <= (others => '0');
		pc <= (others => '0');
		dataAddr <= (others => '0');
		
		aluSrcB <= (others => '0');
		regDst <= '0';
		aluSrcA <= '0';
		branch <= '0';
		memRead <= '0';
		memWrite <= '0';
		memToReg <= '0';
		regWrite <= '0';
		
	elsif rising_edge(clk_i) then
		if enable_i = '1' then
			dataA <= DataA_idex_i;
			dataB <= DataB_idex_i;
			aluop <= ALU_op_idex_i;
			pcsource <= PCSource_idex_i;
			pc <= PC_idex_i;
			dataAddr <= dataAddr_idex_i;
			
			aluSrcB <= aluSrcB_idex_i;
			regDst <= regDst_idex_i;
			aluSrcA <= aluSrcA_idex_i;
			branch <= branch_idex_i;
			memRead <= memRead_idex_i;
			memWrite <= memWrite_idex_i;
			memToReg <= memToReg_idex_i;
			regWrite <= regWrite_idex_i;
			
		end if;
	end if;
end process ID_EX_reg;	

DataA_idex_o <= dataA;
DataB_idex_o <= dataB;
ALU_op_idex_o <= aluop;
PCSource_idex_o <= pcsource;
PC_idex_o <= pc;
dataAddr_idex_o <= dataAddr;

regDst_idex_o <= regDst;
ALUSrcB_idex_o <= aluSrcB;
ALUSrcA_idex_o <= aluSrcA;

branch_idex_o <= branch;
memRead_idex_o <= memRead;
memWrite_idex_o <= memWrite;
memToReg_idex_o <= memToReg;
regWrite_idex_o <= regWrite;

end architecture;