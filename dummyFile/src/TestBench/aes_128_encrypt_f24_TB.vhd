library dummyFile;

library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use dummyFile.function_package.all;

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
		ECB_mode : in STD_LOGIC;
		CBC_mode : in STD_LOGIC;
		dataIn : in STD_LOGIC_VECTOR(0 to 31);
		dataOut : out STD_LOGIC_VECTOR(0 to 31);
		Done : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	signal start : STD_LOGIC;
	signal key_load : STD_LOGIC;
	signal IV_load : STD_LOGIC;
	signal db_load : STD_LOGIC;
	signal stream : STD_LOGIC;
	signal ECB_mode : STD_LOGIC;
	signal CBC_mode : STD_LOGIC;
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
			ECB_mode => ECB_mode,
			CBC_mode => CBC_mode,
			dataIn => dataIn,
			dataOut => dataOut,
			Done => Done
		);
		
process
	begin
		while simulationActive loop
			clk <='0'; wait for 1ns;
			clk <='1'; wait for 1ns;
		end loop;
		wait;	
end process;
		
	-- Add your stimulus here ...
clockProcess:process  
variable data : std_logic_vector(0 to 127);	

variable key : std_logic_vector(0 to 127);
begin	 	 
	data:= "00110010010000111111011010101000100010000101101000110000100011010011000100110001100110001010001011100000001101110000011100110100";
	key:= "00101011011111100001010100010110001010001010111011010010101001101010101111110111000101011000100000001001110011110100111100111100";
		wait until clk'event AND clk = '1';
		reset <= '1';
		wait until clk'event AND clk = '1';
		reset <= '0';
		wait until clk'event AND clk = '1';
		start <= '1';  
		wait until clk'event AND clk = '1';
		key_load <= '1';
		dataIn(0 to 31) <= std_logic_vector(key(0 to 31));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(32 to 63));	
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(64 to 95));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(key(96 to 127));
		wait until clk'event AND clk = '1';		
		db_load <= '1';
		dataIn(0 to 31) <= std_logic_vector(data(0 to 31));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(32 to 63));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(64 to 95));
		wait until clk'event AND clk = '1';		
		dataIn(0 to 31) <= std_logic_vector(data(96 to 127));
		wait until clk'event AND clk = '1';		

		simulationactive<= false;
		wait;
end process;
                                                    
functionProcess: process
  variable testdata : std_logic_vector(0 to 127);
	variable data : std_logic_vector(0 to 127) :=           
							                                "00000000"&"00010110"&"11110011"&"11001001"&
							                                "01001010"&"00000000"&"11111111"&"00001101"&
															"00000000"&"00010110"&"11110011"&"11001001"&
															"01001010"&"00000000"&"11111111"&"00001101"; 														
	variable substituted : std_logic_vector(0 to 127) :=	
                                							"01100011"&"01000111"&"00001101"&"11011101"&
													   		"11010110"&"01100011"&"00010110"&"11010111"&
													   		"01100011"&"01000111"&"00001101"&"11011101"&
													   		"11010110"&"01100011"&"00010110"&"11010111";												   
	variable mixed : std_logic_vector(0 to 127) := 			
                                							"11011101"&"00001101"&"01100011"&"01000111"&
														    "11010111"&"00010110"&"11010110"&"01100011"&
														    "11011101"&"00001101"&"01100011"&"01000111"&
														    "11010111"&"00010110"&"11010110"&"01100011";															
	variable rotated: std_logic_vector(0 to 127) := 		
                                							"11011101"&"00001101"&"01100011"&"01000111"&
														    "00010110"&"11010110"&"01100011"&"11010111"&
														    "01100011"&"01000111"&"11011101"&"00001101"&
														    "01100011"&"11010111"&"00010110"&"11010110";												
	begin 
		--ENCRYPTION
		--substitute data
		testData := sbox(data, '0');
--		assert(testData = substituted) report "sbox failed";
--		--mix columns
--		testdata := mixcol(substituted, '0');
--		assert(testData = mixed) report "mixcol fialed";
--		--shift rows
--		testdata := shiftrows(mixed, '0');
--		assert (testdata = rotated) report "shiftRows failed";
--		--DECRYPTION
--		--invert shift rows
--		testdata := shiftrows(rotated, '1');
--		assert (testdata = mixed) report "invert shiftRows failed";
--		--invert mix columns
--		testdata := mixcol(mixed, '1');
--		assert(testData = substituted) report "invert mixcol fialed";
--		--invert substitute data
--		testData := sbox(substituted, '1');
--		assert(testData = data) report "invert sbox failed";
		
		wait;
end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_aes_128_encrypt_f24 of aes_128_encrypt_f24_tb is
	for TB_ARCHITECTURE
		for UUT : aes_128_encrypt_f24
			use entity work.aes_128_encrypt_f24(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_aes_128_encrypt_f24;


