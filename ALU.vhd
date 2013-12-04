library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(
		c_reg_size : natural := 32
	);
	port(
		clk_i      : in  std_logic;
		rst_i      : in  std_logic;
		A_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
		B_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
		ALU_ctrl_i : in  std_logic_vector(3 downto 0);
		C_o        : out std_logic_vector(c_reg_size - 1 downto 0);
		zero_o     : out std_logic
	);
end entity ALU;

architecture Behavioral of ALU is
	constant c_add   : std_logic_vector(3 downto 0)              := "0010";
	constant c_sub   : std_logic_vector(3 downto 0)              := "0110";
	constant c_and   : std_logic_vector(3 downto 0)              := "0000";
	constant c_or    : std_logic_vector(3 downto 0)              := "0001";
	constant c_error : std_logic_vector(c_reg_size - 1 downto 0) := (others => 'X');
	constant c_zero  : std_logic_vector(c_reg_size - 1 downto 0) := (others => '0');

begin
	zero_o <= '1' when C_o = c_zero else '0';

	ALU : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			C_o <= (others => '0');
		elsif rising_edge(clk_i) then
			case ALU_ctrl_i is
				when c_add  => C_o <= std_logic_vector(signed(A_i) + signed(B_i));
				when c_sub  => C_o <= std_logic_vector(signed(A_i) - signed(B_i));
				when c_and  => C_o <= A_i and B_i;
				when c_or   => C_o <= A_i or B_i;
				when others => C_o <= c_error;
			end case;
		end if;
	end process ALU;

end architecture Behavioral;
