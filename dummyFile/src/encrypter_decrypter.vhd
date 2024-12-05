library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity encrypter_decrypter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		encrypt : in std_logic;
		data_in : in std_logic_vector(0 to 127);
		start : in std_logic;
		init_key : in std_logic_vector(0 to 127); 
		data_to_main : out std_logic_vector(0 to 127);
		op_done : out std_logic;
	);
end encrypter_decrypter;

architecture dataflow of encrypter_decrypter is

signal state, nextState : integer := 0;
signal startKeyGen, finished_key : std_logic := '0';
signal roundKeys: work.function_package.dataStore;  
signal returned_key : std_logic_vector(0 to 127); 
signal temp_key : std_logic_vector(0 to 127); 
signal temp_data : std_logic_vector(0 to 127);
signal all_keys_done : std_logic;
signal stale : std_logic := '0';
signal key_counter : integer := 1;
signal enc_dec: std_logic;
signal data_return: std_logic_vector(0 to 127);
signal test : std_logic_vector(0 to 127);
begin
	key_controller : entity work.key_controller
	port map(	
		clk => CLK,
		reset => reset,
		start  => startKeyGen,
		load_key => startKeyGen,
		init_key => temp_key,
		key_out => returned_key,
		key_done => finished_key,
		done => all_keys_done, 
		round_constant => std_logic_vector(to_unsigned(key_counter,8))
		); 
	blackBox : entity work.blackBox
	port map(	
			dataIn => temp_data,
			encrypt => encrypt,
			roundKey => roundKeys, 
			dataOut => data_return
		); 	
	
	
p1: process(state,stale) is  
begin 
case state is
	when 0 => --start	
	temp_key <= init_key;
		roundKeys(0) <= init_key;
		enc_dec <= encrypt;
		nextState <= 1 when start = '1' else 0;
	when 1 => --load and forward key   
		startKeyGen<= '1';
		key_counter <= 1; 
		 nextState <= 2;
	when 2 => --hold in state 2 load keys until 10 keys
		  roundKeys(key_counter) <= returned_key;
		  key_counter<= key_counter+1  when key_counter <10;
			nextState <= 3 when key_counter = 10 else 2;
			temp_key <= returned_key;
	when 3 => --start encrypt/decrypt 
	temp_data <= data_in;
	nextState <=4;
	when 4 => --get result
	data_to_main <= data_return;
	op_done <= '1';
	when 10 => --reset 
	op_done <= '0';
	key_counter <= 1; 
	data_to_main <= (others => '0');
		nextState <= 0;
	when others => null;
	end case;
end process;


state_process : process(clk, reset) is	
begin
		if RESET = '1' then
			State <= 10;
		elsif CLK'event and CLK = '1' then
			if (state = nextState)then
				stale <= not stale;
				else
				state <= nextstate;	  
				end if;
			  
		end if;
end process;

end architecture;