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
	constant c_addu : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"1"
	);
	constant c_and : R_Type_Constant := (
		opcode => "000000",
		funct  => "10" & x"4"
	);
	-- count leading ones
	constant c_clo : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => "10" & x"1"
	);
	-- count leading zeros
	constant c_clz : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => "10" & x"0"
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
		opcode => "01" & x"C",
		funct  => "00" & x"2"
	);
	--multiply and add
	constant c_madd : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => (others => '0')
	);
	--unsigned multiply add
	constant c_maddu : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => "00" & x"1"
	);
	--multiply subtract
	constant c_msub : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => "00" & x"4"
	);
	--unsigned multiply subtract
	constant c_msubu : R_Type_Constant := (
		opcode => "01" & x"C",
		funct  => "00" & x"5"
	);

	constant c_nor : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"7"
	);

	constant c_or : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"5"
	);
	--logical shift left
	constant c_sll : R_Type_Constant := (
		opcode => (others => '0'), funct => (others => '0')
	);
	--shift left logical variable
	constant c_sllv : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"4"
	);
	--shift right arithmetic
	constant c_sra : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"3"
	);
	--shift right arithmetic variable
	constant c_srav : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"7"
	);
	--shift right logical
	constant c_srl : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"2"
	);
	--shift right logical variable
	constant c_srlv : R_Type_Constant := (
		opcode => (others => '0'), funct => "00" & x"6"
	);
	--subtract with overflow
	constant c_sub : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"2"
	);
	--subtract without overflow
	constant c_subu : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"3"
	);

	constant c_xor : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"6"
	);
	--comparison instructions
	--set less than
	constant c_slt : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"A"
	);
	--set less than unsigned
	constant c_sltu : R_Type_Constant := (
		opcode => (others => '0'), funct => "10" & x"B"
	);

	------------------------------------------------------
	----Branch constants
	------------------------------------------------------
	type Branch_Type_Const is record
		opcode : std_logic_vector(c_op_bits - 1 downto 0);
		rt     : std_logic_vector(4 downto 0);
	end record;

	-- branch on greater than equal zero
	constant c_bgez : Branch_Type_Const := (
		opcode => "00" & x"1",
		rt     => "0" & x"1"
	);

	--branch on greater than equal zero and link
	constant c_bgezal : Branch_Type_Const := (
		opcode => "00" & x"1",
		rt     => "1" & x"1"
	);

	--branch on greater than zero
	constant c_bgtz : Branch_Type_Const := (
		opcode => "00" & x"7",
		rt     => (others => '0')
	);

	--branch on less than equal zero
	constant c_blez : Branch_Type_Const := (
		opcode => "00" & x"6",
		rt     => (others => '0')
	);

	--branch on less than zero and link
	constant c_bltzal : Branch_Type_Const := (
		opcode => "00" & x"1",
		rt     => "1" & x"0"
	);

	--branch on less than zero
	constant c_bltz : Branch_Type_Const := (
		opcode => "00" & x"1",
		rt     => (others => '0')
	);

	------------------------------------------------------
	-----i type constants --------------------------------
	------------------------------------------------------
	subtype OP_Type_Const is std_logic_vector(c_op_bits - 1 downto 0);

	constant c_addi  : OP_Type_Const := "00" & x"8";
	constant c_addiu : OP_Type_Const := "00" & x"9";
	constant c_andi  : OP_Type_Const := "00" & x"C";
	constant c_ori   : OP_Type_Const := "00" & x"D"; --immediate or
	constant c_xori  : OP_Type_Const := "00" & x"E";
	--constant manipulation: load upper immediate
	constant c_lui   : OP_Type_Const := "00" & x"F";
	--set less than
	constant c_slti  : OP_Type_Const := "00" & x"A";
	constant c_sltiu : OP_Type_Const := "00" & x"B";
	--load instructions
	--load byte
	constant c_lb    : OP_Type_Const := "10" & x"0";
	--load unsigned byte
	constant c_lbu   : OP_Type_Const := "10" & x"4";
	--load halfword
	constant c_lh    : OP_Type_Const := "10" & x"1";
	--load halfword unsigned
	constant c_lhu   : OP_Type_Const := "10" & x"5";
	--load word
	constant c_lw    : OP_Type_Const := "10" & x"3";
	--lw left
	constant c_lwl   : OP_Type_Const := "10" & x"2";
	--lw right
	constant c_lwr   : OP_Type_Const := "10" & x"6";
	--branching
	--branch on equal
	constant c_beq   : OP_Type_Const := "00" & x"4";
	--branch on not equal
	constant c_bne   : OP_Type_Const := "00" & x"5";

	------------------------------------------------------

	--type for r type instructions
	type R_Type is record
		opcode : std_logic_vector(c_op_bits - 1 downto 0);
		rs     : std_logic_vector(c_instr_bits - 1 downto 0);
		rt     : std_logic_vector(c_instr_bits - 1 downto 0);
		rd     : std_logic_vector(c_instr_bits - 1 downto 0);
		shamt  : std_logic_vector(c_instr_bits - 1 downto 0);
		funct  : std_logic_vector(c_op_bits - 1 downto 0);
	end record;

	-- i type instructions
	type I_Type is record
		opcode    : std_logic_vector(c_op_bits - 1 downto 0);
		rs        : std_logic_vector(c_instr_bits - 1 downto 0);
		rt        : std_logic_vector(c_instr_bits - 1 downto 0);
		immediate : std_logic_vector(c_immed_bits - 1 downto 0); --can used as offset value
	end record;

	--j type instructions
	type J_Type is record
		opcode  : std_logic_vector(c_op_bits - 1 downto 0);
		address : std_logic_vector(c_address_bits - 1 downto 0);
	end record;

end package Instructions_pack;

package body Instructions_pack is
end package body Instructions_pack;
