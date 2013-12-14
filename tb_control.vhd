library ieee;
use ieee.std_logic_1164.all;

entity tb_control is
end tb_control;

architecture tb of tb_control is
	component control
		port(
			rst_i         : in  std_logic;
			op_i          : in  std_logic_vector(5 DOWNTO 0);

			PCWriteCond_o : out std_logic;
			PCWrite_o     : out std_logic;
			IorD_o        : out std_logic;

			branch_o      : out std_logic;
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

	end component control;

	signal RST : std_logic                    := '0';
	signal OP  : std_logic_vector(5 downto 0) := "111111";

	signal PCWRITECOND : std_logic;
	signal PCWRITE     : std_logic;
	signal IORD        : std_logic;

	signal BRANCH   : std_logic;
	signal MEMREAD  : std_logic;
	signal MEMWRITE : std_logic;
	signal MEMTOREG : std_logic;
	signal REGWRITE : std_logic;
	signal ALUOP    : std_logic_vector(1 downto 0);

	signal IRWRITE : std_logic;

	signal PCSOURCE : std_logic_vector(1 downto 0);
	signal ALUSRCB  : std_logic_vector(1 downto 0);
	signal ALUSRCA  : std_logic;
	signal REGDST   : std_logic;

begin
	dut : control
		port map(rst_i         => RST,
			     op_i          => op,
			     PCWriteCond_o => PCWRITECOND,
			     PCWrite_o     => PCWRITE,
			     IorD_o        => IORD,
			     branch_o      => BRANCH,
			     MemRead_o     => MEMREAD,
			     MemWrite_o    => MEMWRITE,
			     MemToReg_o    => MEMTOREG,
			     regWrite_o    => REGWRITE,
			     ALUOp_o       => ALUOP,
			     IRWrite_o     => IRWRITE,
			     PCSource_o    => PCSOURCE,
			     ALUSrcB_o     => ALUSRCB,
			     ALUSrcA_o     => ALUSRCA,
			     RegDst_o      => REGDST
		);

	OP <= "000000" after 50 ns, "100000" after 100 ns;

end architecture;