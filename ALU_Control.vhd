library ieee;
use ieee.std_logic_1164.all;

entity ALU_Control is
	port(
		rst_i      : in  std_logic;
		ALU_Op_i   : in  std_logic_vector(1 downto 0);
		functioncode_i   : in  std_logic_vector(5 downto 0);
		alu_code_o : out std_logic_vector(3 downto 0)
	);
end entity ALU_Control;

architecture RTL of ALU_Control is
begin
	decode : process(rst_i) is
	begin
		if rst_i = '1' then
			-- alu code for and
			alu_code_o <= (others => '0');
		else
			case ALU_Op_i(1) is
				when '1' =>
					case functioncode_i is
						when "100000" => alu_code_o <= "0010"; --add
						when "100010" => alu_code_o <= "0110"; -- sub
						when "100100" => alu_code_o <= "0000"; --and
						when "100101" => alu_code_o <= "0001"; --or
						when others   => alu_code_o <= (others => 'X'); --error code
					end case;
				when '0'    => alu_code_o <= (others => 'Z'); -- TODO do not care
				when others => alu_code_o <= (others => 'X'); -- error code
			end case;
		end if;
	end process decode;

end architecture RTL;
