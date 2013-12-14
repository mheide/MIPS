library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
		rst_i      : in  std_logic;
		A_i        : in  std_logic_vector(31 downto 0);
		B_i        : in  std_logic_vector(31 downto 0);
		ALU_ctrl_i : in  std_logic_vector(3 downto 0);
		C_o        : out std_logic_vector(31 downto 0);
		zero_o     : out std_logic
	);
end entity ALU;

architecture Behavioral of ALU is
	constant c_add   : std_logic_vector(3 downto 0)  := "0010";
	constant c_sub   : std_logic_vector(3 downto 0)  := "0110";
	constant c_and   : std_logic_vector(3 downto 0)  := "0000";
	constant c_or    : std_logic_vector(3 downto 0)  := "0001";
	constant c_error : std_logic_vector(31 downto 0) := (others => 'X');
	constant c_zero  : std_logic_vector(31 downto 0) := (others => '0');

	signal C_temp : std_logic_vector(31 downto 0);

begin
	zero_o <= '1' when C_temp = c_zero else '0';
	C_o    <= C_temp;

	ALU : process(rst_i) is
	begin
		if rst_i = '1' then
			C_o <= (others => '0');
		else
			case ALU_ctrl_i is
				when c_add  => C_temp <= std_logic_vector(signed(A_i) + signed(B_i));
				when c_sub  => C_temp <= std_logic_vector(signed(A_i) - signed(B_i));
				when c_and  => C_temp <= A_i and B_i;
				when c_or   => C_temp <= A_i or B_i;
				when others => C_temp <= c_error;
			end case;
		end if;
	end process ALU;

end architecture Behavioral;
