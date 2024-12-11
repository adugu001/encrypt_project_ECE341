library work;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use work.function_package.all;
use work.aesTest.all;

entity structural_tb is
end structural_tb;

architecture TB_ARCHITECTURE of structural_tb is
	-- Component declaration of the tested unit
	component aes_128_encrypt_f24
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		start : in STD_LOGIC;
		key_load : in STD_LOGIC;
		IV_load : in STD_LOGIC;
		db_load : in STD_LOGIC;
		stream : in STD_LOGIC;
		Encrypt : in STD_LOGIC;
		CBC_mode : in STD_LOGIC;
		dataIn : in STD_LOGIC_VECTOR(0 to 31);
		dataOut : out STD_LOGIC_VECTOR(0 to 31);
		Done : out STD_LOGIC );
	end component;

	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC := '0';
	signal start : STD_LOGIC;
	signal key_load : STD_LOGIC;
	signal IV_load : STD_LOGIC;
	signal db_load : STD_LOGIC;
	signal stream : STD_LOGIC;
	signal encrypt : STD_LOGIC := '0';
	signal CBC_mode : STD_LOGIC := '0';
	signal dataIn : STD_LOGIC_VECTOR(0 to 31);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal dataOut : STD_LOGIC_VECTOR(0 to 31);
	signal Done : STD_LOGIC;
   	signal SIMULATIONACTIVE:BOOLEAN:=TRUE;										

begin
	UUT_dat : aes_128_encrypt_f24
		port map (
			clk => clk,
			reset => reset,
			start => start,
			key_load => key_load,
			IV_load => IV_load,
			db_load => db_load,
			stream => stream,
			encrypt => encrypt,
			CBC_mode => CBC_mode,
			dataIn => dataIn,
			dataOut => dataOut,
			Done => Done
		);
	
process
	begin
		while simulationActive loop
			clk <='0'; wait for 50ns;
			clk <='1'; wait for 50ns;
		end loop;
		wait;	
end process;

COMPREHENSIVE_TEST:process  
variable temp_data, temp_key, cipher, expected : std_logic_vector(0 to 127);
type stream_store is array (1 to 3) of std_logic_vector(0 to 127);
variable CBC_file, ECB_file, DECRYPT_file: stream_store;
begin
		wait until clk'event AND clk = '1';
		encrypt <= '0'; iv_load <= '0'; 
		
		wait until clk'event AND clk = '1';	
	--ENCRYPTION ON INDIVIDUAL BLOCKS------------------------------------------------------------
	STRAIGHT_ENCRYPTION: for k in 0 to 4 loop			  
			temp_key := tests_128(k).key; temp_data := tests_128(k).plain; expected := tests_128(k).expected;
			
			
			stream <= '0'; start <= '1'; 
			wait until start <= '1';
			wait until clk'event AND clk = '1';
			key_load <= '1';
			wait until clk'event AND clk = '1'; 
			
			load_key: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';					
			end loop load_key;
			--wait until clk'event AND clk = '1';
			db_load <= '1'; wait for 0ns;
			wait until clk'event AND clk = '1';
			load_data: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';
			end loop load_data;
			
			stream <= '0'; start <= '0';  
			for i in 0 to 26 loop
				wait until clk'event AND clk = '1';
			end loop;

			OUTPUT_CIPHER: for i in 0 to 3 loop				
				cipher(i*32 to i*32 + 31) := dataOut; 
				wait until clk'event AND clk = '1';
			end loop OUTPUT_CIPHER;
			assert cipher = expected report 	"Indiv enc: " & to_hstring(cipher) & character'val(10) & 	"Expected: " & to_hstring(expected);	 
			
	END LOOP STRAIGHT_ENCRYPTION;	   
	
	
	--DECRYPTION ON INDIVIDUAL BLOCKS----------------------------------------------------------------------
	encrypt <= '1';
	STRAIGHT_DECRYPTION: for k in 0 to 4 loop
			temp_key := tests_128(k).key; temp_data := tests_128(k).expected; expected := tests_128(k).plain;
			
			stream <= '0'; start <= '1'; 
			wait until start <= '1';
			wait until clk'event AND clk = '1';			
			key_load <= '1';
			wait until clk'event AND clk = '1';
			
			LOAD_KEY: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';					
			END LOOP LOAD_KEY;	
			

			db_load <= '1'; wait until clk'event AND clk = '1';
			load_data: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';
			end loop load_data;
			
			stream <= '0'; start <= '0';  
			for i in 0 to 26 loop
				wait until clk'event AND clk = '1';
			end loop;
		
			OUTPUT_CIPHER: for i in 0 to 3 loop				
				cipher(i*32 to i*32 + 31) := dataOut; 
				wait until clk'event AND clk = '1';
			end loop OUTPUT_CIPHER;
			assert cipher = expected report 	"Indiv dec: " & to_hstring(cipher) & character'val(10) & 	"Expected: " & to_hstring(expected);	 
	 END LOOP STRAIGHT_DECRYPTION;
	 
	 
	 
--DECRYPTION ON CHAINED BLOCKS------------------------------------------------------------
		stream <= '1'; start <= '1'; key_load <= '1';
		temp_key := tests_128(0).key; 
		wait until start <= '1';		   -----
		wait until clk'event AND clk = '1';			
		wait until clk'event AND clk = '1';
		
		LOAD_KEY: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';					
		END LOOP LOAD_KEY;
		
		for j in 1 to 3 loop
				temp_key := tests_128(j).key; temp_data := tests_128(j).expected; expected := tests_128(j).plain;
				db_load <= '1'; wait for 0ns;
				wait until clk'event AND clk = '1';
			LOAD_DATA: for i in 0 to 3 loop
					dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
					wait until clk'event AND clk = '1';
			END LOOP LOAD_DATA;
			db_load <= '0';  
			
			start <= '0';
			for i in 0 to 26 loop
					wait until clk'event AND clk = '1';
			end loop;
			
			if j = 3 then stream <= '0'; end if;
			OUTPUT_CIPHER: for i in 0 to 3 loop
					cipher(i*32 to i*32 + 31) := dataOut;
					wait until clk'event AND clk = '1';
			END LOOP OUTPUT_CIPHER;
			assert cipher = expected report "chained dec";
		END LOOP;
		
		
		
	--CBC Test------------------------------------------------------------
	temp_key := tests_128(7).key; temp_data := tests_128(7).plain; expected := tests_128(7).expected;
	encrypt <= '0';
		
	CBC_TEST: for k in 0 to 1 loop
			if k = 0 then CBC_mode <= '0';
			else CBC_mode <= '1'; end if;
			stream <= '1'; start <= '1'; key_load <= '1';
			wait until start <= '1';		   -----
			wait until clk'event AND clk = '1';			
			wait until clk'event AND clk = '1';
			
			LOAD_KEY: for i in 0 to 3 loop
					dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
					wait until clk'event AND clk = '1';					
			END LOOP LOAD_KEY;
			
			for j in 1 to 3 loop									
					db_load <= '1'; wait for 0ns;
					wait until clk'event AND clk = '1';
				LOAD_DATA: for i in 0 to 3 loop
						dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
						wait until clk'event AND clk = '1';
				END LOOP LOAD_DATA;
				db_load <= '0';  
				
				start <= '0';
				for i in 0 to 26 loop
						wait until clk'event AND clk = '1';
				end loop;
					
					
					if j = 3 then stream <= '0'; end if;
				OUTPUT_CIPHER: for i in 0 to 3 loop
						if k = 0 then 
							ECB_file(j)(i*32 to i*32 + 31) := dataOut;
						else 	
							CBC_file(j)(i*32 to i*32 + 31) := dataOut;
						end if;
						wait until clk'event AND clk = '1';
				END LOOP OUTPUT_CIPHER;
			END LOOP;				
	END LOOP CBC_TEST;
	assert (ECB_file(1) = ECB_file(2) AND ECB_file(1) = ECB_file(3)) report "ecb output not repeated"; 
	assert CBC_file(1) /= CBC_file(2) AND CBC_file(1) /= CBC_file(3) AND CBC_file(2) /= CBC_file(3) report "CBC has repeated outputs";
	assert CBC_file(1) = ECB_file(1) report "ECB and CBC initial encryption differ";

	RESET_TEST: for k in 0 to 4 loop
			temp_key := tests_128(k).key; temp_data := tests_128(k).expected; expected := tests_128(k).plain;
			
			stream <= '0'; start <= '1'; 
			wait until start <= '1';
			wait until clk'event AND clk = '1';			
			key_load <= '1';
			wait until clk'event AND clk = '1';
			start <= '0';
			
			LOAD_KEY: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';
				if k = 0 and i = 3 then
					reset <= '1'; 
					wait until reset = '1';
					wait for 0ns; --VERIFY UUT_DAT.STATE AND NEXTSTATE = 0
					reset <= '0';
					wait for 0ns;
				end if;
			END LOOP LOAD_KEY;	
			

			db_load <= '1'; wait until clk'event AND clk = '1';
			load_data: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';
				if k = 1 and i = 3 then
					reset <= '1'; 
					wait until reset = '1';
					wait for 0ns; --VERIFY UUT_DAT.STATE AND NEXTSTATE = 0
					reset <= '0';
					wait for 0ns;
				end if;
			end loop load_data;
			
			stream <= '0'; start <= '0';  
			for i in 0 to 24 loop
				if k = 2 and i = 3 then
					reset <= '1'; 
					wait until reset = '1';
					wait for 0ns; --VERIFY UUT_DAT.STATE AND NEXTSTATE = 0
					reset <= '0';
					wait for 0ns;
				end if;
				wait until clk'event AND clk = '1';
			end loop;
		
			OUTPUT_CIPHER: for i in 0 to 3 loop
				if k = 3 and i = 3 then
					reset <= '1'; 
					wait until reset = '1';
					wait for 0ns; --VERIFY UUT_DAT.STATE AND NEXTSTATE = 0
					reset <= '0';
					wait for 0ns;
				end if;
				cipher(i*32 to i*32 + 31) := dataOut; 
				wait until clk'event AND clk = '1';
			end loop OUTPUT_CIPHER;	 
	 END LOOP RESET_TEST;	

		simulationactive<= false;
		wait;
end process;
end architecture;

configuration TESTBENCH_FOR_aes_128_encrypt_f24_structural of structural_tb is
	for TB_ARCHITECTURE
		for UUT_dat : aes_128_encrypt_f24
			use entity work.aes_128_encrypt_f24(structural);
		end for;
	end for;
end TESTBENCH_FOR_aes_128_encrypt_f24_structural;




