library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Instructions_pack.all;

entity Control is
	port(
		clk_i         : in  std_logic;
		rst_i         : in  std_logic;
		op_i          : in  std_logic_vector(5 DOWNTO 0);

		--PCWriteCond_o : out std_logic;
		--IorD_o not needed any more (Chap. 6, Page. 404)

       --PCSource replace jump and branch (pipelined implementation, Chapter 6, Page 404)	
		MemRead_o     : out std_logic;
		MemWrite_o    : out std_logic;
		MemToReg_o    : out std_logic;
		regWrite_o    : out std_logic;
		ALUOp_o       : out std_logic_vector(1 DOWNTO 0);

		PCSource_o    : out std_logic_vector(1 downto 0);
		ALUSrcB_o     : out std_logic_vector(1 DOWNTO 0);
		ALUSrcA_o     : out std_logic;
		RegDst_o      : out std_logic_vector(1 downto 0);
		enable_o      : out std_logic --stall control
	);
end entity Control;

architecture behaviour of Control is
	signal op : std_logic_vector(5 downto 0);
	signal stall : std_logic := '0'; -- pipeline stall
	signal stall_counter : std_logic_vector(1 downto 0) := "00";
	signal enable : std_logic := '1';
	constant c_stall_period : natural := 2;
begin
	op         <= op_i;
	ALUOp_o    <= "10" when op = "000000" else
	                    "10" when op = "000010" else
						"10" when op = c_addi else
						"10" when op = c_addiu else
						"10" when op = c_andi else
						"10" when op = c_ori else
						"10" when op = c_xori else
						"00" when op = c_lw else
						"00" when op = c_sw else
						"00" when op = c_jal else
						(others => '0');
	ALUSrcB_o  <= "00" when op = "000000" else 
						"10" when op = c_addi else
						"10" when op = c_addiu else
						"10" when op = c_andi else
						"10" when op = c_ori else
						"10" when op = c_xori else	
						"10" when op = c_lw else
						"10" when op = c_sw else
						"01" when op = c_jal else
						"01" when op = c_jalr.opcode else
						"00";
	ALUSrcA_o  <= '1' when op = "000000" else
						'1' when op = c_addi else
						'1' when op = c_addiu else
						'1' when op = c_andi else
						'1' when op = c_ori else
						'1' when op = c_xori else						
						'1' when op = c_lw else
						'1' when op = c_sw else
						'0' when op = c_jal else
						'0' when op = c_jalr.opcode else
						'0';
	MemWrite_o <= '0' when op = "000000" else 
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else	
						'0' when op = c_lw else
						'1' when op = c_sw else
						'0';
	MemRead_o <= '0'  when op = "000000" else
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else	
						'1' when op = c_lw else
						'0' when op = c_sw else
						'0';

	PCSource_o <=       "01" when op = c_beq.opcode  else
	                    "01" when op = c_bgez.opcode else
	                    "01" when op = c_bgezal.opcode else
	                    "01" when op = c_bgtz.opcode else
	                    "01" when op = c_blez.opcode else
	                    "01" when op = c_bltzal.opcode else
	                    "01" when op = c_bne.opcode else
	                    "01" when op = c_bltz.opcode else
						"01" when op = c_addi else
						"01" when op = c_addiu else
						"01" when op = c_andi else
						"01" when op = c_ori else
						"01" when op = c_xori else						
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
						"11" when op = c_j else --jump
						"11" when op = c_jal else --jump and link
						--"10" when op = c_jalr.opcode else --jump and link register op="00000"
						--"11" when op = c_jr.opcode else --jump register
						(others => '0');
	RegDst_o   <= "11" when op = "000000" else 
						"10" when op = c_addi else
						"10" when op = c_addiu else
						"10" when op = c_andi else
						"10" when op = c_ori else
						"10" when op = c_xori else	
						"10" when op = c_lw else
						"00" when op = c_sw else
						"00" when op = c_jal else
						"00";
	regWrite_o <= '1' when op = "000000" else 
						'1' when op = c_addi else
						'1' when op = c_addiu else
						'1' when op = c_andi else
						'1' when op = c_ori else
						'1' when op = c_xori else		
						'1' when op = c_lw else
						'1' when op = c_jal else
						'0' when op = c_sw else
						'0' when op = c_j  else
						'0' when op = c_jr.opcode else
						'0';
	MemToReg_o <= '0' when op = "000000" else
						'0' when op = c_addi else
						'0' when op = c_addiu else
						'0' when op = c_andi else
						'0' when op = c_ori else
						'0' when op = c_xori else
						'0' when op = c_jal else	
						'1' when op = c_lw else
						'-' when op = c_sw else
						'0';
	stall <= '1' when op = c_j else
	         '1' when op = c_jal else
	         --'1' when op = c_jalr.opcode else
	         --'1' when op = c_jr.opcode else
	         '0';
	         
	
	--PCWrite not needed any more (Chap. 6, P. 404)
	
	stallControl : process (clk_i, rst_i) is
	begin
		if rst_i = '1' then
			enable <= '1';
		elsif rising_edge(clk_i) then
			if stall = '1' then
				enable <= '0';
			elsif stall_counter = std_logic_vector(to_unsigned(c_stall_period,2)) then
				enable <= '1';
			end if;
			
		end if;
	end process stallControl;
	
	stallCount : process (clk_i, rst_i) is
	begin
		if rst_i = '1' then
			stall_counter <= "00";
		elsif rising_edge(clk_i) then
			if enable = '0' then
				stall_counter <= std_logic_vector(unsigned(stall_counter) + to_unsigned(1,2));
			else
				stall_counter <= "00";				
			end if;
		end if;
	end process stallCount;
	
	enable_o <= enable;
end architecture;