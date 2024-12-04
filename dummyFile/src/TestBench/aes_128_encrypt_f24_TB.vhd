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
	signal c, a, b : std_logic_vector(0 to 127) := (others =>'0');

begin
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
	mix_col_entity : entity work.mix_columns 
			port map( 
				datain => a,  
				invert => encrypt,
				dataout => c
			);	
process
	begin
		while simulationActive loop
			clk <='0'; wait for 50ns;
			clk <='1'; wait for 50ns;
		end loop;
		wait;	
end process;

clockProcess:process  
variable expect : std_logic_vector(0 to 127) := "00111001"&"00100101"&"10000100"&"00011101"&
												"00000010"&"11011100"&"00001001"&"11111011"&
												"11011100"&"00010001"&"10000101"&"10010111"&
												"00011001"&"01101010"&"00001011"&"00110010";
variable data0 : std_logic_vector(0 to 127)  :=	"00110010"&"01000011"&"11110110"&"10101000"&
												"10001000"&"01011010"&"00110000"&"10001101"&
												"00110001"&"00110001"&"10011000"&"10100010"&
												"11100000"&"00110111"&"00000111"&"00110100";	
variable data1 : std_logic_vector(0 to 127):= 	"11110011"&"01000100"&"10000001"&"11101100"&
												"00111100"&"11000110"&"00100111"&"10111010"&
												"11001101"&"01011101"&"11000011"&"11111011"&
												"00001000"&"11110010"&"01110011"&"11100110";	    
variable key0 : std_logic_vector(0 to 127):= 	"00101011"&"01111110"&"00010101"&"00010110"&
												"00101000"&"10101110"&"11010010"&"10100110"&
												"10101011"&"11110111"&"00010101"&"10001000"&
												"00001001"&"11001111"&"01001111"&"00111100"; 	  
variable key1 : std_logic_vector(0 to 127) := (others => '0');
variable temp_data, temp_key, cipher, expected : std_logic_vector(0 to 127);
type stream_store is array (1 to 3) of std_logic_vector(0 to 127);
variable CBC_file, ECB_file: stream_store;
begin
		wait until clk'event AND clk = '1';
		encrypt <= '1'; iv_load <= '0'; 
		
		wait until clk'event AND clk = '1';	
		--ENCRYPTION ON INDIVIDUAL BLOCKS------------------------------------------------------------
		straight_encryption: for k in 0 to 11 loop			  
			if k=0 then temp_key := key0; temp_data := data0; expected := X"3925841D02DC09FBDC118597196A0B32";
			elsif k=1 then 
				temp_key := key1; 
				temp_data := data1; 
				expected := X"0336763E966D92595A567CC9CE537F5E";
			else temp_key := tests_128(k).key; temp_data := tests_128(k).plain; expected := tests_128(k).expected;
			end if;
			
			stream <= '1'; start <= '1';
			wait until clk'event AND clk = '1';
			
			key_load <= '1';
			load_key: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';					
			end loop load_key;
			
			db_load <= '1'; wait until clk'event AND clk = '1';
			load_data: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';
			end loop load_data;
			  
			wait until clk'event AND clk = '1';	--eating clk cycles to encrypt
			wait until clk'event AND clk = '1'; 

			stream <= '0'; start <= '0';
			cipher_out: for i in 0 to 3 loop
				cipher(i*32 to i*32 + 31) := dataOut;
				wait until clk'event AND clk = '1';
			end loop cipher_out;
			assert cipher = expected report "Actual Output: " & to_hstring(cipher) & character'val(10) & "                          Expected: " & to_hstring(expected);	 
			
		end loop straight_encryption;	   
		--ENCRYPTION ON CHAINED BLOCKS------------------------------------------------------------
		temp_key := tests_128(7).key; temp_data := tests_128(7).plain; expected := tests_128(7).expected;
		
		CBC_encryption: for k in 0 to 1 loop
			if k = 0 then CBC_mode <= '0';
			else CBC_mode <= '1'; end if;
			stream <= '1'; start <= '1';
			wait until clk'event AND clk = '1';			
			start <= '0';
			load_key: for i in 0 to 3 loop
				dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
				wait until clk'event AND clk = '1';					
			end loop load_key;
			
			for j in 1 to 3 loop									
					db_load <= '1'; wait for 0ns;
					wait until clk'event AND clk = '1';
					load_data: for i in 0 to 3 loop
						dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
						wait until clk'event AND clk = '1';
					end loop load_data;
					db_load <= '0';  
					wait until clk'event AND clk = '1';	--eating clk cycles to encrypt

					wait until clk'event AND clk = '1'; 
					
					if j = 3 then stream <= '0'; end if;
					cipher_out: for i in 0 to 3 loop
						if k = 0 then ECB_file(j)(i*32 to i*32 + 31) := dataOut;
						else 		  CBC_file(j)(i*32 to i*32 + 31) := dataOut; end if;
						wait until clk'event AND clk = '1';
					end loop cipher_out;
			end loop;				
		end loop CBC_encryption;
		assert (ECB_file(1) = ECB_file(2) AND ECB_file(1) = ECB_file(3)) report "ecb output not repeated";
		assert CBC_file(1) /= CBC_file(2) AND CBC_file(1) /= CBC_file(3) AND CBC_file(2) /= CBC_file(3) report "CBC has repeated outputs";
		assert CBC_file(1) = ECB_file(1) report "ECB and CBC initial encryption differ";

		--DECRYPTION ON INDIVIDUAL BLOCKS----------------------------------------------------------------------
		temp_key := key0; temp_data := expect; expected := X"3243f6a8885a308d313198a2e0370734";
		reset <= '1';
		wait until clk'event AND clk = '1';
		reset <= '0'; iv_load <= '0';
		wait until clk'event AND clk = '1';
		start <= '1'; key_load <= '1'; encrypt <= '0';	  
		--stream<= '1';
		wait until clk'event AND clk = '1';	 
		
		
		load_key: for i in 0 to 3 loop
			dataIn(0 to 31) <= std_logic_vector(temp_key(i*32 to i*32 + 31));
			wait until clk'event AND clk = '1';					
		end loop load_key;
		
		db_load <= '1'; wait until clk'event AND clk = '1';
		load_data: for i in 0 to 3 loop
			dataIn(0 to 31) <= std_logic_vector(temp_data(i*32 to i*32 + 31));
			wait until clk'event AND clk = '1';
		end loop load_data;
		  
		wait until clk'event AND clk = '1' AND done ='1';	--eating clk cycles for some reason
		wait until clk'event AND clk = '1' AND done ='1'; 
		
		wait until done = '1';
		cipher_out: for i in 0 to 3 loop
				cipher(i*32 to i*32 + 31) := dataOut;
				wait until clk'event AND clk = '1';
				report "cipher chunk " & to_string(i) & ": " & to_hstring(cipher); --debug purpose
		end loop cipher_out;
		assert cipher = data0 report "Actual Output: " & to_hstring(cipher) & character'val(10) & "Expected: " & to_hstring(expected);	 
		--DECRYPTION ON CHAINED BLOCKS----------------------------------------------------------------------
			--TODO
		simulationactive<= false;
		wait;
end process;
                                                    
functionProcess: process------------------------------------------------------------------------------------------------------------------------------
variable testdata : std_logic_vector(0 to 127);
variable data : std_logic_vector(0 to 127) :=   	"00011001"&"00111101"&"11100011"&"10111110"&  --NIST.FIPS.197-upd1::pg34::round #1 
					                                "10100000"&"11110100"&"11100010"&"00101011"&
													"10011010"&"11000110"&"10001101"&"00101010"&
													"11101001"&"11111000"&"01001000"&"00001000";
variable afterSub : std_logic_vector(0 to 127) :=   "11010100"&"00100111"&"00010001"&"10101110"&
					                                "11100000"&"10111111"&"10011000"&"11110001"&
													"10111000"&"10110100"&"01011101"&"11100101"&
													"00011110"&"01000001"&"01010010"&"00110000";														
variable afterShift : std_logic_vector(0 to 127) := "11010100"&"10111111"&"01011101"&"00110000"&
					                                "11100000"&"10110100"&"01010010"&"10101110"&
													"10111000"&"01000001"&"00010001"&"11110001"&
													"00011110"&"00100111"&"10011000"&"11100101"; 																									   
variable aftermix : std_logic_vector(0 to 127) := 	"00000100"&"01100110"&"10000001"&"11100101"&
												    "11100000"&"11001011"&"00011001"&"10011010"&
												    "01001000"&"11111000"&"11010011"&"01111010"&
												    "00101000"&"00000110"&"00100110"&"01001100";
											
begin 	
	--encrypt op
		
		testData := sbox(data, '0');
		assert testdata = aftersub report "sbox failed";		
		testData := shiftRows(aftersub, '0');
		assert testdata = afterShift report "shift failed";	
		
		encrypt <= '0';
		a <= afterShift;
		for i in 0 to 10 loop
			wait for 1 ns;		  
		end loop;
		testData := mixColumns(aftershift, '0');
		assert testdata = aftermix report "mixcol failed";
		
		--decrypt op
		encrypt <= '1';
		a<= aftermix; 
		for i in 0 to 10 loop
			wait for 1 ns;		  
		end loop;
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


