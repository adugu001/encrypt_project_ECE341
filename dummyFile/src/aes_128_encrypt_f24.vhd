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
	
begin	
	
p1 : process(clk) is   
variable fullKey : std_logic_vector(0 to 127);
variable key_load_complete : boolean := false;
variable key_loading : boolean := false;  
variable keyLoadCount : integer := 0;
begin	
	
	if (clk'event and clk = '1' and reset = '0')then  
		if(start = '1') then
			key_loading := true;	
			keyLoadCount := 0;
		end if;
		if(key_load = '1') then	
			start := '0';
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
			if(
			end if;
	end if;
end process;


end architecture;
-- Advanced challenge 2: use a single entity for both encryption and decryption.
--      You are permitted to add additional control signals.
