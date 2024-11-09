library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		   		  
    return std_logic_vector(newVector);
  end function; 
  
  
  
  begin
	
p1 : process(clk) is   
variable fullKey : std_logic_vector(0 to 127);
variable key_load_complete : boolean := false;
variable data_load_complete : boolean := false;
variable key_loading : boolean := false;  
variable keyLoadCount : integer := 0;
variable fullData : std_logic_vector(0 to 127);	
variable dataLoadCount : integer := 0;		 
variable temp : std_logic_vector(0 to 127);
variable tempWord : std_logic_vector(0 to 31);	
variable tt : std_logic_vector(0 to 7);
begin	
	report "start";
		 tt := sbox_LUT("00000000");
	if (clk'event and clk = '1' and reset = '0')then 
		
		if(start = '1') then
			
			key_loading := true;	
			keyLoadCount := 0;
		end if;
		if(key_load = '1') then	
			if(keyLoadCount = 0) then
				fullKey(0 to 31) := dataIn;
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
		if(key_load_complete = true) then
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
		if(key_load_complete and data_load_complete) then
			--Step 1: shift left 
			tempWord := fullData(96 to 127); 
			tempWord(0 to 31) := tempWord sll 8;
		end if;	
		
	end if;	 
end process;


end architecture;
-- Advanced challenge 2: use a single entity for both encryption and decryption.
--      You are permitted to add additional control signals.
