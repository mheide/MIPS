library ieee;
use ieee.std_logic_1164.all;

entity MemRegLock is

	port(
		clk_i 		: in std_logic;
		rst_i 		: in std_logic;
		enable_i 	: in std_logic;
		jump_flag_i : in std_logic;
		memWrite_i  : in std_logic; --3 cycles
		regWrite_i  : in std_logic; --4 cycles
		link_flag_i : in std_logic; -- link
		
		jump_flag_o : out std_logic;
		memWrite_o  : out std_logic;
		regWrite_o  : out std_logic
	);
end MemRegLock;	
	
architecture behaviour of MemRegLock is

	signal firstStage : std_logic := '0';
	signal secondStage : std_logic := '0';
	signal thirdStage : std_logic := '0';
	signal fourthStage : std_logic := '0';
	
	signal firstStageLinkFlag : std_logic := '0';
	
	signal regOut : std_logic := '0';
	signal memOut : std_logic := '0';

begin

	memOut <= firstStage or secondStage or thirdStage;
	regOut <= memOut or fourthStage;
	
	memWrite_o <= memWrite_i and (not memOut);
	
	jump_flag_o <= jump_flag_i and (not regOut); --regOut locks for 4 cycles
	
	--only if firstStage = 1 ==> previous instruction was jump and link
	regWrite_o <= '1' when firstStageLinkFlag = '1' ELSE
					regWrite_i and (not regOut);
	--regWrite_o <= regWrite_i and (not regOut);	--without link

	lock : process(clk_i, rst_i) is
	begin
		if rst_i = '1' then
			firstStage <= '0';
			secondStage <= '0';
			thirdStage <= '0';
			fourthStage <= '0';
			firstStageLinkFlag <= '0';
		elsif rising_edge(clk_i) then
			if enable_i = '1' then
				if memOut = '0' then --new valid instruction possible
					firstStage <= jump_flag_i;
					firstStageLinkFlag <= link_flag_i;
				else
					firstStage <= '0';
					firstStageLinkFlag <= '0';
				end if;
				secondStage <= firstStage;
				thirdStage <= secondStage;
				fourthStage <= thirdStage;
			end if;
		end if;
	end process lock;

end architecture behaviour;

		
		


