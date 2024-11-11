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
    ECB_mode   : in    std_logic;
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
type ROM is array (0 to 15, 0 to 15) of integer;
	signal Sbox : ROM := (
    (16#63#, 16#7c#, 16#77#, 16#7b#, 16#f2#, 16#6b#, 16#6f#, 16#c5#, 16#30#, 16#01#, 16#67#, 16#2b#, 16#fe#, 16#d7#, 16#ab#, 16#76#),
    (16#ca#, 16#82#, 16#c9#, 16#7d#, 16#fa#, 16#59#, 16#47#, 16#f0#, 16#ad#, 16#d4#, 16#a2#, 16#af#, 16#9c#, 16#a4#, 16#72#, 16#c0#),
    (16#b7#, 16#fd#, 16#93#, 16#26#, 16#36#, 16#3f#, 16#f7#, 16#cc#, 16#34#, 16#a5#, 16#e5#, 16#f1#, 16#71#, 16#d8#, 16#31#, 16#15#),
    (16#04#, 16#c7#, 16#23#, 16#c3#, 16#18#, 16#96#, 16#05#, 16#9a#, 16#07#, 16#12#, 16#80#, 16#e2#, 16#eb#, 16#27#, 16#b2#, 16#75#),
    (16#09#, 16#83#, 16#2c#, 16#1a#, 16#1b#, 16#6e#, 16#5a#, 16#a0#, 16#52#, 16#3b#, 16#d6#, 16#b3#, 16#29#, 16#e3#, 16#2f#, 16#84#),
    (16#53#, 16#d1#, 16#00#, 16#ed#, 16#20#, 16#fc#, 16#b1#, 16#5b#, 16#6a#, 16#cb#, 16#be#, 16#39#, 16#4a#, 16#4c#, 16#58#, 16#cf#),
    (16#d0#, 16#ef#, 16#aa#, 16#fb#, 16#43#, 16#4d#, 16#33#, 16#85#, 16#45#, 16#f9#, 16#02#, 16#7f#, 16#50#, 16#3c#, 16#9f#, 16#a8#),
    (16#51#, 16#a3#, 16#40#, 16#8f#, 16#92#, 16#9d#, 16#38#, 16#f5#, 16#bc#, 16#b6#, 16#da#, 16#21#, 16#10#, 16#ff#, 16#f3#, 16#d2#),
    (16#cd#, 16#0c#, 16#13#, 16#ec#, 16#5f#, 16#97#, 16#44#, 16#17#, 16#c4#, 16#a7#, 16#7e#, 16#3d#, 16#64#, 16#5d#, 16#19#, 16#73#),
    (16#60#, 16#81#, 16#4f#, 16#dc#, 16#22#, 16#2a#, 16#90#, 16#88#, 16#46#, 16#ee#, 16#b8#, 16#14#, 16#de#, 16#5e#, 16#0b#, 16#db#),
    (16#e0#, 16#32#, 16#3a#, 16#0a#, 16#49#, 16#06#, 16#24#, 16#5c#, 16#c2#, 16#d3#, 16#ac#, 16#62#, 16#91#, 16#95#, 16#e4#, 16#79#),
    (16#e7#, 16#c8#, 16#37#, 16#6d#, 16#8d#, 16#d5#, 16#4e#, 16#a9#, 16#6c#, 16#56#, 16#f4#, 16#ea#, 16#65#, 16#7a#, 16#ae#, 16#08#),
    (16#ba#, 16#78#, 16#25#, 16#2e#, 16#1c#, 16#a6#, 16#b4#, 16#c6#, 16#e8#, 16#dd#, 16#74#, 16#1f#, 16#4b#, 16#bd#, 16#8b#, 16#8a#),
    (16#70#, 16#3e#, 16#b5#, 16#66#, 16#48#, 16#03#, 16#f6#, 16#0e#, 16#61#, 16#35#, 16#57#, 16#b9#, 16#86#, 16#c1#, 16#1d#, 16#9e#),
    (16#e1#, 16#f8#, 16#98#, 16#11#, 16#69#, 16#d9#, 16#8e#, 16#94#, 16#9b#, 16#1e#, 16#87#, 16#e9#, 16#ce#, 16#55#, 16#28#, 16#df#),
    (16#8c#, 16#a1#, 16#89#, 16#0d#, 16#bf#, 16#e6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2d#, 16#0f#, 16#b0#, 16#54#, 16#bb#, 16#16#)
);	
type roundConstants is array (0 to 11) of integer;
	signal rc : roundConstants := (
    (1, 0, 0, 0,2,0,0,0,4,0,0,0)
);

type mult_matrix is array (0 to 3, 0 to 3) of integer;
	signal mul : mult_matrix := (
    (2,3,1,1),
	(1,2,3,1),
	(1,1,2,3),
	(3,1,1,2)
);

	impure function sbox_LUT ( byte : in std_logic_vector(0 to 7))
    return std_logic_vector is	
	variable count : integer := 0;
	variable newVector : std_logic_vector(0 to 7);	
	variable test : integer := 0;
	begin 
		--debug	
		report "test";
		test :=  Sbox(to_integer(unsigned(byte(0 to 3))), to_integer(unsigned(byte(4 to 7))) );
		report "test" & to_string(test);
		newVector := std_logic_vector(to_unsigned(test, newVector'length));
		report to_string(newVector);
    return std_logic_vector(newVector);	   
  end function; 
  
  
  	impure function rc_LUT ( byte : in std_logic_vector(0 to 7))
    return std_logic_vector is	
	variable count : integer := 0;
	variable newVector : std_logic_vector(0 to 7);	
	variable test : integer := 0;
	begin 
		--debug	
		report "test";
		test :=  rc(to_integer(unsigned(byte(0 to 7))) );
		report "test" & to_string(test);
		newVector := std_logic_vector(to_unsigned(test, newVector'length));
		report to_string(newVector);
    return std_logic_vector(newVector);
  end function; 
  
  
  begin
	
p1 : process(clk) is  
type key_store is array (natural range <>) of std_logic_vector;
variable fullKey : std_logic_vector(0 to 127);
variable key_load_complete : boolean := false;
variable data_load_complete : boolean := false;
variable key_loading : boolean := false;  
variable keyLoadCount : integer := 0;
variable fullData : std_logic_vector(0 to 127);	
variable dataLoadCount : integer := 0;
variable dataOutCount: integer:= 0;
variable temp : std_logic_vector(0 to 127);
variable tempWord : std_logic_vector(0 to 31);	
variable tt : integer := 0;	  
variable expansionMatrix : std_logic_vector(0 to 127);	
variable rc_count : integer := 0;
variable key_expansion_complete:  boolean:= false;
variable encryption_count : integer := 0; 
variable sub_counter : integer := 0;
variable temp_row : std_logic_vector(0 to 31); 
variable result_matrix: std_logic_vector(0 to 127);	 
variable mix_Matrix: std_logic_vector(0 to 31);
variable col_count: integer:= 0;  
variable roundKeys: key_store (0 to 9)(0 to 127);
variable rotate_matrix: std_logic_vector(0 to 127);
variable done_enc: boolean := false;
variable data_out_complete: boolean := false;
begin	
	--report "start";
	--	 tt := sbox_LUT("00000000");
	if (clk'event and clk = '1' and reset = '0')then 
		
		if(start = '1') then
			
			key_loading := true;	
			keyLoadCount := 0;
		end if;
		if(key_load = '1') then	
			if(keyLoadCount = 0) then
				fullKey(0 to 31) := dataIn;	
				report "key_chunk_1: " & to_string(fullKey(0 to 31));
			elsif(keyLoadCount = 1) then
				fullKey(32 to 63) := dataIn;
			elsif(keyLoadCount = 2) then
				fullKey(64 to 95) := dataIn;
			else if(keyLoadCount = 3) then
				fullKey(96 to 127) := dataIn;
			else
				key_loading := false;  
				key_load_complete :=true;  
				--debug
				report to_string(fullKey);
				end if;
			end if;
			keyLoadCount := keyLoadCount + 1;
		end if;
		if(key_load_complete = true and done_enc = false) then
			--unsure what IV does. leaving it out for now and loading db. will come back to it later.
		
			if(dataLoadCount = 0) then
				fullData(0 to 31) := dataIn;
			elsif(dataLoadCount = 1) then
				fullData(32 to 63) := dataIn;
			elsif(dataLoadCount = 2) then
				fullData(64 to 95) := dataIn;
			else if(dataLoadCount = 3) then
				fullData(96 to 127) := dataIn;
			else
				data_load_complete :=true;  
				--debug
				report to_string(fullData);
				end if;
			end if;
			dataLoadCount := dataLoadCount + 1;
			end if;	  
			
			--at this point, assume that the data is fully loaded.
			
			--expand key
		if(key_load_complete and data_load_complete and done_enc = false) then  
			
			-- I will rework this to use loops and variables to simplify this. Initial run through was just to make sure the operational logic works.
			
			--Step 1: shift left 
			tempWord := fullKey(96 to 127);
			expansionMatrix := fullKey;
			tempWord(0 to 31) := tempWord sll 8;
			
			for i in 0 to 9 loop
			--Step 2: Sub bytes for those in sBox
			tempWord(0 to 7) := sbox_LUT(tempWord(0 to 7));	
			tempWord(8 to 15) := sbox_LUT(tempWord(8 to 15));	
			tempWord(16 to 23) := sbox_LUT(tempWord(16 to 23));	
			tempWord(24 to 31) := sbox_LUT(tempWord(24 to 31));	
			--Step 3: add round constant 						  
			tempWord(0 to 7) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(0 to 7))) + to_integer(unsigned(rc_LUT(std_logic_vector(to_unsigned((rc_count*4),8))))), tempWord(0 to 7)'length));
			tempWord(8 to 15) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(8 to 15))) + to_integer(unsigned(rc_LUT(std_logic_vector(to_unsigned((rc_count*4)+1,8))))), tempWord(8 to 15)'length));
			tempWord(16 to 23) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(16 to 23))) + to_integer(unsigned(rc_LUT(std_logic_vector(to_unsigned((rc_count*4)+2,8))))), tempWord(16 to 23)'length));
			tempWord(24 to 31) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(24 to 31))) + to_integer(unsigned(rc_LUT(std_logic_vector(to_unsigned((rc_count*4)+3,8))))), tempWord(24 to 31)'length));
			--Step 4: add first column with new key
			tempWord(0 to 7) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(0 to 7))) + to_integer(unsigned(expansionMatrix(0 to 7))), tempWord(0 to 7)'length));
			tempWord(8 to 15) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(8 to 15))) + to_integer(unsigned(expansionMatrix(8 to 15))), tempWord(8 to 15)'length));
			tempWord(16 to 23) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(16 to 23))) + to_integer(unsigned(expansionMatrix(16 to 23))), tempWord(16 to 23)'length));
			tempWord(24 to 31) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(24 to 31))) + to_integer(unsigned(expansionMatrix(24 to 31))), tempWord(24 to 31)'length));	
			
			expansionMatrix(0 to 7) := tempWord(0 to 7);
			expansionMatrix(8 to 15) := tempWord(8 to 15);
			expansionMatrix(16 to 23) := tempWord(16 to 23);
			expansionMatrix(24 to 31) := tempWord(24 to 31);
			
			--Step 5: add second column with new key	 
			tempWord(0 to 7) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(0 to 7))) + to_integer(unsigned(expansionMatrix(32 to 39))), tempWord(0 to 7)'length));
			tempWord(8 to 15) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(8 to 15))) + to_integer(unsigned(expansionMatrix(40 to 47))), tempWord(8 to 15)'length));
			tempWord(16 to 23) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(16 to 23))) + to_integer(unsigned(expansionMatrix(48 to 55))), tempWord(16 to 23)'length));
			tempWord(24 to 31) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(24 to 31))) + to_integer(unsigned(expansionMatrix(56 to 63))), tempWord(24 to 31)'length));
			
			expansionMatrix(32 to 39) := tempWord(0 to 7);
			expansionMatrix(40 to 47) := tempWord(8 to 15);
			expansionMatrix(48 to 55) := tempWord(16 to 23);
			expansionMatrix(56 to 63) := tempWord(24 to 31);
			
			--Step 6: add third column with new key
			tempWord(0 to 7) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(0 to 7))) + to_integer(unsigned(expansionMatrix(64 to 71))), tempWord(0 to 7)'length));
			tempWord(8 to 15) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(8 to 15))) + to_integer(unsigned(expansionMatrix(72 to 79))), tempWord(8 to 15)'length));
			tempWord(16 to 23) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(16 to 23))) + to_integer(unsigned(expansionMatrix(80 to 87))), tempWord(16 to 23)'length));
			tempWord(24 to 31) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(24 to 31))) + to_integer(unsigned(expansionMatrix(88 to 95))), tempWord(24 to 31)'length));
			
			expansionMatrix(64 to 71) := tempWord(0 to 7);
			expansionMatrix(72 to 79) := tempWord(8 to 15);
			expansionMatrix(80 to 87) := tempWord(16 to 23);
			expansionMatrix(88 to 95) := tempWord(24 to 31); 
			
			--Step 7: add last column with new key
			tempWord(0 to 7) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(0 to 7))) + to_integer(unsigned(expansionMatrix(96 to 103))), tempWord(0 to 7)'length));
			tempWord(8 to 15) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(8 to 15))) + to_integer(unsigned(expansionMatrix(104 to 111))), tempWord(8 to 15)'length));
			tempWord(16 to 23) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(16 to 23))) + to_integer(unsigned(expansionMatrix(112 to 119))), tempWord(16 to 23)'length));
			tempWord(24 to 31) := std_logic_vector(to_unsigned(to_integer(unsigned(tempWord(24 to 31))) + to_integer(unsigned(expansionMatrix(120 to 127))), tempWord(24 to 31)'length));
			
			expansionMatrix(96 to 103) := tempWord(0 to 7);
			expansionMatrix(104 to 111) := tempWord(8 to 15);
			expansionMatrix(112 to 119) := tempWord(16 to 23);
			expansionMatrix(120 to 127) := tempWord(24 to 31); 	
			roundKeys(i) := expansionMatrix;
		   rc_count := rc_count + 1;
			end loop;
			key_expansion_complete := true;
			--key Expansion done.
				
		end if;
		--begin encryption loop
		if(key_expansion_complete = true and done_enc = false) then
		
			--if first round xor with key
			--if(encryption_count = 0) then
				--initial round
		result_matrix := fullData XOR fullKey;
			--end if;
		for i in 0 to 9 loop
			
				
		--substitute in sbox
		for i in 0 to 15 loop
			result_matrix((sub_counter*4) to (sub_counter*4)+7) := sbox_LUT(result_matrix((sub_counter*4) to (sub_counter*4)+7));	
			sub_counter := sub_counter + 1;
		end loop;
		
		--shift rows 
		
		----second row
		temp_row := result_matrix(8 to 15) & result_matrix(40 to 47) & result_matrix(72 to 79) & result_matrix(104 to 111);
		temp_row := temp_row sll 8;	
		
		--replace second row
		result_matrix(8 to 15) := temp_row(0 to 7);
		result_matrix(40 to 47) := temp_row(8 to 15);
		result_matrix(72 to 79) := temp_row(16 to 23);
		result_matrix(104 to 111) := temp_row(24 to 31);
		
		----third row
		temp_row := result_matrix(16 to 23) & result_matrix(48 to 55) & result_matrix(80 to 87) & result_matrix(112 to 119);
		temp_row := temp_row sll 16;	
		
		--replace third row
		result_matrix(16 to 23) := temp_row(0 to 7);
		result_matrix(48 to 55) := temp_row(8 to 15);
		result_matrix(80 to 87) := temp_row(16 to 23);
		result_matrix(112 to 119) := temp_row(24 to 31);
		
		----last row
		temp_row := result_matrix(24 to 31) & result_matrix(56 to 63) & result_matrix(88 to 95) & result_matrix(120 to 127);
		temp_row := temp_row sll 24;	
		
		--replace last row
		result_matrix(24 to 31) := temp_row(0 to 7);
		result_matrix(56 to 63) := temp_row(8 to 15);
		result_matrix(88 to 95) := temp_row(16 to 23);
		result_matrix(120 to 127) := temp_row(24 to 31);		   
		
		
		--mix columns	 
		for i in 0 to 15 loop
		mix_matrix((i*8*0)+0 to (i*8*0)+7):= std_logic_vector(mul(i+0,i) * to_unsigned(to_integer(unsigned(result_matrix((0*8*col_count) + 0 to (0*8*col_count) + 7)))  ,result_matrix(0 to 3)'length)); 
		mix_matrix((i*8*1)+0 to (i*8*1)+7):= std_logic_vector(mul(i+1,i) * to_unsigned(to_integer(unsigned(result_matrix((1*8*col_count) + 0 to (1*8*col_count) + 7)))  ,result_matrix(0 to 3)'length)); 
		mix_matrix((i*8*2)+0 to (i*8*2)+7):= std_logic_vector(mul(i+2,i) * to_unsigned(to_integer(unsigned(result_matrix((2*8*col_count) to (2*8*col_count) + 7)))  ,result_matrix(0 to 3)'length)); 
		mix_matrix((i*8*3)+0 to (i*8*3)+7):= std_logic_vector(mul(i+3,i) * to_unsigned(to_integer(unsigned(result_matrix((3*8*col_count) to (3*8*col_count) + 7)))  ,result_matrix(0 to 3)'length));
		
		
		result_matrix((i*8)+0 to (i*8)+7):= std_logic_vector(
			to_unsigned(to_integer(unsigned(mix_matrix(0 to 7))) ,result_matrix(0 to 7)'length)	+
			to_unsigned(to_integer(unsigned(mix_matrix(8 to 15))) ,result_matrix(8 to 15)'length) + 
			to_unsigned(to_integer(unsigned(mix_matrix(16 to 23))) ,result_matrix(16 to 23)'length) +
			to_unsigned(to_integer(unsigned(mix_matrix(24 to 31))) ,result_matrix(24 to 31)'length) 
		);
		
		--move to next column
		if(col_count mod 4 = 0 ) then
			col_count := col_count + 1;	
			end if;		  
		end loop;
		
		
		--rotate
		rotate_matrix(0 to 31) := result_matrix(0 to 7) & result_matrix(32 to 39) & result_matrix(64 to 71) & result_matrix(96 to 103);
		rotate_matrix(32 to 63) := result_matrix(8 to 15) & result_matrix(40 to 47) & result_matrix(72 to 79) & result_matrix(104 to 111);
		rotate_matrix(64 to 95) := result_matrix(16 to 23) & result_matrix(48 to 55) & result_matrix(80 to 87) & result_matrix(112 to 119);
		rotate_matrix(96 to 127) := result_matrix(24 to 31) & result_matrix(56 to 63) & result_matrix(88 to 95) & result_matrix(120 to 127);	 
		
		report "matrix after rotate: " & to_hstring(rotate_matrix);
		result_matrix:= rotate_matrix; 
		
		
		--add round key	except last round
			if(i  /=  9) then
				result_matrix:= result_matrix XOR roundKeys(i);
			end if;
		end loop;
		
		done_enc := true;
		end if;
		
		--output ciphertext
		if(done_enc = true) then
			report to_hstring(result_matrix);
			Done <= '1';  
			if(dataOutCount = 0) then
				dataOut(0 to 31) <= result_matrix(0 to 31);
			elsif(dataOutCount = 1) then
				dataOut(0 to 31) <= result_matrix(32 to 63);
			elsif(dataOutCount = 2) then
				dataOut(0 to 31) <= result_matrix(64 to 95);
			else if(dataOutCount = 3) then
				dataOut(0 to 31) <= result_matrix(96 to 127);
			else
				data_out_complete := true;
				end if;
			end if;
			dataOutCount := dataOutCount + 1;
			
		end if;
		
		--reset all variables after done.
		
	end if;	 
end process;


end architecture;
-- Advanced challenge 2: use a single entity for both encryption and decryption.
--      You are permitted to add additional control signals.
