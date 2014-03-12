library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity TOP_Lvl is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	--enable_i : in std_logic
	);
end entity TOP_Lvl;

architecture RTL of TOP_Lvl is
	component ALU
		port(
			rst_i      : in  std_logic;
			A_i        : in  std_logic_vector(31 downto 0);
			B_i        : in  std_logic_vector(31 downto 0);
			ALU_ctrl_i : in  alu_code;
			shamt_i    : in  std_logic_vector(4 downto 0);

			C_o        : out std_logic_vector(31 downto 0);
			zero_o     : out std_logic
		);
	end component ALU;

	component ALU_Control
		port(
			rst_i          : in  std_logic;
			ALU_Op_i       : in  std_logic_vector(1 downto 0);
			functioncode_i : in  std_logic_vector(5 downto 0);
			op_i           : in  std_logic_vector(5 downto 0);
			alu_code_o     : out alu_code
		);
	end component ALU_Control;

	component RegisterFile
		port(
			clk_i        : in  std_logic;
			rst_i        : in  std_logic;

			data_i       : in  std_logic_vector(31 downto 0);
			dataAddr_i   : in  std_logic_vector(4 downto 0);
			dataA_Addr_i : in  std_logic_vector(4 downto 0); --rs
			dataB_Addr_i : in  std_logic_vector(4 downto 0); --rt


			regWrite_i   : in  std_logic;

			dataA_o      : out std_logic_vector(31 downto 0);
			dataB_o      : out std_logic_vector(31 downto 0)
		);
	end component;

	component Control
		port(
			clk_i         : in  std_logic;
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
			JorB_o        : out std_logic;
			ALUOp_o       : out std_logic_vector(1 DOWNTO 0);
			IRWrite_o     : out std_logic;
			PCSource_o    : out std_logic_vector(1 downto 0);
			ALUSrcB_o     : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_o     : out std_logic;
			RegDst_o      : out std_logic_vector(1 downto 0);
			enable_o      : out std_logic
		);
	end component;

	component regDstSelect
		port(
			regDst_i            : in  std_logic_vector(1 downto 0);
			instruction_20_16_i : in  std_logic_vector(4 DOWNTO 0);
			instruction_15_11_i : in  std_logic_vector(4 DOWNTO 0);

			instruction_o       : out std_logic_vector(4 DOWNTO 0)
		);
	end component;

	component ID_EX
		port(
			clk_i                    : in  std_logic;
			rst_i                    : in  std_logic;
			enable_i                 : in  std_logic;
			PCSource_idex_i          : in  std_logic_vector(1 downto 0);
			PC_idex_i                : in  std_logic_vector(31 downto 0);
			dataAddr_idex_i          : in  std_logic_vector(4 downto 0); --for r-type: destination address (register)


			ALUSrcB_idex_i           : in  std_logic_vector(1 DOWNTO 0); --EX
			ALUSrcA_idex_i           : in  std_logic;
			dataA_idex_i             : in  std_logic_vector(31 downto 0);
			dataB_idex_i             : in  std_logic_vector(31 downto 0);
			ALU_op_idex_i            : in  std_logic_vector(1 DOWNTO 0);
			function_code_idex_i     : in  std_logic_vector(5 DOWNTO 0);
			signExtAddr_idex_i       : in  std_logic_vector(9 DOWNTO 0);
			op_idex_i                : in  std_logic_vector(5 downto 0);
			instruction_25_16_idex_i : in  std_logic_vector(9 downto 0);
			instruction_25_0_i       : in  std_logic_vector(25 downto 0);

			memRead_idex_i           : in  std_logic;
			memWrite_idex_i          : in  std_logic;

			memToReg_idex_i          : in  std_logic; --WB
			regWrite_idex_i          : in  std_logic;

			PCSource_idex_o          : out std_logic_vector(1 downto 0);
			PC_idex_o                : out std_logic_vector(31 downto 0);
			dataAddr_idex_o          : out std_logic_vector(4 downto 0);

			ALUSrcB_idex_o           : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_idex_o           : out std_logic;
			dataA_idex_o             : out std_logic_vector(31 downto 0);
			dataB_idex_o             : out std_logic_vector(31 downto 0);
			ALU_op_idex_o            : out std_logic_vector(1 DOWNTO 0);
			function_code_idex_o     : out std_logic_vector(5 DOWNTO 0);
			signExtAddr_idex_o       : out std_logic_vector(9 DOWNTO 0);
			op_idex_o                : out std_logic_vector(5 downto 0);
			instruction_25_16_idex_o : out std_logic_vector(9 downto 0);
			instruction_25_0_o       : out std_logic_vector(25 downto 0);

			memRead_idex_o           : out std_logic;
			memWrite_idex_o          : out std_logic;

			memToReg_idex_o          : out std_logic; --WB
			regWrite_idex_o          : out std_logic
		);
	end component;

	component EX_MEM
		port(
			clk_i              : in  std_logic;
			rst_i              : in  std_logic;
			enable_i           : in  std_logic;
			PC_exmem_i         : in  std_logic_vector(31 downto 0);
			ALU_result_exmem_i : in  std_logic_vector(31 downto 0);
			ALUdataA_exmem_i   : in  std_logic_vector(31 downto 0);
			--B_data_exmem_i     : in  std_logic_vector(31 downto 0);
			zero_flag_exmem_i  : in  std_logic;
			dataAddr_exmem_i   : in  std_logic_vector(4 downto 0);
			PCSource_exmem_i   : in  std_logic_vector(1 DOWNTO 0);
			offset_exmem_i     : in  std_logic_vector(25 downto 0);

			branch_exmem_i     : in  std_logic; --M
			memRead_exmem_i    : in  std_logic;
			memWrite_exmem_i   : in  std_logic;

			memToReg_exmem_i   : in  std_logic; --WB
			regWrite_exmem_i   : in  std_logic;

			PC_exmem_o         : out std_logic_vector(31 downto 0);
			ALU_result_exmem_o : out std_logic_vector(31 downto 0);
			ALUdataA_exmem_o   : out std_logic_vector(31 downto 0);
			--B_data_exmem_o     : out std_logic_vector(31 downto 0);
			zero_flag_exmem_o  : out std_logic;
			dataAddr_exmem_o   : out std_logic_vector(4 downto 0);
			PCSource_exmem_o   : out std_logic_vector(1 DOWNTO 0);
			offset_exmem_o     : out std_logic_vector(25 downto 0);

			branch_exmem_o     : out std_logic;
			memRead_exmem_o    : out std_logic;
			memWrite_exmem_o   : out std_logic;

			memToReg_exmem_o   : out std_logic;
			regWrite_exmem_o   : out std_logic
		);
	end component;

	component MEM_WB
		port(
			clk_i                  : in  std_logic;
			rst_i                  : in  std_logic;
			enable_i               : in  std_logic;
			ALU_result_memwb_i     : in  std_logic_vector(31 downto 0);
			dataAddr_memwb_i       : in  std_logic_vector(4 downto 0);

			memToReg_memwb_i       : in  std_logic; --WB
			regWrite_memwb_i       : in  std_logic;

			memoryReadData_memwb_o : out std_logic_vector(31 downto 0);
			ALU_result_memwb_o     : out std_logic_vector(31 downto 0);
			dataAddr_memwb_o       : out std_logic_vector(4 downto 0);

			memToReg_memwb_o       : out std_logic;
			regWrite_memwb_o       : out std_logic
		);
	end component;

	component IF_ID
		port(
			clk_i         : in  std_logic;
			rst_i         : in  std_logic;
			enable_i      : in  std_logic;
			PC_ifid_i     : in  std_logic_vector(31 downto 0);

			Instruction_o : out std_logic_vector(31 DOWNTO 0);
			PC_ifid_o     : out std_logic_vector(31 downto 0)
		);
	end component;

	component pc_counter is
		port(
			clk_i      : in  std_logic;
			rst_i      : in  std_logic;
			pcSource_i : in  std_logic;
			enable_i   : in  std_logic;
			PC_jump_i  : in  std_logic_vector(31 DOWNTO 0);
			PC_o       : out std_logic_vector(31 downto 0)
		);
	end component;

	component PCSourceMUX
		port(rst_i      : in  std_logic;
			 pcSource_i : in  std_logic;
			 PC_i       : in  std_logic_vector(31 downto 0);
			 PC_jump_i  : in  std_logic_vector(31 downto 0);
			 PC_o       : out std_logic_vector(31 downto 0));
	end component PCSourceMUX;

	component jumpAddressSelect is
		port(
			rst_i         : in  std_logic;
			PCSource_i    : in  std_logic_vector(1 DOWNTO 0);
			ALU_result    : in  std_logic_vector(31 DOWNTO 0);
			ALU_zero_i    : in  std_logic;
			PC_modified   : in  std_logic_vector(31 DOWNTO 0);
			pc_from_reg_i : in  std_logic_vector(31 downto 0);

			jumpAddress_o : out std_logic_vector(31 DOWNTO 0);
			PCSource_o    : out std_logic
		);
	end component;

	component dataSelect is
		port(
			ALU_result_i     : in  std_logic_vector(31 downto 0);
			memoryReadData_i : in  std_logic_vector(31 downto 0);
			memToReg_i       : in  std_logic;

			data_o           : out std_logic_vector(31 downto 0)
		);
	end component;

	component signExtend is
		port(
			address_i : in  std_logic_vector(15 downto 0);

			address_o : out std_logic_vector(31 downto 0)
		);
	end component;

	component operandSelect is
		port(
			ALUSrcA_i   : in  std_logic;
			ALUSrcB_i   : in  std_logic_vector(1 DOWNTO 0);

			PC_A_i      : in  std_logic_vector(31 DOWNTO 0);
			RF_A_i      : in  std_logic_vector(31 DOWNTO 0);

			RF_B_i      : in  std_logic_vector(31 DOWNTO 0);
			SignExt_B_i : in  std_logic_vector(31 DOWNTO 0);

			A_o         : out std_logic_vector(31 DOWNTO 0);
			B_o         : out std_logic_vector(31 DOWNTO 0)
		);
	end component;

	component DataMemory is
		generic(
			size : natural := 8         --number of instructions
		);
		port(
			clk_i        : in  std_logic;
			rst_i        : in  std_logic;
			alu_result_i : in  std_logic_vector(31 DOWNTO 0);
			writeData_i  : in  std_logic_vector(31 DOWNTO 0);
			memWrite_i   : in  std_logic; --0 for arithmetic op's
			memRead_i    : in  std_logic;

			readData_o   : out std_logic_vector(31 DOWNTO 0)
		);
	end component;

	component JumpAddrCompute
		port(jumpAddr_i : in  std_logic_vector(25 downto 0);
			 pc_i       : in  std_logic_vector(31 downto 0);
			 pc_o       : out std_logic_vector(31 downto 0));
	end component JumpAddrCompute;

	signal reset  : std_logic;
	signal clock  : std_logic;
	signal enable : std_logic;

	--exmem --> pc --beide nicht angekommen
	signal zero_exmem_pc   : std_logic;
	signal branch_exmem_pc : std_logic; -- noch mal sichergehen wie genau (PCSource?)
	signal B_data_exmem_dm : std_logic_vector(31 downto 0);
	signal PC_exmem_jus    : std_logic_vector(31 downto 0);

	--exmem --> memwb
	signal memToReg_exmem_memwb : std_logic;
	signal regWrite_exmem_memwb : std_logic;

	--exmem --> jas
	signal PCSrc_exmem_jas       : std_logic_vector(1 downto 0);
	signal pc_from_reg_exmem_jas : std_logic_vector(31 downto 0);

	--obsolete!
	--exmem --> jac 
	--signal offset_exmem_jac : std_logic_vector(25 downto 0);

	--jac --> exmem
	signal PC_jac_exmem : std_logic_vector(31 downto 0);

	--exmem --> dataMemory
	signal memRead_exmem_dm    : std_logic;
	signal memWrite_exmem_dm   : std_logic;
	signal ALU_result_exmem_dm : std_logic_vector(31 downto 0);

	--exmem --> regDstSelect, memwb
	signal dataAddr_exmem_rds : std_logic_vector(4 downto 0);

	--idex --> exmem
	signal PCSrc_idex_exmem             : std_logic_vector(1 downto 0);
	signal PC_idex_exmem                : std_logic_vector(31 downto 0);
	signal branch_idex_exmem            : std_logic;
	signal memRead_idex_exmem           : std_logic;
	signal memWrite_idex_exmem          : std_logic;
	signal memToReg_idex_exmem          : std_logic;
	signal regWrite_idex_exmem          : std_logic;
	signal dataAddr_idex_exmem          : std_logic_vector(4 downto 0);
	signal instruction_25_16_idex_exmem : std_logic_vector(9 downto 0);
	signal offset_idex_exmem            : std_logic_vector(25 downto 0);

	--alu --> exmem
	signal zero_alu_exmem : std_logic;
	signal C_alu_exmem    : std_logic_vector(31 downto 0);

	--obsolete!
	--rf --> alu 
	--signal dataA_rf_alu : std_logic_vector(31 downto 0);
	--signal dataB_rf_alu : std_logic_vector(31 downto 0);

	--rf --> idex
	signal dataA_rf_idex : std_logic_vector(31 downto 0);
	signal dataB_rf_idex : std_logic_vector(31 downto 0);

	--idex --> os
	signal dataA_idex_os : std_logic_vector(31 downto 0);
	signal dataB_idex_os : std_logic_vector(31 downto 0);

	--ac --> alu
	signal alu_code_ac_alu : alu_code;

	-- idex --> ac
	signal alu_op_idex_ac       : std_logic_vector(1 downto 0);
	signal functioncode_idex_ac : std_logic_vector(5 downto 0);
	signal op_idex_ac           : std_logic_vector(5 downto 0);

	-- regDstSelect --> rf
	signal dst_Addr_rds_rf : std_logic_vector(4 downto 0);

	--ifid --> rf, ctrl, regDstSelect, idex
	signal data_ifid_rf : std_logic_vector(31 downto 0);

	--idex --> operandselect
	signal ALUSrcA_idex_os : std_logic;
	signal ALUSrcB_idex_os : std_logic_vector(1 downto 0);

	--TODO: dataAddr_memwb_o: sinnvoll machen, oder vielleicht nicht gebraucht? DOCH	
	signal dataAddr_memwb_rf : std_logic_vector(4 downto 0);

	--ctrl --> idex
	signal ALUSrcA_ctrl_idex  : std_logic;
	signal ALUSrcB_ctrl_idex  : std_logic_vector(1 downto 0);
	signal PCSource_ctrl_idex : std_logic_vector(1 downto 0);
	signal memRead_ctrl_idex  : std_logic;
	signal memWrite_ctrl_idex : std_logic;
	signal memToReg_ctrl_idex : std_logic;
	signal regWrite_ctrl_idex : std_logic;
	signal ALUop_ctrl_idex    : std_logic_vector(1 downto 0);

	--ctrl --> regDstSelect
	signal regDst_ctrl_rds : std_logic_vector(1 downto 0);

	--ifid --> idex
	signal PC_ifid_idex : std_logic_vector(31 downto 0);

	--pc --> ifid --writedata fehlt
	signal address_pc_pcsrcmux : std_logic_vector(31 downto 0) := (others => '0');

	--pcsrcmux --> ifid
	signal address_pcsrcmux_ifid : std_logic_vector(31 downto 0);

	--memwb --> jumpAddressSeelct, ds
	signal ALU_result_memwb_ds : std_logic_vector(31 downto 0);

	--exmem --> jumpAddressSelect
	signal PC_exmem_jas       : std_logic_vector(31 downto 0);
	signal ALUdataA_exmem_jas : std_logic_vector(31 downto 0);

	--dm --> jumpadressselect? ds, 
	signal memData_dm_jas : std_logic_vector(31 downto 0);

	--idex --> signExtend
	signal signExtAddr_idex_se          : std_logic_vector(9 downto 0);
	signal signExtAddr_complete_idex_se : std_logic_vector(15 downto 0);

	--idex --> jac
	signal instr_25_0_idex_jac : std_logic_vector(25 downto 0);

	--memwb --> ds		
	signal memToReg_memwb_ds : std_logic;

	--memwb --> rf
	signal regWrite_memwb_rf : std_logic;

	--obsolete!!!
	--jas --> PC
	--signal jumpAddress_jas_pc : std_logic_vector(31 downto 0);

	--jac --> exmem
	--signal PC_jac_exmem : std_logic_vector(31 downto 0);

	--jas --> PCSrcMUX
	signal jumpAddress_jas_pc : std_logic_vector(31 downto 0) := (others => '0');
	signal pcsrc_jas_pc       : std_logic                     := '0';

	--pcsrcmux --> ifid
	signal jumpAddress_pc_ifid : std_logic_vector(31 downto 0) := (others => '0');

	--ds --> rf
	signal data_ds_rf : std_logic_vector(31 downto 0);

	--se --> alusourcebselect
	signal signExtend_se_os : std_logic_vector(31 downto 0);

	--os --> alu
	signal dataA_os_alu : std_logic_vector(31 downto 0);
	signal dataB_os_alu : std_logic_vector(31 downto 0);

begin
	--pc: PCSource unnoetig, da jumpaddressselect?

	clock <= clk_i;
	reset <= rst_i;
	--enable <= enable_i;

	--nice to have: make it clearer
	signExtAddr_complete_idex_se <= signExtAddr_idex_se & functioncode_idex_ac;
	offset_idex_exmem            <= instruction_25_16_idex_exmem & signExtAddr_complete_idex_se;

	ds : dataSelect
		port map(ALU_result_i     => ALU_result_memwb_ds,
			     memoryReadData_i => memData_dm_jas,
			     memToReg_i       => memToReg_memwb_ds,
			     data_o           => data_ds_rf
		);

	pc : pc_counter
		port map(clk_i      => clock,
			     rst_i      => reset,
			     pcSource_i => pcsrc_jas_pc,
			     enable_i   => enable,
			     PC_jump_i  => jumpAddress_jas_pc,
			     PC_o       => jumpAddress_pc_ifid);

	--PCSrcMUX : PCSourceMUX port map(
	--		rst_i      => reset,
	--		pcSource_i => pcsrc_jas_pc,
	--		PC_i       => address_pc_pcsrcmux,
	--		PC_jump_i  => jumpAddress_jas_pcsrcmux,
	--		PC_o       => jumpAddress_pcsrcmux_ifid
	--	);

	jas : jumpAddressSelect
		port map(rst_i         => reset,
			     PCSource_i    => PCSrc_exmem_jas,
			     ALU_result    => ALU_result_exmem_dm,
			     PC_modified   => PC_exmem_jas,
			     pc_from_reg_i => ALUdataA_exmem_jas,
			     ALU_zero_i    => zero_exmem_pc,
			     jumpAddress_o => jumpAddress_jas_pc,
			     PCSource_o    => pcsrc_jas_pc);

	memwb : MEM_WB
		port map(clk_i              => clock,
			     rst_i              => reset,
			     enable_i           => enable,
			     ALU_result_memwb_i => ALU_result_exmem_dm,
			     dataAddr_memwb_i   => dataAddr_exmem_rds,
			     memToReg_memwb_i   => memToReg_exmem_memwb,
			     regWrite_memwb_i   => regWrite_exmem_memwb,
			     ALU_result_memwb_o => ALU_result_memwb_ds,
			     dataAddr_memwb_o   => dataAddr_memwb_rf,
			     memToReg_memwb_o   => memToReg_memwb_ds,
			     regWrite_memwb_o   => regWrite_memwb_rf);

	jac : JumpAddrCompute
		port map(jumpAddr_i => instr_25_0_idex_jac,
			     pc_i       => PC_idex_exmem,
			     pc_o       => PC_jac_exmem);

	ifid : IF_ID
		port map(clk_i         => clock,
			     rst_i         => reset,
			     enable_i      => enable,
			     PC_ifid_i     => jumpAddress_pc_ifid,
			     Instruction_o => data_ifid_rf,
			     PC_ifid_o     => PC_ifid_idex);

	idex : ID_EX
		port map(clk_i                    => clock,
			     rst_i                    => reset,
			     enable_i                 => enable,
			     PCSource_idex_i          => PCSource_ctrl_idex,
			     PC_idex_i                => PC_ifid_idex,
			     dataAddr_idex_i          => dst_Addr_rds_rf,
			     ALUSrcB_idex_i           => ALUSrcB_ctrl_idex,
			     ALUSrcA_idex_i           => ALUSrcA_ctrl_idex,
			     dataA_idex_i             => dataA_rf_idex,
			     dataB_idex_i             => dataB_rf_idex,
			     ALU_op_idex_i            => ALUop_ctrl_idex,
			     function_code_idex_i     => data_ifid_rf(5 downto 0),
			     signExtAddr_idex_i       => data_ifid_rf(15 downto 6),
			     op_idex_i                => data_ifid_rf(31 downto 26),
			     instruction_25_16_idex_i => data_ifid_rf(25 downto 16),
			     instruction_25_0_i       => data_ifid_rf(25 downto 0),
			     memRead_idex_i           => memRead_ctrl_idex,
			     memWrite_idex_i          => memWrite_ctrl_idex,
			     memToReg_idex_i          => memToReg_ctrl_idex,
			     regWrite_idex_i          => regWrite_ctrl_idex,
			     PCSource_idex_o          => PCSrc_idex_exmem,
			     PC_Idex_o                => PC_idex_exmem,
			     dataAddr_idex_o          => dataAddr_idex_exmem,
			     ALUSrcB_idex_o           => ALUSrcB_idex_os,
			     ALUSrcA_idex_o           => ALUSrcA_idex_os,
			     dataA_idex_o             => dataA_idex_os,
			     dataB_idex_o             => dataB_idex_os,
			     ALU_op_idex_o            => alu_op_idex_ac,
			     function_code_idex_o     => functioncode_idex_ac,
			     signExtAddr_idex_o       => signExtAddr_idex_se,
			     op_idex_o                => op_idex_ac,
			     instruction_25_16_idex_o => instruction_25_16_idex_exmem,
			     instruction_25_0_o       => instr_25_0_idex_jac,
			     memRead_idex_o           => memRead_idex_exmem,
			     memWrite_idex_o          => memWrite_idex_exmem,
			     memToReg_idex_o          => memToReg_idex_exmem,
			     regWrite_idex_o          => regWrite_idex_exmem);

	rds : regDstSelect
		port map(regDst_i            => regDst_ctrl_rds,
			     instruction_20_16_i => data_ifid_rf(20 downto 16),
			     instruction_15_11_i => data_ifid_rf(15 downto 11),
			     instruction_o       => dst_Addr_rds_rf);

	ctrl : Control
		port map(clk_i      => clock,
			     rst_i      => reset,
			     op_i       => data_ifid_rf(31 downto 26),
			     PCWriteCond_o => open,
			     PCWrite_o => open,
			     IorD_o    => open,
			     branch_o  => open,
			     MemRead_o  => memRead_ctrl_idex,
			     MemWrite_o => memWrite_ctrl_idex,
			     MemToReg_o => memToReg_ctrl_idex,
			     regWrite_o => regWrite_ctrl_idex,
			     JorB_o     => open,
			     ALUOp_o    => ALUop_ctrl_idex,
			     IRWrite_o  => open,
			     PCSource_o => PCSource_ctrl_idex,
			     ALUSrcB_o  => ALUSrcB_ctrl_idex,
			     ALUSrcA_o  => ALUSrcA_ctrl_idex,
			     RegDst_o   => regDst_ctrl_rds,
			     enable_o   => enable);

	rf : RegisterFile
		port map(clk_i        => clock,
			     rst_i        => reset,
			     data_i       => data_ds_rf,
			     dataAddr_i   => dataAddr_memwb_rf,
			     dataA_Addr_i => data_ifid_rf(25 downto 21),
			     dataB_Addr_i => data_ifid_rf(20 downto 16),
			     regWrite_i   => regWrite_memwb_rf,
			     dataA_o      => dataA_rf_idex,
			     dataB_o      => dataB_rf_idex);

	exmem : EX_MEM
		port map(clk_i              => clock,
			     rst_i              => reset,
			     enable_i           => enable,
			     PC_exmem_i         => PC_jac_exmem,
			     PCSource_exmem_i   => PCSrc_idex_exmem,
			     offset_exmem_i     => offset_idex_exmem,
			     ALU_result_exmem_i => C_alu_exmem,
			     ALUdataA_exmem_i   => dataA_idex_os,
			     --B_data_exmem_i   => dataB_rf_alu,
			     zero_flag_exmem_i  => zero_alu_exmem,
			     dataAddr_exmem_i   => dataAddr_idex_exmem,
			     branch_exmem_i     => branch_idex_exmem,
			     memRead_exmem_i    => memRead_idex_exmem,
			     memWrite_exmem_i   => memWrite_idex_exmem,
			     memToReg_exmem_i   => memToReg_idex_exmem,
			     regWrite_exmem_i   => regWrite_idex_exmem,
			     PC_exmem_o         => PC_exmem_jas,
			     ALU_result_exmem_o => ALU_result_exmem_dm,
			     ALUdataA_exmem_o   => ALUdataA_exmem_jas,
			     --B_data_exmem_o   => B_data_exmem_dm,
			     zero_flag_exmem_o  => zero_exmem_pc,
			     dataAddr_exmem_o   => dataAddr_exmem_rds,
			     PCSource_exmem_o   => PCSrc_exmem_jas,
			     branch_exmem_o     => branch_exmem_pc,
			     memRead_exmem_o    => memRead_exmem_dm,
			     memWrite_exmem_o   => memWrite_exmem_dm,
			     memToReg_exmem_o   => memToReg_exmem_memwb,
			     regWrite_exmem_o   => regWrite_exmem_memwb);

	ac : ALU_Control
		port map(rst_i          => reset,
			     ALU_Op_i       => alu_op_idex_ac,
			     functioncode_i => functioncode_idex_ac,
			     op_i           => op_idex_ac,
			     alu_code_o     => alu_code_ac_alu
		);

	alu_unit : ALU
		port map(rst_i      => reset,
			     A_i        => dataA_os_alu,
			     B_i        => dataB_os_alu,
			     ALU_ctrl_i => alu_code_ac_alu,
			     shamt_i    => signExtAddr_idex_se(4 downto 0),
			     C_o        => C_alu_exmem,
			     zero_o     => zero_alu_exmem);

	se : signExtend
		port map(address_i => signExtAddr_complete_idex_se,
			     address_o => signExtend_se_os);

	os : operandSelect
		port map(ALUSrcA_i   => ALUSrcA_idex_os,
			     ALUSrcB_i   => ALUSrcB_idex_os,
			     PC_A_i      => PC_idex_exmem,
			     RF_A_i      => dataA_idex_os,
			     RF_B_i      => dataB_idex_os,
			     SignExt_B_i => signExtend_se_os,
			     A_o         => dataA_os_alu,
			     B_o         => dataB_os_alu);

	dm : dataMemory
		port map(clk_i        => clock,
			     rst_i        => reset,
			     alu_result_i => ALU_result_exmem_dm,
			     writeData_i  => B_data_exmem_dm,
			     memWrite_i   => memWrite_exmem_dm,
			     memRead_i    => memRead_exmem_dm,
			     readData_o   => memData_dm_jas);

end architecture RTL;
