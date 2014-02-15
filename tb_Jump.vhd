library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Jump is
end entity tb_Jump;

architecture testbench of tb_Jump is
	component JumpAddrCompute
		port(
			clk_i      : in  std_logic;
			rst_i      : in  std_logic;
			jumpAddr_i : in  std_logic_vector(25 downto 0);
			pc_i       : in  std_logic_vector(31 downto 0);
			pc_o       : out std_logic_vector(31 downto 0));
	end component JumpAddrCompute;
	signal clk      : std_logic := '0';
	signal rst      : std_logic := '0';
	constant period : time      := 10 ns;

	signal jumpAddr : std_logic_vector(25 downto 0) := (others => '0');
	signal pc_in    : std_logic_vector(31 downto 0) := x"FFFFFFF0";--(others => '0');
	signal pc_out   : std_logic_vector(31 downto 0) := (others => '0');
begin
	rst <= '1', '0' after 10 ns;
	dut : JumpAddrCompute
		port map(clk_i      => clk,
			     rst_i      => rst,
			     jumpAddr_i => jumpAddr,
			     pc_i       => pc_in,
			     pc_o       => pc_out);

	clock_generator : process is
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_generator;

	stimulus : process(clk, rst) is
	begin
		if rst = '1' then
			jumpAddr <= (others => '0');
			pc_in    <= x"1FFFFF00";
		elsif rising_edge(clk) then
			jumpAddr <= "00" & x"000010";
			pc_in    <= std_logic_vector(unsigned(pc_in) + 4);
		end if;
	end process stimulus;

end architecture testbench;
