library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	  


entity counter is
	port (
		clk : in std_logic;
		reset : in std_logic;	   --asynch
		start : in std_logic;	   --commences count from state 0
		count_done : out std_logic --lasts 1 clk cycle
	);
end counter;
  

architecture dataFlow of counter is			
signal A,B,C,D : std_logic := '0';
signal state : std_logic_vector(0 to 3);
	
begin
state <= A & B & C & D when (clk = '1' and clk'event);

A <= 	'0' when reset <= '1' else
	 	'1' when state = ("0111" or "1000") 
		else '0'; 
	
B <= 	'0' when reset <= '1' else
		'1' when state = ("0011" or "0100" or "0101" or "0110") 
		else '0'; 
	
C <= 	'0' when reset <= '1' else
		'1' when state = ("0001" or "0010" or "0101" or "0110") 
		else '0'; 
	
D <= 	'0' when reset <= '1' else
		'1' when (state = ("0010" or "0100" or "0110" or "1000")) or (state = "0000" and start = '1')  
		else '0'; 
	
count_done <= 	'1' when (state = "1001" and clk = '1' and clk'event) else 
				'0' when (state = "0000" and clk = '1' and clk'event);
	
			
end architecture dataflow;