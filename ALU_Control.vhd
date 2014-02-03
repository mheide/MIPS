library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Instructions_pack.all;



entity ALU_Control is
	port(
		rst_i          : in  std_logic;
		ALU_Op_i       : in  std_logic_vector(1 downto 0);
		functioncode_i : in  std_logic_vector(5 downto 0);
		op_i		   : in  std_logic_vector(5 downto 0);
		alu_code_o     : out alu_code
	);
end entity ALU_Control;

architecture RTL of ALU_Control is
	
	signal rtype_alu_code : alu_code;
	signal itype_alu_code : alu_code;
	signal alu_code_10    : alu_code;	

begin
	alu_code_o <= alu_code_10 when ALU_Op_i(1) = '1' else
					c_alu_add when ALU_Op_i = "00" else
					c_alu_error;

	alu_code_10 <= 	rtype_alu_code when op_i = "000000" else		--itype or rtype
					itype_alu_code;	
				
	itype_alu_code <= 	c_alu_add  when op_i = c_addi else		--determinaton itype
						c_alu_addu when op_i = c_addiu else
						c_alu_and  when op_i = c_andi  else
						c_alu_or   when op_i = c_ori  else
						c_alu_xor  when op_i = c_xori else
						c_alu_zero;		--don't care

	--with functioncode_i select rtype_alu_code <=
	--	c_alu_add when c_add.funct,		--add
	--	c_alu_addu when c_addu.funct,	--addu
	--	c_alu_sub when c_sub.funct,		--sub
	--	c_alu_subu when c_subu.funct,	--subu
	--	c_alu_and when c_and.funct,		--and
	--	c_alu_or  when c_or.funct,		--or
	--	c_alu_nor when c_nor.funct,		--nor
	--	c_alu_xor when c_xor.funct,		--xor
	--	c_alu_error when others;
	
	rtype_alu_code <= c_alu_add  when functioncode_i = c_add.funct  else	--determination rtype
		              c_alu_addu when functioncode_i = c_addu.funct else
		              c_alu_sub  when functioncode_i = c_sub.funct  else
		              c_alu_subu when functioncode_i = c_subu.funct else
		              c_alu_and  when functioncode_i = c_and.funct  else
		              c_alu_or   when functioncode_i = c_or.funct   else
		              c_alu_nor  when functioncode_i = c_nor.funct  else
		              c_alu_xor  when functioncode_i = c_xor.funct  else
					  c_alu_sllv when functioncode_i = c_sllv.funct else
					  c_alu_srlv when functioncode_i = c_srlv.funct else
					  c_alu_sll  when functioncode_i = c_sll.funct  else
					  c_alu_srl  when functioncode_i = c_srl.funct  else
					  c_alu_sra  when functioncode_i = c_sra.funct  else
					  c_alu_srav when functioncode_i = c_srav.funct else					  
		              c_alu_error;
end architecture RTL;
