library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.function_package.all;
entity controller is
	port (
		clk : in std_logic;
		reset : in std_logic;
		load_key : in std_logic;
		start : in std_logic := '0';
		init_key : in std_logic_vector(0 to 127);
		key_out : out std_logic_vector(0 to 127);
		key_done : out std_logic;
		done : out std_logic
	);
end controller;

architecture dataflow of controller is	
constant round_constants : std_logic_vector(0 to 87) := x"0001020408102040801b36";	 	     
	signal round_constant : std_logic_vector(0 to 7);    
	signal substituted_round_key : std_logic_vector(0 to 31);
	signal round_key : std_logic_vector(0 to 127);
	signal fullKey : std_logic_vector(0 to 127);
	signal counter : integer := 0;
					
begin	
	generate_sbox : for i in 12 to 15 generate
		sbox_entity : entity work.Sbox	   
			port map(
				dataIn  => init_key(i*8 to (i + 1)*8 - 1),
				encrypt => '0',
				dataOut => substituted_round_key((i - 12)*8 to (i + 1 - 12)*8 - 1)
			);			
	end generate generate_sbox; 
	
			
	key_out <= (init_key(0 to 7) XOR round_constants(  (8*counter) to (counter + 1)*8  - 1) XOR substituted_round_key(8 to 15)) & (init_key(8 to 31) XOR (substituted_round_key(16 to 31) & substituted_round_key(0 to 7)))
				& (init_key(32 to 63) XOR (init_key(0 to 7) XOR round_constants(  (8*counter) to (counter + 1)*8  - 1) XOR substituted_round_key(8 to 15)) & (init_key(8 to 31) XOR (substituted_round_key(16 to 31) & substituted_round_key(0 to 7))))
				& (init_key(64 to 95) XOR init_key(32 to 63) XOR (init_key(0 to 7) XOR round_constants(  (8*counter) to (counter + 1)*8  - 1) XOR substituted_round_key(8 to 15)) & (init_key(8 to 31) XOR (substituted_round_key(16 to 31) & substituted_round_key(0 to 7))))
				& (init_key(96 to 127) XOR init_key(64 to 95) XOR init_key(32 to 63) XOR (init_key(0 to 7) XOR round_constants(  (8*counter) to (counter + 1)*8  - 1) XOR substituted_round_key(8 to 15)) & (init_key(8 to 31) XOR (substituted_round_key(16 to 31) & substituted_round_key(0 to 7))));
	round_constant <= round_constants(  (8*counter) to (counter + 1)*8  - 1) when load_key = '1' ; 
	key_done <= '1' when ( load_key = '1' AND round_constant = round_constants(  (8*counter) to (counter + 1)*8  - 1)) else '0';		
		done <= '1' when round_constant = x"36" else '0';
		process(load_key,reset) is

	begin	

		counter <= 0 when (reset = '1' or counter = 10)  else  counter +1 when( load_key ='1');
		--report "rkey: " &  to_hstring(round_key);
	end process;  		
		
end architecture dataflow;