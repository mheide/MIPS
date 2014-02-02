library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture tb of tb_alu is


	component ALU is
		port(
			rst_i      : in  std_logic;
			A_i        : in  std_logic_vector(31 downto 0);
			B_i        : in  std_logic_vector(31 downto 0);
			ALU_ctrl_i : in  std_logic_vector(3 downto 0);
			shamt_i	   : in  std_logic_vector(4 downto 0);  	--needed for bitshifts
			C_o        : out std_logic_vector(31 downto 0);
			zero_o     : out std_logic
		);
	end component ALU;

	signal RST 		: std_logic  						:= '0';
	signal A 		: std_logic_vector(31 downto 0)		:= x"800000b3";
	signal B 		: std_logic_vector(31 downto 0)		:= x"8000000a";
	signal ALU_CTRL	: std_logic_vector(3 downto 0)		:= "0000";
	signal SHAMT	: std_logic_vector(4 downto 0)		:= "00100";
	signal C		: std_logic_vector(31 downto 0);
	signal ZERO	: std_logic;
	
	
	
begin

	dut: ALU
		port map(rst_i 		=> RST,
				A_i			=> A,
				B_i			=> B,
				ALU_ctrl_i 	=> ALU_CTRL,
				shamt_i		=> SHAMT,
				C_o 		=> C,
				zero_o 		=> ZERO);
	

	

	ctrl_generatoro : process is
	begin
		wait for 10 ns;		
		ALU_CTRL <= std_logic_vector(to_unsigned(to_integer(unsigned(ALU_CTRL)) + 1, 4));
	end process;		
		

end architecture;