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
signal state, nextstate: integer range 0 to 6 := 0;
type roundConstants is array (0 to 39) of integer;
	signal rc : roundConstants := (
    (16#01#, 16#00#, 16#00#, 16#00#,
	16#02#,16#00#,16#00#,16#00#,
	16#04#,16#00#,16#00#,16#00#,
	16#08#,16#00#,16#00#,16#00#,
	16#10#,16#00#,16#00#,16#00#,
	16#20#,16#00#,16#00#,16#00#,
	16#40#,16#00#,16#00#,16#00#,
	16#80#,16#00#,16#00#,16#00#,
	16#1b#,16#00#,16#00#,16#00#,
	16#36#,16#00#,16#00#,16#00#
)
);

type mult_matrix is array (0 to 3, 0 to 3) of integer;
	signal mul : mult_matrix := (
    (2,3,1,1),
	(1,2,3,1),
	(1,1,2,3),
	(3,1,1,2)
);

  
  
impure function rc_LUT ( byte : in std_logic_vector(0 to 7)) return std_logic_vector is	
	variable count : integer := 0;
	variable newVector : std_logic_vector(0 to 7);	
	variable test : integer := 0;
	begin 
		--debug	
		report "test";
		test :=  rc(to_integer(unsigned(byte(0 to 7))) );
		report "Rc_lut " & to_string(test);
		newVector := std_logic_vector(to_unsigned(test, newVector'length));
		report to_string(newVector);
    return std_logic_vector(newVector);
end function; 

  
  
begin
	
p1 : process(clk,reset) is  

variable fullKey : std_logic_vector(0 to 127);
variable fullData : std_logic_vector(0 to 127);	
variable temp : std_logic_vector(0 to 127);



variable tt : integer := 0;	  
	

variable key_expansion_complete:  boolean:= false;
variable encryption_count : integer := 0; 
variable sub_counter : integer := 0;
variable temp_row : std_logic_vector(0 to 31); 
variable result_matrix: std_logic_vector(0 to 127);	 
variable col_count: integer:= 0;  
variable roundKeys: work.function_package.key_store;
variable rotate_matrix: std_logic_vector(0 to 127);
variable done_enc: boolean := false;

variable data_out_complete: boolean := false;
variable IV : std_logic_vector(0 to 127) := std_logic_vector(to_unsigned (0, 128));	
variable IV_load_count : integer:= 0;
variable IV_load_complete: boolean := false;

variable invert : std_logic := '0';


variable rc_return: std_logic_vector(0 to 7);
begin
if (reset = '0') then
   	case state is --start experimental code
	   when 0 => --wait for start signal
	   		if (start = '1' AND key_load = '1') then nextstate <= 1;
			else nextstate <= 0;
			end if;
		when 1 => --load key
			for i in 0 to 3 loop
				fullKey(i*32 to i*32 + 31) := dataIn;	
			end loop;
			report "full key: " & to_hstring(fullKey);
			if (IV_Load = '0') then nextstate <= 2;
			else nextstate <= 3;
			end if;
		 when 2 => --wait to load data
		 	if (db_load = '0' OR stream = '0') then nextstate <= 3;
			else nextstate <= 4;
			end if;
		when 3 =>  --load IV
			for i in 0 to 3 loop
				IV(i*32 to i*32 + 31) := dataIn;	
			end loop;
			report "full IV: " & to_hstring(IV);
			nextstate <= 2;
		when 4 =>  --load full data
			for i in 0 to 3 loop
				fullData(i*32 to i*32+31) := dataIn;  
			end loop;
			report "full data: " & to_hstring(fullData);
			nextstate <= 5;
		when 5 => --encrypt/decrypt
			if encrypt = '1' then
						--key expansion--------------------------------------------------------------------------------------------------------  
							tempWord := fullKey(96 to 127);
							expansionMatrix := fullKey;				
							for i in 0 to 9 loop	
							--Step 1: shift left 	
							tempWord := expansionMatrix(96 to 127);	 
							report "round " & to_string(i) & " b4: " & to_hstring(tempWord);
							tempWord(0 to 31) := tempWord rol 8;
							report "round " & to_string(i) & " b5: " & to_hstring(tempWord); 
							
							--Step 2: Sub bytes for those in sBox
							tempWord(0 to 7) := sbox_byte(tempWord(0 to 7), invert);	
							tempWord(8 to 15) := sbox_byte(tempWord(8 to 15), invert);	
							tempWord(16 to 23) := sbox_byte(tempWord(16 to 23), invert);	
							tempWord(24 to 31) := sbox_byte(tempWord(24 to 31), invert);	  
							
							report "round " & to_string(i) & " subbed: " & to_hstring(tempWord);
							
							--Step 3: add round constant 
							rc_return := rc_LUT(std_logic_vector(to_unsigned((rc_count*4),8)));		
							report "round " & to_string(i) & " rc_return: " & to_hstring(rc_return);
							tempWord(0 to 3) := std_logic_vector(tempWord(0 to 3) XOR rc_return(0 to 3));
							tempWord(4 to 7) := std_logic_vector(tempWord(4 to 7) XOR rc_return(4 to 7));
							
							
							--Step 4: add first column with new key		
							
							report "round " & to_string(i) & " beforexor: " & to_hstring(tempWord);
							tempWord(0 to 7) := std_logic_vector(unsigned(tempWord(0 to 7)) XOR unsigned(expansionMatrix(0 to 7)));
							tempWord(8 to 15) := std_logic_vector(unsigned(tempWord(8 to 15)) XOR unsigned(expansionMatrix(8 to 15)));
							tempWord(16 to 23) := std_logic_vector(unsigned(tempWord(16 to 23)) XOR unsigned(expansionMatrix(16 to 23)));
							tempWord(24 to 31) := std_logic_vector(unsigned(tempWord(24 to 31)) XOR unsigned(expansionMatrix(24 to 31)));	
							
							expansionMatrix(0 to 7) := tempWord(0 to 7);
							expansionMatrix(8 to 15) := tempWord(8 to 15);
							expansionMatrix(16 to 23) := tempWord(16 to 23);
							expansionMatrix(24 to 31) := tempWord(24 to 31);  
							report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
							
							--Step 5: add second column with new key	 
							tempWord(0 to 7) := std_logic_vector(unsigned(tempWord(0 to 7))XOR unsigned(expansionMatrix(32 to 39)));
							tempWord(8 to 15) := std_logic_vector(unsigned(tempWord(8 to 15)) XOR unsigned(expansionMatrix(40 to 47)));
							tempWord(16 to 23) := std_logic_vector(unsigned(tempWord(16 to 23)) XOR unsigned(expansionMatrix(48 to 55)));
							tempWord(24 to 31) := std_logic_vector(unsigned(tempWord(24 to 31)) XOR unsigned(expansionMatrix(56 to 63)));
							
							expansionMatrix(32 to 39) := tempWord(0 to 7);
							expansionMatrix(40 to 47) := tempWord(8 to 15);
							expansionMatrix(48 to 55) := tempWord(16 to 23);
							expansionMatrix(56 to 63) := tempWord(24 to 31);   
							report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
							
							--Step 6: add third column with new key
							tempWord(0 to 7) := std_logic_vector(unsigned(tempWord(0 to 7)) XOR unsigned(expansionMatrix(64 to 71)));
							tempWord(8 to 15) := std_logic_vector(unsigned(tempWord(8 to 15)) XOR unsigned(expansionMatrix(72 to 79)));
							tempWord(16 to 23) := std_logic_vector(unsigned(tempWord(16 to 23)) XOR unsigned(expansionMatrix(80 to 87)));
							tempWord(24 to 31) := std_logic_vector(unsigned(tempWord(24 to 31)) XOR unsigned(expansionMatrix(88 to 95)));
							
							expansionMatrix(64 to 71) := tempWord(0 to 7);
							expansionMatrix(72 to 79) := tempWord(8 to 15);
							expansionMatrix(80 to 87) := tempWord(16 to 23);
							expansionMatrix(88 to 95) := tempWord(24 to 31); 
							report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
							
							--Step 7: add last column with new key
							tempWord(0 to 7) := std_logic_vector(unsigned(tempWord(0 to 7)) XOR unsigned(expansionMatrix(96 to 103)));
							tempWord(8 to 15) := std_logic_vector(unsigned(tempWord(8 to 15)) XOR unsigned(expansionMatrix(104 to 111)));
							tempWord(16 to 23) := std_logic_vector(unsigned(tempWord(16 to 23)) XOR unsigned(expansionMatrix(112 to 119)));
							tempWord(24 to 31) := std_logic_vector(unsigned(tempWord(24 to 31)) XOR unsigned(expansionMatrix(120 to 127)));
							
							expansionMatrix(96 to 103) := tempWord(0 to 7);
							expansionMatrix(104 to 111) := tempWord(8 to 15);
							expansionMatrix(112 to 119) := tempWord(16 to 23);
							expansionMatrix(120 to 127) := tempWord(24 to 31); 	
							report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
							roundKeys(i) := expansionMatrix;
						   rc_count := rc_count + 1;
							end loop;
							key_expansion_complete := true;
							report "round key 1: " & to_hstring(roundKeys(1));
							--key Expansion done.		
						
							--encryption loop---------------------------------------------------------------------------------------------
						if(key_expansion_complete = true and done_enc = false) then	
							--first round, key is added first
							result_matrix := addRoundkey(fullData, fullkey);
							for i in 0 to 9 loop	
								--substitute in sbox 
								result_matrix := sbox(result_matrix, invert);
								
								report "round " & to_string(i) & " after sbox key : " & to_hstring(result_matrix);
								--shift rows 
								result_matrix := shiftRows(result_matrix, invert);
								
								report "round " & to_string(i) & " after shift key : " & to_hstring(result_matrix);
								--mix columns
								if(i  /=  9) then
									result_matrix := mixColumns(result_matrix, invert);
								end if;
								report "round " & to_string(i) & " before key : " & to_hstring(result_matrix);
								--add round key	except last round
								
									result_matrix := addRoundKey(result_matrix, roundKeys(i)); 
									
								report "round " & to_string(i) & " end value: " & to_hstring(result_matrix);
							end loop;
							done_enc := true;
						end if;
						--encryption done-------------------------------------------------------------------------------------
			else
				--start decryption
			end if;
			nextstate <= 6;
		when 6 => --output
			done <= '1';
			for i in 0 to 3 loop
				dataout <= result_matrix(i*32 to i*32+31);
			end loop;
			report "output: " & to_hstring(result_matrix);
			if stream = '1' then
				if CBC_Mode = '1' then
					IV := result_matrix;
				end if;
				nextstate <= 3;
			else nextstate <= 0;
			end if;
	end case;		
elsif(reset ='0') then		
fullKey := std_logic_vector(to_unsigned (0, 128));
fullData  := std_logic_vector(to_unsigned (0, 128));	
temp := std_logic_vector(to_unsigned (0, 128));
tempWord := std_logic_vector(to_unsigned (0, 32));	

tt  := 0;	  
key_expansion_complete:= false;
encryption_count  := 0; 
sub_counter  := 0;
temp_row := std_logic_vector(to_unsigned (0, 32));
result_matrix:= std_logic_vector(to_unsigned (0, 128));
col_count:= 0;  
--roundKeys: key_store (0 to 9)(0 to 127);
rotate_matrix:= std_logic_vector(to_unsigned (0, 128));
done_enc := false;
data_out_complete := false;
IV  := std_logic_vector(to_unsigned (0, 128));	
IV_load_count := 0;
IV_load_complete := false;
invert  := '0';
rc_return:= std_logic_vector(to_unsigned (0, 8));
end if;		

end process;

CLK_process: process(CLK)
begin
	if CLK'event and CLK = '1' then
		state <= nextstate;
	end if;
end process CLK_process; 


end architecture;
-- Advanced challenge 2: use a single entity for both encryption and decryption.
--      You are permitted to add additional control signals.
