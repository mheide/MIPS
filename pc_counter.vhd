library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_counter is
	port(
		clk_i       : in  std_logic;
		rst_i       : in  std_logic;
		enable_i    : in  std_logic;
		PCSrc_i     : in  std_logic_vector(1 DOWNTO 0);
		jump_flag_i : in  std_logic;
		jump_addr_i : in  std_logic_vector(31 downto 0); --null in this implementation
		PC_o        : out std_logic_vector(31 downto 0)
	);
end pc_counter;
--TODO:use ALU for counter
architecture behavior of pc_counter is
	signal pc : std_logic_vector(31 downto 0) := (others => '0');
begin
	PC_cntr : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			pc <= (others => '0');
		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				if jump_flag_i = '1' then
					if PCSrc_i = "00" then
					-- auswahl welche quelle
					end if;
				else
					pc <= std_logic_vector(unsigned(pc) + 4);
				end if;
			end if;
		end if;
	end process PC_cntr;

	PC_o <= pc;

end architecture behavior;
