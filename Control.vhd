library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity Control is
	port(
		rst_i         : in  std_logic;
		op_i          : in  std_logic_vector(5 DOWNTO 0);
		funct_i       : in  std_logic_vector(5 downto 0);

		PCWriteCond_o : out std_logic;
		PCWrite_o     : out std_logic;
		IorD_o        : out std_logic;

		branch_o      : out std_logic;	
		MemRead_o     : out std_logic;
		MemWrite_o    : out std_logic;
		MemToReg_o    : out std_logic;
		regWrite_o    : out std_logic;
		branchCond_o  : out branch_condition;
		ALUOp_o       : out std_logic_vector(1 DOWNTO 0);
		loadMode_o 	  : out load_mode;
		storeMode_o   : out store_mode;
		compare_o     : out std_logic;

		--IRWrite_o     : out std_logic;
		--IRWrite ist jetzt RegWrite
		PCSource_o    : out std_logic_vector(1 downto 0);
		ALUSrcB_o     : out std_logic_vector(1 DOWNTO 0);
		ALUSrcA_o     : out std_logic;
		RegDst_o      : out std_logic_vector(1 downto 0)
	);
end entity Control;

architecture behaviour of Control is
	signal op    : std_logic_vector(5 downto 0);
	signal funct : std_logic_vector(5 downto 0);
begin
	op         <= op_i;
	funct      <= funct_i;
	ALUOp_o    <= "10" when op = "000000" else
	                    "10" when op = "000010" else
						"10" when op = c_addi else
						"10" when op = c_addiu else
						"10" when op = c_andi else
						"10" when op = c_ori else
						"10" when op = c_xori else
						"10" when op = c_slti else
						"10" when op = c_sltiu else
						"10" when op = c_beq.opcode else
						"10" when op = c_bne.opcode else
						"10" when op = c_blez.opcode else
						"10" when op = c_bgtz.opcode else						
						"00" when op = c_lw else
						"00" when op = c_lh else
						"00" when op = c_lb else
						"00" when op = c_lhu else
						"00" when op = c_lbu else
						"00" when op = c_sw else
						"00" when op = c_sh else
						"00" when op = c_sb else
						"10" when op = c_jal else
						"10" when op = c_j else						
						(others => '0');						
	ALUSrcB_o  <= "01" when op = "000000" and funct_i = c_jalr.funct else
	                    "00" when op = "000000" else 
						"10" when op = c_addi else
						"10" when op = c_addiu else
						"10" when op = c_andi else
						"10" when op = c_ori else
						"10" when op = c_xori else	
						"10" when op = c_slti else
						"10" when op = c_sltiu else
						"10" when op = c_lw else
						"10" when op = c_lh else
						"10" when op = c_lb else
						"10" when op = c_lhu else
						"10" when op = c_lbu else
						"10" when op = c_sw else
						"10" when op = c_sh else
						"10" when op = c_sb else
						"00" when op = c_beq.opcode else
						"00" when op = c_bne.opcode else
						"00" when op = c_blez.opcode else
						"00" when op = c_bgtz.opcode else
						"01" when op = c_jal else
						(others => '0');
	ALUSrcA_o  <= '0' when op = "000000" and funct_i = c_jalr.funct else
				        '1' when op = "000000" else
						'1' when op = c_addi else
						'1' when op = c_addiu else
						'1' when op = c_andi else
						'1' when op = c_ori else
						'1' when op = c_xori else	
						'1' when op = c_slti else
						'1' when op = c_sltiu else						
						'1' when op = c_lw else
						'1' when op = c_lh else
						'1' when op = c_lb else
						'1' when op = c_lhu else
						'1' when op = c_lbu else
						'1' when op = c_sw else
						'1' when op = c_sh else
						'1' when op = c_sb else
						'1' when op = c_beq.opcode else
						'1' when op = c_bne.opcode else
						'1' when op = c_blez.opcode else
						'1' when op = c_bgtz.opcode else
						'0' when op = c_jal else
						'0';
	MemWrite_o <= '0' when op = "000000" else 
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else	
						'0' when op = c_slti else
						'0' when op = c_sltiu else						
						'0' when op = c_lw else
						'0' when op = c_lh else
						'0' when op = c_lb else
						'0' when op = c_lhu else
						'0' when op = c_lbu else
						'1' when op = c_sw else
						'1' when op = c_sh else
						'1' when op = c_sb else
						'0';
	MemRead_o <= '0'  when op = "000000" else
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else	
						'0' when op = c_slti else
						'0' when op = c_sltiu else						
						'1' when op = c_lw else
						'1' when op = c_lh else
						'1' when op = c_lb else
						'1' when op = c_lhu else
						'1' when op = c_lbu else
						'0' when op = c_sw else
						'0' when op = c_sh else
						'0' when op = c_sb else
						'0';

	PCSource_o <=       "10" when op = c_beq.opcode  else
	                    "10" when op = c_bgez.opcode else
	                    "10" when op = c_bgezal.opcode else
	                    "10" when op = c_bgtz.opcode else
	                    "10" when op = c_blez.opcode else
	                    "10" when op = c_bltzal.opcode else
	                    "10" when op = c_bne.opcode else
	                    "10" when op = c_bltz.opcode else
						"01" when op = c_addi else
						"01" when op = c_addiu else
						"01" when op = c_andi else
						"01" when op = c_ori else
						"01" when op = c_xori else
						"01" when op = c_slti else
						"01" when op = c_sltiu else						
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
						"10" when op = c_j else
						"10" when op = c_jal else
						"01" when op = "000000" else --jr and jalr
						(others => '0');
	RegDst_o   <= "01" when op = "000000" else 
						"00" when op = c_addi else
						"00" when op = c_addiu else
						"00" when op = c_andi else
						"00" when op = c_ori else
						"00" when op = c_xori else	
						"00" when op = c_slti else
						"00" when op = c_sltiu else						
						"00" when op = c_lw else
						"00" when op = c_lh else
						"00" when op = c_lb else
						"00" when op = c_lhu else
						"00" when op = c_lbu else						
						"--" when op = c_sw else
						"10" when op = c_sh else
						"10" when op = c_sb else						
						"10" when op = c_jal else
						"--";
	regWrite_o <= '1' when op = "000000" else 
						'1' when op = c_addi else
						'1' when op = c_addiu else
						'1' when op = c_andi else
						'1' when op = c_ori else
						'1' when op = c_xori else
						'1' when op = c_slti else
						'1' when op = c_sltiu else						
						'1' when op = c_lw else
						'1' when op = c_lh else
						'1' when op = c_lb else
						'1' when op = c_lhu else
						'1' when op = c_lbu else						
						'1' when op = c_jal else
						'0' when op = c_sw else
						'0' when op = c_sh else
						'0' when op = c_sb else						
						'0' when op = c_j  else
						'0';
	MemToReg_o <= '0' when op = "000000" else
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else
						'0' when op = c_slti else
						'0' when op = c_sltiu else						
						'0' when op = c_jal else	
						'1' when op = c_lw else
						'1' when op = c_lh else
						'1' when op = c_lb else
						'1' when op = c_lhu else
						'1' when op = c_lbu else							
						'-' when op = c_sw else
						'-' when op = c_sh else
						'-' when op = c_sb else							
						'0';
	branchCond_o <= bc_beq 	when op = c_beq.opcode else --right know not needed, 
						bc_bgtz when op = c_bgtz.opcode else
						bc_blez when op = c_blez.opcode else
						bc_bne; --when op is not branch, then dont care 
						
	branch_o <= '1'when op = c_beq.opcode else  --when branch 1 when jump 0
						'1' when op = c_bgtz.opcode else
						'1' when op = c_blez.opcode else
						'1' when op = c_bne.opcode else
						'0';
	PCWrite_o <= '1' when op = c_j else
	             '1' when op = c_jal else
	             '1' when op = c_jr.opcode and funct = c_jr.funct else
	             '1' when op = c_jalr.opcode and funct = c_jalr.funct else
	             '0';
	
	loadMode_o <= ld_lw when op = c_lw else
						ld_lh when op = c_lh else
						ld_lb when op = c_lb else
						ld_lhu when op = c_lhu else
						ld_lbu;

	storeMode_o <= 	st_sw when op = c_sw else
							st_sh when op = c_sh else
							st_sb;
	
	compare_o <= 	'1' when op = "000000" 	and ((funct = c_slt.funct) 
											or 	(funct = c_sltu.funct)) else
					'1' when op = c_slti else
					'1' when op = c_sltiu else
					'0';
				
						
	
end architecture;