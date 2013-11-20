library ieee;
use ieee.std_logic_1164.all;

entity ID_EX is			--first pipeline stage with instruction_register
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		enable_i : in std_logic;
		DataA_i : in std_logic_vector(31 downto 0);
		DataB_i : in std_logic_vector(31 downto 0);
		ALU_op_i : in std_logic_vector(1 DOWNTO 0);
		PCSource_i : in std_logic_vector(1 DOWNTO 0);
		PC_i : in std_logic_vector(31 downto 0);
		
		DataA_o : out std_logic_vector(31 downto 0);
		DataB_o : out std_logic_vector(31 downto 0);
		ALU_op_o : out std_logic_vector(1 DOWNTO 0);
		PCSource_o : out std_logic_vector(1 DOWNTO 0);		
		PC_o : out std_logic_vector(31 downto 0)
	);
end entity ID_EX;

architecture behaviour of ID_EX	 is
	signal dataA : std_logic_vector(31 DOWNTO 0);
	signal dataB : std_logic_vector(31 DOWNTO 0);
	signal aluop : std_logic_vector(1 DOWNTO 0);
	signal pcsource : std_logic_vector(1 DOWNTO 0);
	signal pc : std_logic_vector(31 downto 0);
	
begin

ID_EX_reg : process (clk_i, rst_i, enable_i) is
begin
	if rst_i = '1' then
		dataA <= (others => '0');
		dataB <= (others => '0');
		aluop <= (others => '0');
		pcsource <= (others => '0');
		pc <= (others => '0');
	elsif rising_edge(clk_i) then
		if enable_i = '1' then
			dataA <= DataA_i;
			dataB <= DataB_i;
			aluop <= ALU_op_i;
			pcsource <= PCSource_i;
			pc <= PC_i;
		end if;
	end if;
end process ID_EX_reg;	

DataA_o <= dataA;
DataB_o <= dataB;
ALU_op_o <= aluop;
PCSource_o <= pcsource;
PC_o <= pc;

end architecture;