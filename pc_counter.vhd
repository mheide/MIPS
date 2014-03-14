library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_counter is
	port(
		clk_i       : in  std_logic;
		rst_i       : in  std_logic;
		enable_i    : in  std_logic;
		PCWrite_i   : in  std_logic;
		jump_flag_i : in  std_logic;
		jump_addr_i : in  std_logic_vector(31 DOWNTO 0);
		PC_o        : out std_logic_vector(31 downto 0)
	);
end pc_counter;

architecture behavior of pc_counter is
	signal pc : std_logic_vector(31 downto 0) := (others => '0');
begin
	PC_cntr : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			pc <= (others => '0');
		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				if jump_flag_i = '1' or PCWrite_i = '1' then
					pc <= jump_addr_i;
				else
					pc <= std_logic_vector(unsigned(pc) + 4);
				end if;
			end if;
		end if;
	end process PC_cntr;

	PC_o <= pc;

end architecture behavior;
