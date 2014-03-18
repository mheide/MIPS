library ieee;
use ieee.std_logic_1164.all;

entity MemRegLock is

	port(
		clk_i 		: in std_logic;
		rst_i 		: in std_logic;
		jump_flag_i : in std_logic;
		memWrite_i  : in std_logic; --3 cycles
		regWrite_i  : in std_logic; --3 cycles
		
		jump_flag_o : out std_logic;
		memWrite_o  : out std_logic;
		regWrite_o  : out std_logic
	);
end MemRegLock;	
	
architecture behaviour of MemRegLock is
	
	type lock_states is (unlocked, lock1, lock2, lock3);
	signal state : lock_states := unlocked;

	signal noLock : std_logic := '1';
	signal noLockLink : std_logic := '1';
	
begin



	lock_machine : process(clk_i, rst_i) is
	begin
			if rst_i = '1' then 
				state <= unlocked;
				noLock <= '1';				
			elsif rising_edge(clk_i) then
				case state is
					when unlocked =>
						if jump_flag_i = '1' then 
							--if regwrite_i = 1 then link 
							if regWrite_i = '1' then 
								noLockLink <= '1';							
							else							
								noLockLink <= '0';
							end if;
							
							state <= lock1;
							noLock <= '0';
						end if;
						
					when lock1 => 
						noLock <= '0';
						noLockLink <= '0';
						state <= lock2;
					
					
					when lock2 => 
						noLock <= '0';
						noLockLink <= '0';
						state <= lock3;	

					when lock3 => 
						noLock <= '1';
						noLockLink <= '1';
						state <= unlocked;
				end case;
		end if;
	end process lock_machine;
	
	
	jump_flag_o <= jump_flag_i and noLock;
	memWrite_o <= memWrite_i and noLock;
	regWrite_o <= regWrite_i and noLockLink;

end architecture behaviour;

		
		


