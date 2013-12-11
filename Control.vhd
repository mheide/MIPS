library ieee;
use ieee.std_logic_1164.all;

entity Control is
	port(
			rst_i         : in  std_logic;
			op_i          : in  std_logic_vector(5 DOWNTO 0);

			PCWriteCond_o : out std_logic;
			PCWrite_o     : out std_logic;
			IorD_o        : out std_logic;
			
			branch_o 	  : out std_logic;			
			MemRead_o     : out std_logic;
			MemWrite_o    : out std_logic;
			MemToReg_o    : out std_logic;
			regWrite_o    : out std_logic;
			ALUOp_o       : out std_logic_vector(1 DOWNTO 0);			
			
			IRWrite_o     : out std_logic;

			PCSource_o    : out std_logic_vector(1 DOWNTO 0);
			ALUSrcB_o     : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_o     : out std_logic;
			RegDst_o      : out std_logic
	);
end entity Control;

architecture behaviour of Control is
	signal op : std_logic_vector(5 downto 0);
begin
	
	op <= op_i;
	ALUOp_o    <= "10" when op = "000000" else (others => '0');
	ALUSrcB_o  <= "00" when op = "000000" else (others => '0');
	ALUSrcA_o  <= '1' when op = "000000" else '0';
	MemWrite_o <= '0' when op = "000000" else '0';
	PCSource_o <= "10" when op = "000000" else (others => '0');
	RegDst_o   <= '1' when op = "000000" else '0';

end architecture;