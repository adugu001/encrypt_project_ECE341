library work;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use work.function_package.all;
use work.aesTest.all;

	-- Add your library and packages declaration here ...

entity aes_128_encrypt_f24_tb is
end aes_128_encrypt_f24_tb;

architecture TB_ARCHITECTURE of aes_128_encrypt_f24_tb is
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
		encrypt : in STD_LOGIC;
		CBC_mode : in STD_LOGIC;
		dataIn : in STD_LOGIC_VECTOR(0 to 31);
		dataOut : out STD_LOGIC_VECTOR(0 to 31);
		Done : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
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

	-- Add your code here ...

begin

	-- Unit Under Test port map




	UUT : aes_128_encrypt_f24
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
		
	-- Add your stimulus here ...
clockProcess:process  
variable data : std_logic_vector(0 to 127);	
variable key : std_logic_vector(0 to 127); 
variable data1 : std_logic_vector(0 to 127);	
variable key1 : std_logic_vector(0 to 127);    
variable data2 : std_logic_vector(0 to 127);	
variable key2 : std_logic_vector(0 to 127); 
variable cipher : std_logic_vector(0 to 127);
begin
	
	data:= "00110010010000111111011010101000100010000101101000110000100011010011000100110001100110001010001011100000001101110000011100110100";
	key:= "00101011011111100001010100010110001010001010111011010010101001101010101111110111000101011000100000001001110011110100111100111100";	
	key1:= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	data1:= "11110011010001001000000111101100001111001100011000100111101110101100110101011101110000111111101100001000111100100111001111100110";
	key2:= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	data2:= "11110011010001001000000111101100001111001100011000100111101110101100110101011101110000111111101100001000111100100111001111100110";
	--wait until clk'event AND clk = '1';
	--	reset <= '1';
	--	wait until clk'event AND clk = '1';
	--	reset <= '0';	 
		iv_load <= '0';
		wait until clk'event AND clk = '1';
		start <= '1';
		key_load <= '1';
		encrypt <= '1';	  
		stream<= '1';
		wait until clk'event AND clk = '1';	 

		dataIn(0 to 31) <= std_logic_vector(key(0 to 31));
		wait until clk'event AND clk = '1';		  
		--key_load <= '0';
		dataIn(0 to 31) <= std_logic_vector(key(32 to 63));	
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(64 to 95));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(96 to 127));
		wait until clk'event AND clk = '1';		
		db_load <= '1';		  
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(data(0 to 31));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(32 to 63));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(64 to 95));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(96 to 127));
		wait until clk'event AND clk = '1' AND done ='1';
		--if(done = '1') then
			cipher(0 to 31) := dataOut;			
		--end if; 
			report "cipher chunk 1:" & to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(32 to 63) := dataOut;	
		report "cipher chunk 2:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(64 to 95) := dataOut;	
		report "cipher chunk 3:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(96 to 127) := dataOut;	
		report "cipher chunk 4:" &  to_hstring(cipher);
		report "out " & to_hstring(cipher) & " : " & "3925841D02DC09FBDC118597196A0B32";   
		
		
		wait until clk'event AND clk = '1';	 
		reset <= '1';
		wait until clk'event AND clk = '1';	 
		iv_load <= '0';
		reset <= '0'; 
		wait until clk'event AND clk = '1';
		start <= '1';
		key_load <= '1';
		encrypt <= '1';	   
		wait until clk'event AND clk = '1';	
		dataIn(0 to 31) <= std_logic_vector(key1(0 to 31));
		wait until clk'event AND clk = '1';		  
		--key_load <= '0';
		dataIn(0 to 31) <= std_logic_vector(key1(32 to 63));	
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key1(64 to 95));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key1(96 to 127));
		wait until clk'event AND clk = '1';		
		
		db_load <= '1';		  
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(data1(0 to 31));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data1(32 to 63));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data1(64 to 95));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data1(96 to 127)); 
		
		wait until clk'event AND clk = '1'; 
		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';
		--if(done = '1') then
			cipher(0 to 31) := dataOut;			
		--end if; 
			report "cipher chunk 1:" & to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(32 to 63) := dataOut;	
		report "cipher chunk 2:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(64 to 95) := dataOut;	
		report "cipher chunk 3:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(96 to 127) := dataOut;	
		report "cipher chunk 4:" &  to_hstring(cipher);	
		report "out" & to_hstring(cipher) & ":" & "0336763E966D92595A567CC9CE537F5E";
		
		
		
		--reset <= '1';
--		wait until clk'event AND clk = '1';
--		reset <= '0';	 
--		iv_load <= '0';
--		wait until clk'event AND clk = '1';
--		start <= '1';
--		key_load <= '1';
--		encrypt <= '1';	 
--		wait until clk'event AND clk = '1';	 
--
--		dataIn(0 to 31) <= std_logic_vector(key(0 to 31));
--		wait until clk'event AND clk = '1';		  
--		key_load <= '0';
--		dataIn(0 to 31) <= std_logic_vector(key(32 to 63));	
--		wait until clk'event AND clk = '1';
--		dataIn(0 to 31) <= std_logic_vector(key(64 to 95));
--		wait until clk'event AND clk = '1';
--		dataIn(0 to 31) <= std_logic_vector(key(96 to 127));
--		wait until clk'event AND clk = '1';		
--		db_load <= '1';		  
--		wait until clk'event AND clk = '1';
--		dataIn(0 to 31) <= std_logic_vector(data(0 to 31));
--		wait until clk'event AND clk = '1';		
--		dataIn(0 to 31) <= std_logic_vector(data(32 to 63));
--		wait until clk'event AND clk = '1';		
--		dataIn(0 to 31) <= std_logic_vector(data(64 to 95));
--		wait until clk'event AND clk = '1';		
--		dataIn(0 to 31) <= std_logic_vector(data(96 to 127));
--		wait until clk'event AND clk = '1';
--		wait until clk'event AND clk = '1';
--		wait until clk'event AND clk = '1';
--		if(done = '1') then
--			cipher(0 to 31) := dataOut;			
--		end if; 
--			report "cipher chunk 1:" & to_hstring(cipher);
--		wait until clk'event AND clk = '1';	
--		cipher(32 to 63) := dataOut;	
--		report "cipher chunk 2:" &  to_hstring(cipher);
--		wait until clk'event AND clk = '1';	
--		cipher(64 to 95) := dataOut;	
--		report "cipher chunk 3:" &  to_hstring(cipher);
--		wait until clk'event AND clk = '1';	
--		cipher(96 to 127) := dataOut;	
--		report "cipher chunk 4:" &  to_hstring(cipher);
		
		--Tests 10 seperate encryptions-----------------------------------------------------
		for i in 0 to 9 loop
				data := tests_128(i).plain;
				key := 	tests_128(i).key;
wait until clk'event AND clk = '1';	 
		reset <= '1';
		wait until clk'event AND clk = '1';	 
		iv_load <= '0';
		reset <= '0'; 
		wait until clk'event AND clk = '1';
		start <= '1';
		key_load <= '1';
		encrypt <= '1';	   
		wait until clk'event AND clk = '1';	
		dataIn(0 to 31) <= std_logic_vector(key(0 to 31));
		wait until clk'event AND clk = '1';		  
		--key_load <= '0';
		dataIn(0 to 31) <= std_logic_vector(key(32 to 63));	
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(64 to 95));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(96 to 127));
		wait until clk'event AND clk = '1';		
		
		db_load <= '1';		  
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(data(0 to 31));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(32 to 63));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(64 to 95));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(96 to 127)); 
		
		wait until clk'event AND clk = '1'; 
		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';
		--if(done = '1') then
			cipher(0 to 31) := dataOut;			
		--end if; 
		--	report "cipher chunk 1:" & to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(32 to 63) := dataOut;	
		--report "cipher chunk 2:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(64 to 95) := dataOut;	
		--report "cipher chunk 3:" &  to_hstring(cipher);
		wait until clk'event AND clk = '1';	
		cipher(96 to 127) := dataOut;	
		--report "cipher chunk 4:" &  to_hstring(cipher);	
		--report "out" & to_hstring(cipher) & ":" & "0336763E966D92595A567CC9CE537F5E";
			 
		
		 report "Actual Output: " & to_hstring(cipher) & "     Expected: " & to_hstring(tests_128(i).expected);
		 assert cipher =	tests_128(i).expected report "test_128 failed. Round "&to_string(i); 
			
		end loop;

--		for i in 0 to 9 loop 
--				data := tests_128(i).plain;
--				key := 	tests_128(i).key;			
--			reset <= '1';
--			wait until clk'event AND clk = '1';
--			reset <= '0';	 
--			iv_load <= '0';
--			wait until clk'event AND clk = '1';
--			start <= '1';  
--			key_load <= '1'; 
--			wait until clk'event AND clk = '1';	
--			key_load_loop: for i in 0 to 3 loop	
--				wait until clk'event AND clk = '1';
--				dataIn(0 to 31) <= std_logic_vector(key(i*32 to i*32 + 31));
--				
--			end loop key_load_loop;	   
--			wait until clk'event AND clk = '1';
--			db_load <= '1';	  
--			wait until clk'event AND clk = '1';
--			data_load_loop: for i in 0 to 3 loop 
--				wait until clk'event AND clk = '1';
--				dataIn(0 to 31) <= std_logic_vector(data(i*32 to i*32 + 31));
--			end loop data_load_loop;
--			wait until clk'event AND clk = '1';	
--			wait until clk'event AND clk = '1';
--			wait until clk'event AND clk = '1';	
--			if(done = '1') then
--				cipher(0 to 31) := dataOut;	
--			end if; 
--			wait until clk'event AND clk = '1';	
--			cipher(32 to 63) := dataOut;	
--
--			wait until clk'event AND clk = '1';	
--			cipher(64 to 95) := dataOut;	
--			wait until clk'event AND clk = '1';	
--			cipher(96 to 127) := dataOut;	
--			 
--		
--		 report "Actual Output: " & to_hstring(cipher) & "     Expected: " & to_hstring(tests_128(i).expected);
--		 assert cipher =	tests_128(i).expected report "test_128 failed. Round "&to_string(i); 
--			
--		end loop;

		
		
		--for i in 0 to 9 loop
--			data := tests_128(i).plain;
--			key := 	tests_128(i).key;
--			
--			
--			reset <= '1'; 
--			wait until clk'event AND clk = '1';
--			reset <= '0'; 
--			iv_load <= '0';
--				start <= '1';  
--			key_load <= '1';
--			
--			key_load_loop: for i in 0 to 3 loop
--				dataIn(0 to 31) <= std_logic_vector(key(i*32 to i*32 + 31));
--				wait until clk'event AND clk = '1';
--			end loop key_load_loop;	
--			
--			db_load <= '1';
--			data_load_loop: for i in 0 to 3 loop
--				dataIn(0 to 31) <= std_logic_vector(data(i*32 to i*32 + 31));
--				wait until clk'event AND clk = '1';	
--			end loop data_load_loop;
--			
--			wait until clk'event AND clk = '1';	
--			if(done = '1') then
--				cipher(0 to 31) := dataOut;	
--			end if; 
--			wait until clk'event AND clk = '1';	
--			cipher(32 to 63) := dataOut;	
--			wait until clk'event AND clk = '1';	
--			cipher(64 to 95) := dataOut;	
--			wait until clk'event AND clk = '1';	
--			cipher(96 to 127) := dataOut;	
--			report "out" & to_hstring(cipher) & ":" & to_hstring(tests_128(i).expected);
--			assert cipher =	tests_128(i).expected report "test_128 failed. Round "&to_string(i); 
--			
--		end loop;
		
		
		simulationactive<= false;
		wait;
end process;
                                                    
functionProcess: process
variable testdata : std_logic_vector(0 to 127);
variable a,b,c : std_logic_vector(0 to 7);
	variable data : std_logic_vector(0 to 127) :=            --NIST.FIPS.197-upd1::pg34::round #1 
							                                "00011001"&"00111101"&"11100011"&"10111110"&
							                                "10100000"&"11110100"&"11100010"&"00101011"&
															"10011010"&"11000110"&"10001101"&"00101010"&
															"11101001"&"11111000"&"01001000"&"00001000";
	variable afterSub : std_logic_vector(0 to 127) :=         
							                                "11010100"&"00100111"&"00010001"&"10101110"&
							                                "11100000"&"10111111"&"10011000"&"11110001"&
															"10111000"&"10110100"&"01011101"&"11100101"&
															"00011110"&"01000001"&"01010010"&"00110000";
															
	variable afterShift : std_logic_vector(0 to 127) :=            
							                                "11010100"&"10111111"&"01011101"&"00110000"&
							                                "11100000"&"10110100"&"01010010"&"10101110"&
															"10111000"&"01000001"&"00010001"&"11110001"&
															"00011110"&"00100111"&"10011000"&"11100101"; 														
												   
	variable aftermix : std_logic_vector(0 to 127) := 			
                                							"00000100"&"01100110"&"10000001"&"11100101"&
														    "11100000"&"11001011"&"00011001"&"10011010"&
														    "01001000"&"11111000"&"11010011"&"01111010"&
														    "00101000"&"00000110"&"00100110"&"01001100";																											
	begin 
		--encrypt op
		testData := sbox(data, '0');
		assert testdata = aftersub report "sbox failed";		
		testData := shiftRows(aftersub, '0');
		assert testdata = afterShift report "shift failed";		
		testData := mixColumns(aftershift, '0');
		assert testdata = aftermix report "mixcol failed";
		--decrypt op
		testData := mixColumns(aftermix, '1');
		assert testdata = aftershift report "invmixcol failed";
		testData := shiftRows(aftershift, '1');
		assert testdata = afterSub report "invshift failed";
		testData := sbox(afterSub, '1');
		assert testdata = data report "invsbox failed";
		
		
		wait;
end process functionProcess;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_aes_128_encrypt_f24 of aes_128_encrypt_f24_tb is
	for TB_ARCHITECTURE
		for UUT : aes_128_encrypt_f24
			use entity work.aes_128_encrypt_f24(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_aes_128_encrypt_f24;


