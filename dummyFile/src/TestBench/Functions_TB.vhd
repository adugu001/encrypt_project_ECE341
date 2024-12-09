library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.function_package.all;						   

entity Functions_TB is
end Functions_TB;

ARCHITECTURE TB_ARCHITECTURE of Functions_TB is
	signal clk : STD_LOGIC := '0';
	signal encrypt : STD_LOGIC;
	signal data_in : STD_LOGIC_VECTOR(0 to 127); 	


begin

TEST_FUNCTIONS: PROCESS------------------------------------------------------------------------------------------------------------------------------
variable testdata : std_logic_vector(0 to 127);
variable data : std_logic_vector(0 to 127) :=   X"193DE3BEA0F4E22B9AC68D2AE9F84808";
variable afterSub : std_logic_vector(0 to 127) :=  X"D42711AEE0BF98F1B8B45DE51E415230";														
variable afterShift : std_logic_vector(0 to 127) := X"D4BF5D30E0B452AEB84111F11E2798E5";																									   
variable aftermix : std_logic_vector(0 to 127) := 	X"046681E5E0CB199A48F8D37A2806264C";
variable the_keys : work.function_package.key_store;													
											
begin 	
		--encrypt
		encrypt <= '0';
		wait for 0ns;
		
		assert afterSub = sbox(data, encrypt) report "sbox failed";		
		assert afterShift = shiftRows(aftersub, encrypt) report "shiftRows failed"; 		
		assert aftermix = mixColumns(aftershift, encrypt) report "mixColumns Failed";

		--decrypt 
		encrypt <= '1';
		wait for 0ns;
		
		assert aftershift = mixColumns(afterMix, encrypt) report "invMixColumns Failed";
		assert afterSub = shiftRows(afterShift, encrypt) report "invShiftRows failed";
		assert data = sBox(afterSub, encrypt) report "invSbox failed";

		--assert generateRoundKeys = '0' report "roundkey gen failed";
		
		
		wait;
END PROCESS TEST_FUNCTIONS;
END TB_ARCHITECTURE; 

