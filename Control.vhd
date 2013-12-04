library ieee;
use ieee.std_logic_1164.all;

entity Control is
	port(
		clk_i       : in  std_logic;
		rst_i       : in  std_logic;
		op_i        : in  std_logic_vector(5 DOWNTO 0);

		PCWriteCond : out std_logic;
		PCWrite     : out std_logic;
		IorD        : out std_logic;
		MemRead     : out std_logic;
		MemWrite    : out std_logic;
		MemToReg    : out std_logic;
		IRWrite     : out std_logic;

		PCSource    : out std_logic_vector(1 DOWNTO 0);
		ALUOp       : out std_logic_vector(1 DOWNTO 0);
		ALUSrcB     : out std_logic_vector(1 DOWNTO 0);

		ALUSrcA     : out std_logic;
		RegWrite    : out std_logic;
		RegDst      : out std_logic
	);
end entity Control;

architecture behaviour of Control is
	signal op : std_logic_vector(5 downto 0);
begin
	ALUOp    <= "10" when op = "000000" else (others => '0');
	ALUSrcB  <= "00" when op = "000000" else (others => '0');
	ALUSrcA  <= '1' when op = "000000" else '0';
	MemWrite <= '0' when op = "000000" else '0';
	PCSource <= "10" when op = "000000" else (others => '0');
	RegDst   <= '1' when op = "000000" else '0';

end architecture;