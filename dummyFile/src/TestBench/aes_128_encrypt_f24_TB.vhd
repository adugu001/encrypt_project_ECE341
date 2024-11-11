library dummyFile;
use dummyFile.function_package.all;
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.function_package.all;

entity aes_128_encrypt_f24_tb is
end aes_128_encrypt_f24_tb;

architecture TB_ARCHITECTURE of aes_128_encrypt_f24_tb is 

--TESTING FUNCTIONS ONLY AT THIS POINT**********************
--	-- Component declaration of the tested unit
--	component aes_128_encrypt_f24
--	port(
--		clk : in STD_LOGIC;
--		reset : in STD_LOGIC;
--		start : in STD_LOGIC;
--		key_load : in STD_LOGIC;
--		IV_load : in STD_LOGIC;
--		db_load : in STD_LOGIC;
--		stream : in STD_LOGIC;
--		ECB_mode : in STD_LOGIC;
--		CBC_mode : in STD_LOGIC;
--		dataIn : in STD_LOGIC_VECTOR(0 to 31);
--		dataOut : out STD_LOGIC_VECTOR(0 to 31);
--		Done : out STD_LOGIC );
--	end component;
--
--	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
--	signal clk : STD_LOGIC;
--	signal reset : STD_LOGIC;
--	signal start : STD_LOGIC;
--	signal key_load : STD_LOGIC;
--	signal IV_load : STD_LOGIC;
--	signal db_load : STD_LOGIC;
--	signal stream : STD_LOGIC;
--	signal ECB_mode : STD_LOGIC;
--	signal CBC_mode : STD_LOGIC;
--	signal dataIn : STD_LOGIC_VECTOR(0 to 31);
--	-- Observed signals - signals mapped to the output ports of tested entity
--	signal dataOut : STD_LOGIC_VECTOR(0 to 31);
--	signal Done : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	--UUT : aes_128_encrypt_f24
--		port map (
--			clk => clk,
--			reset => reset,
--			start => start,
--			key_load => key_load,
--			IV_load => IV_load,
--			db_load => db_load,
--			stream => stream,
--			ECB_mode => ECB_mode,
--			CBC_mode => CBC_mode,
--			dataIn => dataIn,
--			dataOut => dataOut,
--			Done => Done
--		);

-- Add your stimulus here ...
process										 	 --0
	variable testdata : std_logic_vector(0 to 127);
	variable data : std_logic_vector(0 to 127) :=           "00000000"&"00010110"&"11110011"&"11001001"&
				                                            "01001010"&"00000000"&"11111111"&"00001101"&
															"00000000"&"00010110"&"11110011"&"11001001"&
															"01001010"&"00000000"&"11111111"&"00001101"; 
															
	variable substituted : std_logic_vector(0 to 127) :=	"01100011"&"01000111"&"00001101"&"11011101"&
													   		"11010110"&"01100011"&"00010110"&"11010111"&
													   		"01100011"&"01000111"&"00001101"&"11011101"&
													   		"11010110"&"01100011"&"00010110"&"11010111";
															   
	variable mixed : std_logic_vector(0 to 127) := 			"11011101"&"00001101"&"01100011"&"01000111"&
														    "11010111"&"00010110"&"11010110"&"01100011"&
														    "11011101"&"00001101"&"01100011"&"01000111"&
														    "11010111"&"00010110"&"11010110"&"01100011";
															
	variable rotated: std_logic_vector(0 to 127) := 		"11011101"&"00001101"&"01100011"&"01000111"&
														    "00010110"&"11010110"&"01100011"&"11010111"&
														    "01100011"&"01000111"&"11011101"&"00001101"&
														    "01100011"&"11010111"&"00010110"&"11010110";															
	begin 
		--ENCRYPTION
		--substitute data
		testData := sbox(data, '0');
		assert(testData = substituted) report "sbox failed";
		--mix columns
		testdata := mixcol(substituted, '0');
		assert(testData = mixed) report "mixcol fialed";
		--shift rows
		testdata := shiftrows(mixed, '0');
		assert (testdata = rotated) report "shiftRows failed";
		--DECRYPTION
		--invert shift rows
		testdata := shiftrows(rotated, '1');
		assert (testdata = mixed) report "invert shiftRows failed";
		--invert mix columns
		testdata := mixcol(mixed, '1');
		assert(testData = substituted) report "invert mixcol fialed";
		--invert substitute data
		testData := sbox(substituted, '1');
		assert(testData = data) report "invert sbox failed";
		
		wait;
	end process;

end TB_ARCHITECTURE;

--configuration TESTBENCH_FOR_aes_128_encrypt_f24 of aes_128_encrypt_f24_tb is
--	for TB_ARCHITECTURE
--		for UUT : aes_128_encrypt_f24
--			use entity work.aes_128_encrypt_f24(behavioral);
--		end for;
--	end for;
--end TESTBENCH_FOR_aes_128_encrypt_f24;

