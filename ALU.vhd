library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Instructions_pack.all;

entity ALU is
	port(
		rst_i      : in  std_logic;
		A_i        : in  std_logic_vector(31 downto 0);
		B_i        : in  std_logic_vector(31 downto 0);
		ALU_ctrl_i : in  alu_code;
		shamt_i	   : in  std_logic_vector(4 downto 0);  	--needed for bitshifts
		compare_i  : in  std_logic;
		C_o        : out std_logic_vector(31 downto 0);
		negative_o : out std_logic;
		zero_o     : out std_logic
	);
end entity ALU;

architecture Behavioral of ALU is

	constant c_alu_error : std_logic_vector(31 downto 0) := (others => 'X');
	constant c_alu_zero  : std_logic_vector(31 downto 0) := (others => '0');

	signal C_temp : std_logic_vector(31 downto 0);

begin
	zero_o <= '1' when C_temp = c_alu_zero else '0';
	negative_o <= C_temp(31);
	
	--compare: negative flag as output 
	C_o    <= C_temp when compare_i = '0' else c_alu_zero(31 downto 1) & C_temp(31); 
	
	ALU : process(rst_i, ALU_ctrl_i, A_i, B_i, shamt_i) is
	begin
		if rst_i = '1' then
			C_temp <= (others => '0');
		else
			case ALU_ctrl_i is
				when c_alu_add  => C_temp <= std_logic_vector(signed(A_i) + signed(B_i));
				when c_alu_addu => C_temp <= std_logic_vector(unsigned(A_i) + unsigned(B_i));
				when c_alu_sub  => C_temp <= std_logic_vector(signed(A_i) - signed(B_i));
				when c_alu_subu => C_temp <= std_logic_vector(unsigned(A_i) - unsigned(B_i));				
				when c_alu_and  => C_temp <= A_i and B_i;
				when c_alu_or   => C_temp <= A_i or B_i;
				when c_alu_nor  => C_temp <= A_i nor B_i;
				when c_alu_xor  => C_temp <= A_i xor B_i;	
				when c_alu_sllv => C_temp <= std_logic_vector(shift_left(unsigned(B_i), to_integer(unsigned(A_i(4 downto 0)))));
				when c_alu_srlv => C_temp <= std_logic_vector(shift_right(unsigned(B_i), to_integer(unsigned(A_i(4 downto 0)))));
				when c_alu_sll  => C_temp <= std_logic_vector(shift_left(unsigned(B_i), to_integer(unsigned(shamt_i))));
				when c_alu_srl  => C_temp <= std_logic_vector(shift_right(unsigned(B_i), to_integer(unsigned(shamt_i))));
				when c_alu_sra  => C_temp <= std_logic_vector(shift_right(signed(B_i), to_integer(unsigned(shamt_i))));
				when c_alu_srav => C_temp <= std_logic_vector(shift_right(signed(B_i), to_integer(unsigned(A_i(4 downto 0)))));
				when others => C_temp <= c_alu_error;
			end case;
		end if;
	end process ALU;

end architecture Behavioral;
