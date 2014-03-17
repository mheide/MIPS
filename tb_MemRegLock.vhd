library ieee;
use ieee.std_logic_1164.all;

entity tb_MemRegLock is

end tb_MemRegLock;

architecture tb of tb_MemRegLock is

component MemRegLock is
	port(
		clk_i 		: in std_logic;
		rst_i 		: in std_logic;
		enable_i 	: in std_logic;
		jump_flag_i : in std_logic;
		memWrite_i  : in std_logic; --3 cycles
		regWrite_i  : in std_logic; --4 cycles
		link_flag_i : in std_logic;
		
		jump_flag_o : out std_logic;
		memWrite_o  : out std_logic;
		regWrite_o  : out std_logic
	);
end component MemRegLock;

	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal ENABLE : std_logic := '1';
	constant PERIOD : time := 20 ns; 
	
	signal JUMP_FLAG_I : std_logic := '0';
	signal MEMWRITE_I : std_logic := '0';
	signal REGWRITE_I : std_logic := '0';
	signal LINKFLAG_I : std_logic := '0';
	signal JUMP_FLAG_O : std_logic;
	signal MEMWRITE_O : std_logic;
	signal REGWRITE_O : std_logic;

	
begin

	dut : MemRegLock
	port map(
		clk_i 		=> CLK,
		rst_i		=> RST,
		enable_i 	=> ENABLE,
		jump_flag_i => JUMP_FLAG_I,
		memWrite_i  => MEMWRITE_I,
		regWrite_i  => REGWRITE_I,
		link_flag_i => LINKFLAG_I,
		jump_flag_o => JUMP_FLAG_O,
		memWrite_o  => MEMWRITE_O,
		regWrite_o  => REGWRITE_O
	);

	JUMP_FLAG_I <= '1' after 25 ns, '0' after 45 ns, '1' after 65 ns, '0' after 105 ns,
	'1' after 145 ns, '0' after 185 ns;
	MEMWRITE_I <= '1' after 43 ns, '0' after 102 ns;
	REGWRITE_I <= '1' after 43 ns, '0' after 130 ns;
	LINKFLAG_I <= '1' after 145 ns;
	

	clock_generator : process is
	begin
		CLK <= '0';
		wait for PERIOD/2;
		CLK <= '1';
		wait for PERIOD/2;
	end process;

end architecture;