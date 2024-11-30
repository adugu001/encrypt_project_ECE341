--IGNORE THIS FOR NOW. NOT BEHAVIORAL

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	  


entity key_schedule is
	port (
		clk : in std_logic;
		reset : in std_logic; --assuming we need a reset
		key : in std_logic_vector(0 to 127);	--full key
		round_const : in std_logic_vector(0 to 7);	--single round byte (unimplemented so far)
		round_key : out std_logic_vector(0 to 127) --output one round key 
	);
end key_schedule;
  

architecture behavioral of key_schedule is			

	signal reg_in : std_logic_vector(0 to 127);
	signal reg_out : std_logic_vector(0 to 127);
	signal previous_round_key : std_logic_vector(0 to 127);	
	
begin
	--Should I convert this to something with a process?
			
	reg_in <= key when reset = '0' else previous_round_key;	  
	--store full key in generic register map
	registers : entity work.dffreg			  
		generic map(size => 128) port map(clk => clk,d   => reg_in,q   => reg_out);	
			
		round_key_generator_entity : entity work.round_key_generator
		port map(
			inputKey      => reg_out,
			round_constant => round_const,
			next_key => previous_round_key
		);	 
		
	round_key <= reg_out;
			
			
			
			
			
end architecture behavioral;