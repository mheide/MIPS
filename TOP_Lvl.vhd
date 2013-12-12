library ieee;
use ieee.std_logic_1164.all;

entity TOP_Lvl is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic;
		enable_i : in std_logic
	);
end entity TOP_Lvl;

architecture RTL of TOP_Lvl is
	component ALU
		port(
			rst_i      : in  std_logic;
			A_i        : in  std_logic_vector(31 downto 0);
			B_i        : in  std_logic_vector(31 downto 0);
			ALU_ctrl_i : in  std_logic_vector(3 downto 0);
			C_o        : out std_logic_vector(31 downto 0);
			zero_o     : out std_logic
		);
	end component ALU;

	component ALU_Control
		port(		
		rst_i      : in  std_logic;
		ALU_Op_i   : in  std_logic_vector(1 downto 0);
		functioncode_i   : in  std_logic_vector(5 downto 0);
		alu_code_o : out std_logic_vector(3 downto 0)
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
			
			ALUSrcA_i    : in  std_logic; --1 for arithmetic op
			ALUSrcB_i    : in  std_logic_vector(1 DOWNTO 0); --00 for arithmetic op	
			
			dataA_o      : out std_logic_vector(31 downto 0);
			dataB_o      : out std_logic_vector(31 downto 0)

		);
	end component;

	component Control
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
	end component;

	component regDstSelect
		port(
			regDst_i            : in  std_logic;
			instruction_20_16_i : in  std_logic_vector(4 DOWNTO 0);
			instruction_15_11_i : in  std_logic_vector(4 DOWNTO 0);

			instruction_o       : out std_logic_vector(4 DOWNTO 0)
		);
	end component;

	component ID_EX
		port(
			clk_i                : in  std_logic;
			rst_i                : in  std_logic;
			enable_i             : in  std_logic;
			PCSource_idex_i      : in  std_logic_vector(1 DOWNTO 0);
			PC_idex_i            : in  std_logic_vector(31 downto 0);
			dataAddr_idex_i      : in  std_logic_vector(4 downto 0); --for r-type: destination address (register)


			ALUSrcB_idex_i       : in std_logic_vector(1 DOWNTO 0); --EX
			ALUSrcA_idex_i       : in std_logic;
			ALU_op_idex_i        : in  std_logic_vector(1 DOWNTO 0);
			function_code_idex_i : in  std_logic_vector(5 DOWNTO 0);

			branch_idex_i        : in  std_logic; --M
			memRead_idex_i       : in  std_logic;
			memWrite_idex_i      : in  std_logic;

			memToReg_idex_i      : in  std_logic; --WB
			regWrite_idex_i      : in  std_logic;

			PCSource_idex_o      : out std_logic_vector(1 DOWNTO 0);
			PC_idex_o            : out std_logic_vector(31 downto 0);
			dataAddr_idex_o      : out std_logic_vector(4 downto 0);


			ALUSrcB_idex_o       : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_idex_o       : out std_logic;
			ALU_op_idex_o        : out std_logic_vector(1 DOWNTO 0);
			function_code_idex_o : out std_logic_vector(5 DOWNTO 0);

			branch_idex_o        : out std_logic;
			memRead_idex_o       : out std_logic;
			memWrite_idex_o      : out std_logic;

			memToReg_idex_o      : out std_logic; --WB
			regWrite_idex_o      : out std_logic
		);
	end component;

	component EX_MEM
		port(
			clk_i              : in  std_logic;
			rst_i              : in  std_logic;
			enable_i           : in  std_logic;
			PC_exmem_i         : in  std_logic_vector(31 downto 0);
			ALU_result_exmem_i : in  std_logic_vector(31 downto 0);
			zero_flag_exmem_i  : in  std_logic;
			dataAddr_exmem_i   : in  std_logic_vector(4 downto 0);
			PCSource_exmem_i   : in  std_logic_vector(1 DOWNTO 0);

			branch_exmem_i     : in  std_logic; --M
			memRead_exmem_i    : in  std_logic;
			memWrite_exmem_i   : in  std_logic;

			memToReg_exmem_i   : in  std_logic; --WB
			regWrite_exmem_i   : in  std_logic;

			PC_exmem_o         : out std_logic_vector(31 downto 0);
			ALU_result_exmem_o : out std_logic_vector(31 downto 0);
			zero_flag_exmem_o  : out std_logic;
			dataAddr_exmem_o   : out std_logic_vector(4 downto 0);
			PCSource_exmem_o   : out std_logic_vector(1 DOWNTO 0);

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
			PC_memwb_i             : in  std_logic_vector(31 downto 0);
			memoryReadData_memwb_i : in  std_logic_vector(31 downto 0);
			ALU_result_memwb_i     : in  std_logic_vector(31 downto 0);
			dataAddr_memwb_i       : in  std_logic_vector(4 downto 0);
			PCSource_memwb_i       : in  std_logic_vector(1 DOWNTO 0);

			memToReg_memwb_i       : in  std_logic; --WB
			regWrite_memwb_i       : in  std_logic;

			PC_memwb_o             : out std_logic_vector(31 downto 0);
			memoryReadData_memwb_o : out std_logic_vector(31 downto 0);
			ALU_result_memwb_o     : out std_logic_vector(31 downto 0);
			dataAddr_memwb_o       : out std_logic_vector(4 downto 0);
			PCSource_memwb_o       : out std_logic_vector(1 DOWNTO 0);

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
			clk_i       : in  std_logic;
			rst_i       : in  std_logic;
			enable_i    : in  std_logic;
			PCSrc_i     : in  std_logic_vector(1 DOWNTO 0);
			jump_flag_i : in  std_logic;
			jump_addr_i : in  std_logic_vector(31 downto 0); --null in this implementation
			PC_o        : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component jumpAddressSelect is
		port(
			PCSource_i          : in  std_logic_vector(1 DOWNTO 0);
			ALU_result 			: in  std_logic_vector(31 DOWNTO 0);
			ALU_result_modified : in  std_logic_vector(31 DOWNTO 0);
			PC_modified			: in  std_logic_vector(31 DOWNTO 0);

			jumpAddress_o       : out std_logic_vector(31 DOWNTO 0)
		);
	end component;	
	
	
	signal reset : std_logic;
	signal clock : std_logic;
	signal enable : std_logic;
	
	--exmem --> pc --beide nicht angekommen
	signal zero_exmem_pc : std_logic;
	signal branch_exmem_pc : std_logic; -- noch mal sichergehen wie genau (PCSource?)
	
	--exmem --> memwb
	signal PC_exmem_memwb : std_logic_vector(31 downto 0);
	signal PC_Src_exmem_memwb : std_logic_vector(1 downto 0);
	signal memToReg_exmem_memwb : std_logic;
	signal regWrite_exmem_memwb : std_logic;
	signal ALU_result_exmem_memwb : std_logic_vector(31 downto 0); --TODO: zum Speicher fuer andere befehle
	
	--exmem --> memory
	signal memRead_exmem_mem : std_logic;
	signal memWrite_exmem_mem : std_logic;
	
	--exmem --> regDstSelect, memwb
	signal dataAddr_exmem_rds : std_logic_vector(4 downto 0);
	
	--idex --> exmem
	signal PCSrc_idex_exmem : std_logic_vector(1 downto 0);
	signal PC_idex_exmem : std_logic_vector(31 downto 0);
	signal branch_idex_exmem : std_logic;
	signal memRead_idex_exmem : std_logic;
	signal memWrite_idex_exmem : std_logic;
	signal memToReg_idex_exmem : std_logic;
	signal regWrite_idex_exmem : std_logic;
	signal dataAddr_idex_exmem : std_logic_vector(4 downto 0);
	
	--alu --> exmem
	signal zero_alu_exmem : std_logic;
	signal C_alu_exmem : std_logic_vector(31 downto 0);
		
	--rf --> alu 
	signal dataA_rf_alu : std_logic_vector(31 downto 0);
	signal dataB_rf_alu : std_logic_vector(31 downto 0);
	
	--ac --> alu
	signal alu_code_ac_alu : std_logic_vector(3 downto 0);
	
	-- idex --> ac
	signal alu_op_idex_ac : std_logic_vector(1 downto 0);
	signal functioncode_idex_ac : std_logic_vector(5 downto 0);
	
	-- regDstSelect --> rf
	signal dst_Addr_rds_rf : std_logic_vector(4 downto 0);
	
	--ifid --> rf, ctrl, regDstSelect, idex
	signal data_ifid_rf : std_logic_vector(31 downto 0); 
	
	--idex --> rf
	signal ALUSrcA_idex_rf : std_logic;
	signal ALUSrcB_idex_rf : std_logic_vector(1 downto 0);
	
	--memwb --> rf, jas
	signal memoryReadData_memwb_rf : std_logic_vector(31 downto 0);
	--TODO: dataAddr_memwb_o: sinnvoll machen, oder vielleicht nicht gebraucht? DOCH	
	signal dataAddr_memwb_rf : std_logic_vector(4 downto 0);
	
	
	--ctrl --> idex
	signal ALUSrcA_ctrl_idex : std_logic;
	signal ALUSrcB_ctrl_idex : std_logic_vector(1 downto 0);
	signal PCSource_ctrl_idex : std_logic_vector(1 downto 0);
	signal branch_ctrl_idex : std_logic;
	signal memRead_ctrl_idex : std_logic;
	signal memWrite_ctrl_idex : std_logic;
	signal memToReg_ctrl_idex : std_logic;
	signal regWrite_ctrl_idex : std_logic;
	signal ALUop_ctrl_idex : std_logic_vector(1 downto 0);
	
	--ctrl --> regDstSelect
	signal regDst_ctrl_rds : std_logic;

	
	--crtl --> pc --TODO: pc ueberlegen fuer andere befehlstypen
	signal PCWriteCond_ctrl_pc : std_logic;
	signal PCWrite_ctrl_pc : std_logic;
	signal IorD_ctrl_pc : std_logic;
	
	--ctrl --> ir -- TODO: implementieren, ins instruction_register
	signal IRWrite_ctrl_ir : std_logic;
	
	--ifid --> idex
	signal PC_ifid_idex : std_logic_vector(31 downto 0);
	
	--pc --> ifid --writedata fehlt
	signal address_pc_ifid : std_logic_vector(31 downto 0);
	
	--memwb --> jumpAddressSelct
	signal PC_memwb_jas : std_logic_vector(31 downto 0);
	signal PCSource_memwb_jas : std_logic_vector(1 downto 0);
	signal ALU_result_memwb_jas : std_logic_vector(31 downto 0); --gebraucht?

	--memory --> memwb
	signal memoryReadData_mem_memwb : std_logic_vector(31 downto 0); --noch nicht komplett verdrahtet
	
	--memwb --> registerFile --eigentlich regDst

	
	--memwb --> ifid_memory		--noch nicht implementiert
	signal memToReg_memwb_ifidmem : std_logic;		
	signal regWrite_memwb_ifidmem : std_logic;
	
	--jas --> PC
	signal jumpAddress_jas_pc : std_logic_vector(31 downto 0);
	
	begin
	--pc: PCSource unnoetig, da jumpaddressselect?
	
	clock <= clk_i;
	reset <= rst_i;
	enable <= enable_i;
	
	
	pc : pc_counter 
	port map(clk_i       => clock,
			     rst_i       => reset,
			     enable_i    => enable,
			     PCSrc_i     => "00",
			     jump_flag_i => '0',
			     jump_addr_i => jumpAddress_jas_pc,
			     PC_o        => address_pc_ifid);

	jas : jumpAddressSelect
		port map(PCSource_i          => PCSource_memwb_jas,
			     ALU_result          => ALU_result_memwb_jas,
			     ALU_result_modified => ALU_result_memwb_jas,
			     PC_modified         => PC_memwb_jas,
			     jumpAddress_o       => jumpAddress_jas_pc);
	
	memwb : MEM_WB
	port map(clk_i                             => clock,
			rst_i                  => reset,
			enable_i               => enable,
			PC_memwb_i             => PC_exmem_memwb,
			memoryReadData_memwb_i => memoryReadData_mem_memwb,
			PCSource_memwb_i       => PC_Src_exmem_memwb,
			ALU_result_memwb_i     => ALU_result_exmem_memwb,
			dataAddr_memwb_i       => dataAddr_exmem_rds,
			memToReg_memwb_i       => memToReg_exmem_memwb,
			regWrite_memwb_i       => regWrite_exmem_memwb,
			PC_memwb_o             => PC_memwb_jas,
			memoryReadData_memwb_o => memoryReadData_memwb_rf,
			ALU_result_memwb_o     => ALU_result_memwb_jas,
			dataAddr_memwb_o       => dataAddr_memwb_rf,
			PCSource_memwb_o       => PCSource_memwb_jas,
			memToReg_memwb_o       => memToReg_memwb_ifidmem,
			regWrite_memwb_o       => regWrite_memwb_ifidmem);
	
	ifid : IF_ID
		port map(clk_i         => clock,
			     rst_i         => reset,
			     enable_i      => enable,
			     PC_ifid_i     => address_pc_ifid,
			     Instruction_o => data_ifid_rf,
			     PC_ifid_o     => PC_ifid_idex);

	idex : ID_EX
		port map(clk_i                => clock,
			     rst_i                => reset,
			     enable_i             => enable,
			     PCSource_idex_i      => PCSource_ctrl_idex,
			     PC_idex_i            => PC_ifid_idex,
			     dataAddr_idex_i      => data_ifid_rf(15 downto 11),
			     ALUSrcB_idex_i       => ALUSrcB_ctrl_idex,
			     ALUSrcA_idex_i       => ALUSrcA_ctrl_idex,
			     ALU_op_idex_i        => ALUop_ctrl_idex,
			     function_code_idex_i => data_ifid_rf(5 downto 0),
			     branch_idex_i        => branch_ctrl_idex,
			     memRead_idex_i       => memRead_ctrl_idex,
			     memWrite_idex_i      => memWrite_ctrl_idex,
			     memToReg_idex_i      => memToReg_ctrl_idex,
			     regWrite_idex_i      => regWrite_ctrl_idex,
			     PCSource_idex_o      => PCSrc_idex_exmem,
			     PC_Idex_o            => PC_idex_exmem,
			     dataAddr_idex_o      => dataAddr_idex_exmem,
			     ALUSrcB_idex_o       => ALUSrcB_idex_rf,
			     ALUSrcA_idex_o       => ALUSrcA_idex_rf,
			     ALU_op_idex_o        => alu_op_idex_ac,
			     function_code_idex_o => functioncode_idex_ac,
			     branch_idex_o        => branch_idex_exmem,
			     memRead_idex_o       => memRead_idex_exmem,
			     memWrite_idex_o      => memWrite_idex_exmem,
			     memToReg_idex_o      => memToReg_idex_exmem,
			     regWrite_idex_o      => regWrite_idex_exmem);

	rds : regDstSelect
		port map(regDst_i            => regDst_ctrl_rds,
			     instruction_20_16_i => data_ifid_rf(20 downto 16),
			     instruction_15_11_i => data_ifid_rf(15 downto 11),
			     instruction_o       => dst_Addr_rds_rf);

	ctrl : Control
		port map(rst_i         => reset,
			     op_i          => data_ifid_rf(31 downto 26),
			     PCWriteCond_o => PCWriteCond_ctrl_pc,
			     PCWrite_o     => PCWrite_ctrl_pc,
			     IorD_o        => IorD_ctrl_pc,
			     branch_o      => branch_ctrl_idex,
			     MemRead_o     => memRead_ctrl_idex,
			     MemWrite_o    => memWrite_ctrl_idex,
			     MemToReg_o    => memToReg_ctrl_idex,
			     regWrite_o    => memToReg_ctrl_idex,
			     ALUOp_o       => ALUop_ctrl_idex,
			     IRWrite_o     => IRWrite_ctrl_ir,
			     PCSource_o    => PCSource_ctrl_idex,
			     ALUSrcB_o     => ALUSrcB_ctrl_idex,
			     ALUSrcA_o     => ALUSrcA_ctrl_idex,
			     RegDst_o      => regDst_ctrl_rds);

	rf : RegisterFile
		port map(clk_i        => clock,
			     rst_i        => reset,
			     data_i       => memoryReadData_memwb_rf,
			     dataAddr_i   => dst_Addr_rds_rf,
			     dataA_Addr_i => data_ifid_rf(25 downto 21),
			     dataB_Addr_i => data_ifid_rf(20 downto 16),
			     ALUSrcA_i    => ALUSrcA_idex_rf,
			     ALUSrcB_i    => ALUSrcB_idex_rf,
			     dataA_o      => dataA_rf_alu,
			     dataB_o      => dataB_rf_alu);

	exmem : EX_MEM
		port map(clk_i              => clock,
			     rst_i              => reset,
			     enable_i           => enable,
			     PC_exmem_i         => PC_idex_exmem,
			     PCSource_exmem_i   => PCSrc_idex_exmem,
			     ALU_result_exmem_i => C_alu_exmem,
			     zero_flag_exmem_i  => zero_alu_exmem,
			     dataAddr_exmem_i   => dataAddr_idex_exmem,
			     branch_exmem_i     => branch_idex_exmem,
			     memRead_exmem_i    => memRead_idex_exmem,
			     memWrite_exmem_i   => memWrite_idex_exmem,
			     memToReg_exmem_i   => memToReg_idex_exmem,
			     regWrite_exmem_i   => regWrite_idex_exmem,
			     PC_exmem_o         => PC_exmem_memwb,
			     ALU_result_exmem_o => ALU_result_exmem_memwb,
			     zero_flag_exmem_o  => zero_exmem_pc,
			     dataAddr_exmem_o   => dataAddr_exmem_rds,
			     PCSource_exmem_o   => PC_Src_exmem_memwb,
			     branch_exmem_o     => branch_exmem_pc,
			     memRead_exmem_o    => memRead_exmem_mem,
			     memWrite_exmem_o   => memWrite_exmem_mem,
			     memToReg_exmem_o   => memToReg_exmem_memwb,
			     regWrite_exmem_o   => regWrite_exmem_memwb);

	ac : ALU_Control
		port map(rst_i              => reset,
				ALU_Op_i            => alu_op_idex_ac,
				functioncode_i      => functioncode_idex_ac,
				alu_code_o          => alu_code_ac_alu
			);

	alu_unit : ALU
		port map(rst_i      => reset,
			     A_i        => dataA_rf_alu,
			     B_i        => dataB_rf_alu,
			     ALU_ctrl_i => alu_code_ac_alu,
			     C_o        => C_alu_exmem,
			     zero_o     => zero_alu_exmem);


end architecture RTL;
