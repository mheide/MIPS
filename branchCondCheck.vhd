library ieee;
use ieee.std_logic_1164.all;
use work.Instructions_pack.all;

entity branchCondCheck is 
	port(
		branch_i 		: in std_logic;
		branchCond_i	: in branch_condition;
		zero_i			: in std_logic;
		negative_i	 	: in std_logic;
		PCWrite_i 		: in std_logic;
		
		jump_flag_o		: out std_logic
	);
end branchCondCheck;

architecture behaviour of branchCondCheck is
	signal cond_success : std_logic;

begin	
	jump_flag_o <= PCWrite_i when branch_i = '0' else
				cond_success;
				
				
	cond_success <= zero_i 								when branchCond_i = bc_beq else
					(not zero_i) 						when branchCond_i = bc_bne else
					(not negative_i)  and (not zero_i)	when branchCond_i = bc_bgtz else
					(zero_i or negative_i) ; --bc_blez

end architecture behaviour;
