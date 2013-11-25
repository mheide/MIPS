library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is			--first pipeline stage with instruction_register
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		enable_i : in std_logic;
		PC_exmem_i : in std_logic_vector(31 downto 0);
		ALU_result_exmem_i : in std_logic_vector(31 downto 0);
		zero_flag_exmem_i : in std_logic;
		dataAddr_exmem_i : in std_logic_vector(4 downto 0);	
		
		branch_exmem_i : in std_logic;		--M
		memRead_exmem_i : in std_logic;
		memWrite_exmem_i : in std_logic;
		
		memToReg_exmem_i : in std_logic;		--WB
		regWrite_exmem_i : in std_logic;
		
		PC_exmem_o : out std_logic_vector(31 downto 0);
		ALU_result_exmem_o : out std_logic_vector(31 downto 0);
		zero_flag_exmem_o : out std_logic;
		dataAddr_exmem_o : out std_logic_vector(4 downto 0);	
			
		branch_exmem_o : out std_logic;		
		memRead_exmem_o : out std_logic;
		memWrite_exmem_o : out std_logic;	

		memToReg_exmem_o : out std_logic;	
		regWrite_exmem_o : out std_logic
	);
end entity EX_MEM;

architecture behaviour of EX_MEM	 is
signal pc : std_logic_vector(31 DOWNTO 0);
signal alu_result : std_logic_vector(31 DOWNTO 0);
signal dataAddr : std_logic_vector(4 downto 0);
signal zero_flag : std_logic;
signal branch : std_logic;	
signal memRead : std_logic;	
signal memWrite : std_logic;	
signal memToReg : std_logic;	
signal regWrite : std_logic;

begin

EX_MEM_reg : process (clk_i, rst_i, enable_i) is
begin
	if rst_i = '1' then
		pc <= (others => '0');		
		alu_result <= (others => '0');
		dataAddr <= (others => '0');
		zero_flag <= '0';
		branch <= '0';
		memRead <= '0';
		memWrite <= '0';
		memToReg <= '0';
		regWrite <= '0';
		
	elsif rising_edge(clk_i) then
		if enable_i = '1' then
			pc <= PC_exmem_i;
			alu_result <= ALU_result_exmem_i;
			zero_flag <= zero_flag_exmem_i;
			dataAddr <= dataAddr_exmem_i;
			branch <= branch_exmem_i;
			memRead <= memRead_exmem_i;
			memWrite <= memWrite_exmem_i;
			memToReg <= memToReg_exmem_i;
			regWrite <= regWrite_exmem_i;
		end if;
	end if;
end process EX_MEM_reg;	

PC_exmem_o <= pc;
ALU_result_exmem_o <= alu_result;
zero_flag_exmem_o <= zero_flag;
branch_exmem_o   <= branch;
memRead_exmem_o  <= memRead; 
memWrite_exmem_o <= memWrite;
memToReg_exmem_o  <= memToReg;
regWrite_exmem_o  <= regWrite;
dataAddr_exmem_o <= dataAddr;
end architecture;