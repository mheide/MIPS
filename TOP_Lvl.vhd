library ieee;
use ieee.std_logic_1164.all;

entity TOP_Lvl is
	port(
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity TOP_Lvl;

architecture RTL of TOP_Lvl is
	component ALU
		generic(c_reg_size : natural := 32);
		port(clk_i      : in  std_logic;
			 rst_i      : in  std_logic;
			 A_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
			 B_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
			 ALU_ctrl_i : in  std_logic_vector(3 downto 0);
			 C_o        : out std_logic_vector(c_reg_size - 1 downto 0);
			 zero_o     : out std_logic);
	end component ALU;

	component ALU_Control
		port(clk_i      : in  std_logic;
			 rst_i      : in  std_logic;
			 ALU_Op_i   : in  std_logic_vector(1 downto 0);
			 opcode_i   : in  std_logic_vector(5 downto 0);
			 alu_code_o : out std_logic_vector(3 downto 0));
	end component ALU_Control;

	component RegisterFile
		port(
			clk_i        : in  std_logic;
			rst_i        : in  std_logic;
			rt_i         : in  std_logic_vector(4 DOWNTO 0); --dest. for other ops
			rd_i         : in  std_logic_vector(4 DOWNTO 0); --dest. for r-type op
			RegDst_i     : in  std_logic;
			data_i       : in  std_logic_vector(31 downto 0);
			dataA_Addr_i : in  std_logic_vector(4 downto 0); --rs
			dataA_o      : out std_logic_vector(31 downto 0);
			dataB_Addr_i : in  std_logic_vector(4 downto 0); --rt
			dataB_o      : out std_logic_vector(31 downto 0);
			ALUSrcA_i    : in  std_logic; --1 for arithmetic op
			ALUSrcB_i    : in  std_logic_vector(1 DOWNTO 0) --00 for arithmetic op
		);
	end component;

	component Control
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
			DataA_idex_i         : in  std_logic_vector(31 downto 0);
			DataB_idex_i         : in  std_logic_vector(31 downto 0);
			PCSource_idex_i      : in  std_logic_vector(1 DOWNTO 0);
			PC_idex_i            : in  std_logic_vector(31 downto 0);
			dataAddr_idex_i      : in  std_logic_vector(4 downto 0); --for r-type: destination address (register)

			regDst_idex_i        : in  std_logic; --EX
			ALUSrcB_idex_i       : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_idex_i       : out std_logic;
			ALU_op_idex_i        : in  std_logic_vector(1 DOWNTO 0);
			function_code_idex_i : in  std_logic_vector(5 DOWNTO 0);

			branch_idex_i        : in  std_logic; --M
			memRead_idex_i       : in  std_logic;
			memWrite_idex_i      : in  std_logic;

			memToReg_idex_i      : in  std_logic; --WB
			regWrite_idex_i      : in  std_logic;

			DataA_idex_o         : out std_logic_vector(31 downto 0);
			DataB_idex_o         : out std_logic_vector(31 downto 0);
			PCSource_idex_o      : out std_logic_vector(1 DOWNTO 0);
			PC_idex_o            : out std_logic_vector(31 downto 0);
			dataAddr_idex_o      : out std_logic_vector(4 downto 0);

			regDst_idex_o        : out std_logic;
			ALUSrcB_idex_o       : out std_logic_vector(1 DOWNTO 0);
			ALUSrcA_idex_o       : out std_logic;
			ALU_op_idex_o        : in  std_logic_vector(1 DOWNTO 0);
			function_code_idex_o : in  std_logic_vector(5 DOWNTO 0);

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

begin
end architecture RTL;
