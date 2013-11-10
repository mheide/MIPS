library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_counter is
	generic(
		c_reg_size : natural := 32
	);
	port(
		clk_i       : in  std_logic;
		rst_i       : in  std_logic;
		enable_i    : in  std_logic;
		PCSrc_i     : in  std_logic; -- null for r-instructions
		jump_addr_i : in  std_logic_vector(c_reg_size downto 0); --null in this implementation
		PC_o        : out std_logic_vector(c_reg_size - 1 downto 0)
	);
end pc_counter;

architecture behavior of pc_counter is
	signal pc : std_logic_vector(c_reg_size - 1 downto 0) := (others => '0');
begin
	PC_cntr : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			pc <= (others => '0');
		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				pc <= std_logic_vector( unsigned(pc) + 4 );
				if PCSrc_i = '0' then
					pc <= std_logic_vector( unsigned(pc) + 4 );
				else
					pc <= jump_addr_i;
				end if;
			end if;
		end if;
	end process PC_cntr;

	PC_o <= pc;

end architecture behavior;
