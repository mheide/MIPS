library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity Control is
	port(
		rst_i         : in  std_logic;
		op_i          : in  std_logic_vector(5 DOWNTO 0);

		PCWriteCond_o : out std_logic;
		PCWrite_o     : out std_logic;
		IorD_o        : out std_logic;

       --PCSource replace jump and branch in multicycle implementation (Page 324)
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
	op         <= op_i;
	ALUOp_o    <= "10" when op = "000000" else
	                    "10" when op = "000010" else
						"00" when op = "100011" else
						"00" when op = "101011" else
						(others => '0');
	ALUSrcB_o  <= "00" when op = "000000" else 
						"10" when op = "100011" else
						"10" when op = "101011" else
						(others => '0');
	ALUSrcA_o  <= '1' when op = "000000" else
						'1' when op = "100011" else
						'1' when op = "101011" else
						'0';
	MemWrite_o <= '0' when op = "000000" else 
						'0' when op = "100011" else
						'1' when op = "101011" else
						'0';
	MemRead_o <= '0'  when op = "000000" else
						'1' when op = "100011" else
						'0' when op = "101011" else
						'0';
	--TODO: some PCSource_o values not sane
	PCSource_o <=       "01" when op = c_beq.opcode  else
	                    "01" when op = c_bgez.opcode else
	                    "01" when op = c_bgezal else
	                    "01" when op = c_bgtz else
	                    "01" when op = c_blez else
	                    "01" when op = c_bltzal else
	                    "01" when op = c_bne else
	                    "01" when op = c_bltz else
						"01" when op = c_lw else
						"01" when op = c_lwl else
						"01" when op = c_lwr else
						"01" when op = c_lb else
						"01" when op = c_lbu else
						"01" when op = c_lh else
						"01" when op = c_lhu else
						"01" when op = c_ll else
						"01" when op = c_sw else
						"01" when op = c_sb else
						"01" when op = c_sc else
						"01" when op = c_sh else
						"01" when op = c_swl else
						"01" when op = c_swr else
						"10" when op = c_j else --jump
						"10" when op = c_jal else --jump and link
						(others => '0');
	RegDst_o   <= '1' when op = "000000" else 
						'0' when op = "100011" else
						'-' when op = "101011" else
						'0';
	regWrite_o <= '1' when op = "000000" else 
						'1' when op = "100011" else
						'0' when op = "101011" else
						'0';
	MemToReg_o <= '0' when op = "000000" else
						'1' when op = "100011" else
						'-' when op = "101011" else
						'0';

end architecture;