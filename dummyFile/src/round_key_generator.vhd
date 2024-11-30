library ieee;
use ieee.std_logic_1164.all;

entity round_key_generator is
	port (		
		inputKey : in std_logic_vector(0 to 127);
		round_constant : in std_logic_vector(7 downto 0);
		next_key : out std_logic_vector(127 downto 0)		
	);
end round_key_generator;


architecture struct of round_key_generator is  
	
	signal substituted_round_key : std_logic_vector(0 to 31); --temp signal after substiting last word
	signal shifted_round_key : std_logic_vector(0 to 31); --temp signal after shift (rotate)
	signal word_0, word_1, word_2, word_3 : std_logic_vector(0 to 31);
begin						
	--only generate sboxs for last word of key
	generate_sbox : for i in 12 to 15 generate
		sbox_entity : entity work.Sbox
			port map(
			x  => inputKey(i*8 to (i + 1)*8 - 1),	   
			y => '0',
				z => substituted_round_key((i - 12)*8 to (i + 1 - 12)*8 - 1)
			);			
	end generate generate_sbox; 
	
	
	shifted_round_key <= substituted_round_key(8 to 31) & substituted_round_key(0 to 7); 
	--last 3 bytes don't need round constant
	word_0(8 to 31) <= inputKey(8 to 31) XOR shifted_round_key(8 to 31);	 
	--first byte needs round constant
    word_0(0 to 7) <= inputKey(0 to 7) XOR round_constant XOR shifted_round_key(0 to 7);
    word_1 <= inputKey(64 to 95) XOR word_0;
    word_2 <= inputKey(32 to 63) XOR word_1;
    word_3 <= inputKey(0 to 31) XOR word_2;
	next_key <= word_0 & word_1 & word_2 & word_3;
		
end architecture struct;
