library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExtend is
	port(
			address_i : in std_logic_vector(15 downto 0);

			address_o : out std_logic_vector(31 downto 0)
			
	);
end entity signExtend;

architecture behaviour of signExtend is
begin
	address_o <= std_logic_vector(resize(unsigned(address_i), 32));
	


end architecture behaviour;