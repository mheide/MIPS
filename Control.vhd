library ieee;
use ieee.std_logic_1164.all;

entity Control is
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		op_i : in std_logic_vector(5 DOWNTO 0);
		
		PCWriteCond : out std_logic;
		PCWrite : out std_logic;
		IorD : out std_logic;
		MemRead : out std_logic;
		MemWrite : out std_logic;
		MemToReg : out std_logic;
		IRWrite : out std_logic;

		PCSource : out std_logic_vector(1 DOWNTO 0);
		ALUOp : out std_logic_vector(1 DOWNTO 0);
		ALUSrcB : out std_logic_vector(1 DOWNTO 0);
		
		ALUSrcA : out std_logic;
		RegWrite : out std_logic;
		RegDat : out std_logic
	);
end entity Control;

architecture behaviour of Control is
begin
	
	
	ALUOp <= "01" when op_i = "000000" else
					(others => '0');
	ALUSrcB <= "00" when op_i = "000000" else
					(others => '0');	
	ALUSrcA <= '1' when op_i = "000000" else
					(others => '0');
	MemWrite <= '0' when op_i = "000000" else
					(others => '0');
	PCSource <= "10" when op_i = "000000" else
					(others => '0');
					
end architecture;