library ieee;
use ieee.std_logic_1164.all;

package Instructions_pack is
	constant c_op_bits      : integer := 6;
	constant c_instr_bits   : integer := 5;
	constant c_immed_bits   : integer := 16;
	constant c_address_bits : integer := 26;
	----------------------------------------------------
	------- r type constants ---------------------------
	---------------------------------------------------- 
	type R_Type_Constant is record
		opcode : std_logic_vector(c_op_bits - 1 downto 0);
		funct  : std_logic_vector(c_op_bits - 1 downto 0);
	end record;

	constant c_add : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"0"
	);
	constant c_addu  : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"1"
	);
	constant c_and   : R_Type_Constant := (
		opcode => "000000", funct => "10" & x"4"
	);
	-- count leading ones
	constant c_clo   : R_Type_Constant := ( 
		opcode => "01" & x"C", funct => "10" & x"1"
	);
	-- count leading zeros
	constant c_clz : R_Type_Constant := ( 
		opcode => "01" & x"C", funct => "10" & x"0"
	);
	constant c_div : R_Type_Constant := (
		opcode => (others => '0'), funct => "01" & x"A"
	);
	constant c_divu : R_Type_Constant := (
		opcode => (others => '0'), funct => "01" & x"B"
	);
	--multiply
	constant c_mult : R_Type_Constant := (
		opcode => (others => '0'), funct => "01" & x"8"
	);
	--unsigned multiply
	constant c_multu : R_Type_Constant := (
		opcode => (others => '0'), funct => "01" & x"9"
	);
	--multiply without overflow
	constant c_mul : R_Type_Constant := (
		opcode => "01" & x"C", funct => "00" & x"2" 
	);
	--multiply and add
	constant c_madd : R_Type_Constant := (
		opcode => "01"&x"C", funct => (others => '0')
	);
	--unsigned multiply add
	constant c_maddu : R_Type_Constant := (
		opcode => "01"&x"C", funct => "00"&x"1"
	);
	--multiply subtract
	constant c_msub : R_Type_Constant := (
		opcode => "01"&x"C", funct => "00"&x"4"
	);
	--unsigned multiply subtract
	constant c_msubu : R_Type_Constant := (
		opcode => "01"&x"C", funct => "00"&x"5"
	);
	
	constant c_nor : R_Type_Constant := (
		opcode => (others => '0'), funct => "10"&x"7"
	);
	
	constant c_or : R_Type_Constant := (
		opcode => (others => '0'), funct => "10"&x"5"
	);
	--logical shift left
	constant c_sll : R_Type_Constant := (
		opcode => (others => '0'), funct => (others => '0')
	);
	--shift left logical variable
	constant c_sllv : R_Type_Constant := (
		opcode => (others => '0'), funct => "00"&x"4"
	);
	--shift right arithmetic
	constant c_sra : R_Type_Constant := (
		opcode => (others => '0'), funct => "00"&x"3"
	);
	--shift right arithmetic variable
	constant c_srav : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"7"
	);
	--shift right logical
	constant c_srl : R_Type_Constant := (
		opcode => (others => '0'), funct => "00"&x"2"
	);
	--shift right logical variable
	constant c_srlv : R_Type_Constant := (
		opcode => (others => '0'), funct => "00"&x"6"
	);
	--subtract with overflow
	constant c_sub : R_Type_Constant := (
		opcode => (others => '0'), funct => "10"&x"2"
	);
	--subtract without overflow
	constant c_subu : R_Type_Constant := (
		opcode => (others => '0'), funct => "10"&x"3"
	);
	
	constant c_xor : R_Type_Constant := (
		opcode => (others => '0'), funct => "10"&x"6"
	);
	
	------------------------------------------------------
	-----i type constants --------------------------------
	------------------------------------------------------
	subtype I_Type_Const is std_logic_vector(c_op_bits - 1 downto 0);
	constant c_addi  : I_Type_Const := "00" & x"8";
	constant c_addiu : I_Type_Const := "00" & x"9";
	constant c_andi  : I_Type_Const := "00" & x"C";
	constant c_ori   : I_Type_Const := "00" & x"D"; --immediate or
	constant c_xori  : I_Type_Const := "00" & x"E";
	------------------------------------------------------
	
	--type for r type registers
	type R_Type is record
		opcode : std_logic_vector(c_op_bits - 1 downto 0);
		rs     : std_logic_vector(c_instr_bits - 1 downto 0);
		rt     : std_logic_vector(c_instr_bits - 1 downto 0);
		rd     : std_logic_vector(c_instr_bits - 1 downto 0);
		shamt  : std_logic_vector(c_instr_bits - 1 downto 0);
		funct  : std_logic_vector(c_op_bits - 1 downto 0);
	end record;
	-- i type registers
	type I_Type is record
		opcode    : std_logic_vector(c_op_bits - 1 downto 0);
		rs        : std_logic_vector(c_instr_bits - 1 downto 0);
		rt        : std_logic_vector(c_instr_bits - 1 downto 0);
		immediate : std_logic_vector(c_immed_bits - 1 downto 0);
	end record;
	--j type registers
	type J_Type is record
		opcode  : std_logic_vector(c_op_bits - 1 downto 0);
		address : std_logic_vector(c_address_bits - 1 downto 0);
	end record;

end package Instructions_pack;

package body Instructions_pack is
end package body Instructions_pack;
