library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is                         --first pipeline stage with instruction_register
	port(
		clk_i         : in  std_logic;
		rst_i         : in  std_logic;
		enable_i      : in  std_logic;
		PC_ifid_i     : in  std_logic_vector(31 downto 0);

		Instruction_o : out std_logic_vector(31 DOWNTO 0);
		PC_ifid_o     : out std_logic_vector(31 downto 0)
	);
end entity IF_ID;

architecture behaviour of IF_ID is
	component Instruction_Memory
		port(
			pc_i  : in  std_logic_vector(31 DOWNTO 0);

			out_o : out std_logic_vector(31 DOWNTO 0)
		);
	end component;

	signal pc : std_logic_vector(31 DOWNTO 0);
	signal instruction : std_logic_vector(31 downto 0);

begin
	mem : Instruction_Memory
		port map(pc_i => PC_ifid_i, out_o => instruction);

	IF_ID_reg : process(clk_i, rst_i, enable_i) is
	begin
		if rst_i = '1' then
			Instruction_o <= (others => '0');
			pc <= (others => '0');
		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				Instruction_o <= instruction;
				pc <= PC_ifid_i;
			end if;
		end if;
	end process IF_ID_reg;

	PC_ifid_o <= pc;
end architecture;