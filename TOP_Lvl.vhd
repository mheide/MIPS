library ieee;
use ieee.std_logic_1164.all;

entity TOP_Lvl is
	port (
		clk_i : in std_logic;
		rst_i : in std_logic
	);
end entity TOP_Lvl;

architecture RTL of TOP_Lvl is
	component ALU
		generic(c_reg_size : natural := 32);
		port(clk_i      : in  std_logic;
			 rst_i      : in  std_logic;
			 A_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
			 B_i        : in  std_logic_vector(c_reg_size - 1 downto 0);
			 ALU_ctrl_i : in  std_logic_vector(3 downto 0);
			 C_o        : out std_logic_vector(c_reg_size - 1 downto 0);
			 zero_o     : out std_logic);
	end component ALU;
	
	component ALU_Control
		port(clk_i      : in  std_logic;
			 rst_i      : in  std_logic;
			 ALU_Op_i   : in  std_logic_vector(1 downto 0);
			 opcode_i   : in  std_logic_vector(5 downto 0);
			 alu_code_o : out std_logic_vector(3 downto 0));
	end component ALU_Control;
begin

end architecture RTL;
