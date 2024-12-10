library ieee;
use ieee.std_logic_1164.all;


entity simple_register_128 is
	port(clk: in std_logic;	Clr: in std_logic; Ld: in std_logic; 
		 D: in std_logic_vector(0 to 127);
	     Qout: out std_logic_vector(0 to 127));
end simple_register_128;

architecture overload of simple_register_128 is	
-- the following declaration allows us to use the array range of Qout
--  to declare its array range
signal Q: std_logic_vector(Qout'range);
begin	   
	process(clk)
	begin 	 
		-- note the use of the 'last_value attribute
		-- to confirm the previous value of the clock
		if( clk'event and clk'last_value='0' and clk='1') then
			if(clr='1') then Q<=(others => '0');
			elsif(Ld='1') then Q<=D;
			end if;
		end if;
	end process;
	Qout<=Q;
end overload;