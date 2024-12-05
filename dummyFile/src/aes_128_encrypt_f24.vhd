library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.function_package.all;

entity AES_128_encrypt_f24 is
  port(
    clk, reset : in    std_logic;
    start      : in    std_logic;
    key_load   : in    std_logic;
    IV_load    : in    std_logic;
    db_load    : in    std_logic;
    stream     : in    std_logic;
    Encrypt    : in    std_logic;
    CBC_mode   : in    std_logic;
    dataIn     : in    std_logic_vector(0 to 31); -- bus used to input data
    dataOut    : out   std_logic_vector(0 to 31); -- bus used output data
    Done       : out   std_logic
    );

end entity AES_128_encrypt_f24;	 
-- Signals:
-- clk: used to synchronous all state updates.

-- reset: asynchronous, active high.

-- start: signal turned on when we are starting a new encryption.

-- key_load: after the start signal has been turned on, when this signal is turned on,
--           you input the key, 32 bits at a time on 6 successive clocks. This signal is
--           ignored after the key is loaded until the next time the start signal is turned on.

-- IV_load: after start, input four 32 bit words on successive clocks for the initial value. Should
--          encryption proceed without an IV specified, the IV is all zeros

-- db_load: when inputting data on dataIn, input four 32 bit words in successive clocks.

-- stream: when stream is turned on, once the key/IV have been input, the encryption
--         will continue for success blocks as specified by ECB and CBC modes.

-- ECB_mode: electronic code book. Blocks are encrypted independently using the same original
--           key/IV.

-- CBC_mode: cypher block chaining. Cyphertext of current block is IV for next block.

-- Done    : output that is turned on when the data is encrypted.  The first word of the cyphertext
--         is output when Done is turned on and the remaining are output on the next three clocks.

-- Advanced challenge 1: use a single bidirectional data bus instead of separate input and output busses.
--      You are permitted to add control signals.

architecture behavioral of AES_128_encrypt_f24 is
signal state, nextstate, NextStateReset: integer := 0;
signal stale : std_logic := '0';  
begin	
p1 : process(state, stale, reset) is  
variable fullData, fullkey, result_matrix, IV, temp : std_logic_vector(0 to 127) := (others => '0');
variable roundKeys: key_store;  	
variable invert : std_logic := '0';
variable load_key, load_data, load_IV, output_data: std_logic := '0';

begin
	   	case state is --start experimental code
		   when 0 => --wait for start signal
			    if (start = '1') then nextstate <= 1;
				else nextstate <= 0;
				end if;	
				--report "state 0";
			when 1 => --load key
				if key_load = '1' then
					load_key := '1';
					temp(0 to 31) := dataIn;	
					nextstate <= 7;
				else nextstate <= 1;
				end if;
			 when 2 => --wait to load data
			 	if (db_load = '1' AND stream = '1') then 
				 	nextstate <= 4;
				else nextstate <= 2;
				end if;	 
				--report "state 2";
			when 3 =>  --load IV
				load_IV := '1';
				temp(0 to 31) := dataIn;	
				nextstate <= 7;	
				--report "state 3";
			when 4 =>  --load full data	
				if(db_load = '1') then
				load_Data := '1';
				temp(0 to 31) := dataIn;	
				nextstate <= 7;		 
				end if;	 
				--report "state 4";
			when 5 => --encrypt/decrypt	
			roundkeys := generateroundkeys(fullkey, not encrypt);
			fullData := fullData XOR IV;
				if encrypt = '1' then
					--key expansion--------------------------------------------------------------------------------------------------------  
					
					--encryption loop---------------------------------------------------------------------------------------------
					result_matrix := addRoundkey(fullData, fullkey);
					for i in 0 to 9 loop
						--report "round " & to_string(i) & "====================";
						--substitute in sbox 
						result_matrix := sbox(result_matrix, invert);
						--report "   after sbox : " & to_hstring(result_matrix);
						--shift rows 
						result_matrix := shiftRows(result_matrix, invert);
						--report "   after shift : " & to_hstring(result_matrix);
						--mix columns
						if(i  /=  9) then
							result_matrix := mixColumns(result_matrix, invert);
						end if;
						--report "   after mix : " & to_hstring(result_matrix);
						--add round key	except last round
						result_matrix := addRoundKey(result_matrix, roundKeys(i)); 	
						--report "   end value: " & to_hstring(result_matrix);
					end loop;																						
				else --start decryption	 
					result_matrix:= fullData;
					for i in 0 to 9 loop					 
						report "round " & to_string(i) & "====================";
						result_matrix := addRoundKey(result_matrix, roundKeys(i));
						report "after key value: " & to_hstring(result_matrix);
						if(i  /=  0) then
							result_matrix := mixColumns(result_matrix,(not encrypt));
						end if;		
						report "   after mix : " & to_hstring(result_matrix);
						result_matrix := shiftRows(result_matrix, not encrypt);
					   	result_matrix := sbox(result_matrix, not encrypt);
						report "   after sbox : " & to_hstring(result_matrix);
					end loop; 
					result_matrix := addRoundkey(result_matrix, fullkey);
				end if;
				nextstate <= 6;
				--report "state 5";
			when 6 => --output
				done <= '1';
				output_data := '1';
				dataOut <= result_matrix(0 to 31);	
				nextstate <= 7;	 
				--report "state 6";
			when 7 =>
				if output_data = '1' then
					dataOut <= result_Matrix(32 to 63);
				else
					temp(32 to 63) := dataIn;
				end if;					
			
				--report "state 7";
				nextstate <= 8;
			when 8 =>
				if output_data = '1' then
					dataOut <= result_Matrix(64 to 95);
				else
					temp(64 to 95) := dataIn;

				end if;						 
				nextstate <= 9;				
				--report "state 8";
			when 9 =>
				temp(96 to 127) := dataIn;
				if output_data = '1' then
					output_data := '0';	
					done <= '0';
					dataOut <= result_Matrix(96 to 127);
					if stream = '1' then
						if CBC_Mode = '1' then 
							IV := result_matrix; 
						end if;
						nextstate <= 2;
					else nextstate <= 0; end if;
				elsif load_key = '1' then
					fullkey := temp;
					if (IV_Load = '0') then nextstate <= 2;
					else nextstate <= 3;
					end if;
					load_key := '0';
				elsif load_IV = '1' then
					IV := temp;
					nextstate <= 2;
					load_IV := '0';
				elsif load_data = '1' then
					fulldata := temp;
					nextstate <= 5;
					load_data := '0';			
				end if;
				--report "state 9"; 
				when 10 =>
				if(reset ='1') then		
		fullKey := std_logic_vector(to_unsigned (0, 128));
		fullData  := std_logic_vector(to_unsigned (0, 128));	  
		result_matrix:= std_logic_vector(to_unsigned (0, 128));
		IV  := std_logic_vector(to_unsigned (0, 128));
		nextstate <= 0;
		temp := (others => '0');
end if;		
				when others => null;
		end case;		
		
end process;

CLK_process: process(CLK)
begin
		if RESET = '1' then
			State <= 10;
			NextStateReset <= 1;
		elsif CLK'event and CLK = '1' then
			if (state = nextState)then
				stale <= not stale;
				else
				state <= nextstate;	  
				end if;
			end if;
end process CLK_process; 


end architecture behavioral; 

architecture dataFlow of AES_128_encrypt_f24 is
type key_store is array (0 to 9) of std_logic_vector(0 to 127);
signal start_key_gen, keys_done, start_encrypt, encryption_done, stale: std_logic;
signal IR_IV, IR_KEY, IR_DATA, IR_OUTPUT, IR_CURRENT_ROUND_KEY : std_logic_vector(0 to 127);  
signal state, nextstate : integer;

begin
ENCRYPTOR : entity work.encrypter_decrypter 
	port map(
		clk => clk,
		reset => reset,
		encrypt => encrypt,
		data_in => IR_DATA,
		start => start_encrypt,
		init_key =>	IR_KEY,
		data_to_main => IR_OUTPUT,
		op_done => encryption_done
	);
PROCESS(state, stale) is	
begin
	case state is
		when 0 => 
			nextstate <= state + 1 when start = '1';
		when 1 => 									
			nextstate <= state + 1 when key_load = '1';
		when 2 => 
			IR_KEY(0 to 31) <= datain;
			nextstate <= state + 1;
		when 3 =>
			IR_KEY(32 to 63) <= datain;
			nextstate <= state + 1;
		when 4 => 
			IR_KEY(64 to 95) <= datain;
			nextstate <= state + 1;
		when 5 => 
			IR_KEY(96 to 127) <= datain;
			nextstate <= state + 1 when iv_load = '1' else 10;
		when 6 => 
			IR_IV(0 to 31) <= datain;
			nextstate <= state + 1;
		when 7 =>
			IR_IV(32 to 63) <= datain;
			nextstate <= state + 1;
		when 8 => 
			IR_IV(64 to 95) <= datain;
			nextstate <= state + 1;
		when 9 => 
			IR_IV(96 to 127) <= datain;
			nextstate <= state + 1;
		when 10 => 
			nextstate <= state + 1 when db_load = '1';
		when 11 =>
			IR_DATA(0 to 31) <= datain;
			nextstate <= state + 1;
		when 12 =>
			IR_DATA(32 to 63) <= datain;
			nextstate <= state + 1;
		when 13 => 
			IR_DATA(64 to 95) <= datain;
			nextstate <= state + 1;
		when 14 => 
			IR_DATA(96 to 127) <= datain;
			nextstate <= state + 1;
		when 15 => 
			nextstate <= state + 1 when encryption_done = '1';
		when 16 =>
			done <= '1';
			dataOut <= IR_OUTPUT(0 to 31);
			nextstate <= state + 1;
		when 17 => 
			dataOut <= IR_OUTPUT(32 to 63);
			nextstate <= state + 1;
		when 18 => 
			dataOut <= IR_OUTPUT(64 to 95);
			nextstate <= state + 1;
		when 19 => 
			done <= '0';
			dataOut <= IR_OUTPUT(96 to 127);
			nextstate <= 10 when stream = '1' else 0;
			IR_IV <= IR_OUTPUT when CBC_mode = '1';
		when others => null;
	END CASE;

END PROCESS;

CLK_PROCESS: process(CLK, reset)
begin
			if RESET = '1' then
				State <= 0;				
			elsif CLK'event and CLK = '1' then
				if (state = nextState)then
					stale <= not stale;
					else
					state <= nextstate;	  
					end if;
				end if;
END PROCESS CLK_PROCESS; 
	
end architecture dataflow;
-- Advanced challenge 2: use a single entity for both encryption and decryption.
--      You are permitted to add additional control signals.
