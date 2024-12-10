library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.function_package.all;						   

entity FN_entity_TB is
end FN_entity_TB;

ARCHITECTURE TB_ARCHITECTURE of FN_entity_TB is
	signal clk : STD_LOGIC := '0';
	signal encrypt : STD_LOGIC;
	signal data_in, SR_data, SB_data, MC_data : STD_LOGIC_VECTOR(0 to 127); 	
begin
	ROW_SHIFTER : entity work.shiftRows(dataflow)
		port map (
			clk => clk,
			dataIn =>   data_in,
			encrypt =>	encrypt,
			dataOut =>	SR_data
		);	
	COLUMN_MIXER : entity work.mix_columns
		port map (
			dataIn =>   data_in,
			encrypt =>	encrypt,
			dataOut =>	MC_data
		);
	BYTE_SUBBER : entity work.sub_box
		port map (
			dataIn =>   data_in,
			encrypt =>	encrypt,
			dataOut =>	SB_data
		);


TEST_FUNCTION_ENTITIES: PROCESS------------------------------------------------------------------------------------------------------------------------------
variable testdata : std_logic_vector(0 to 127);
variable data : std_logic_vector(0 to 127) :=   X"193DE3BEA0F4E22B9AC68D2AE9F84808";
variable afterSub : std_logic_vector(0 to 127) :=  X"D42711AEE0BF98F1B8B45DE51E415230";														
variable afterShift : std_logic_vector(0 to 127) := X"D4BF5D30E0B452AEB84111F11E2798E5";																									   
variable aftermix : std_logic_vector(0 to 127) := 	X"046681E5E0CB199A48F8D37A2806264C";												
											
begin 	
		--encrypt op 
		encrypt <= '0';
		data_in <= data;--1ns, erratic at 50 ns		
		wait for 1 ns;		  		  
		assert SB_data = afterSub report "sbox failed";
		
		data_in <= afterSub;--1ns
		wait for 1 ns;		  
		assert SR_data = afterShift report "shiftRow failed";
		
		data_in <= afterShift;
		wait for 4 ns;		  
		assert MC_data = afterMix report "mixcol failed";
		
		--decrypt op 
		encrypt <= '1';
		data_in <= afterMix;
		wait for 4 ns;		  
		assert MC_data = afterShift report "invMixCol failed";
		
		data_in <= afterShift;--1ns
		wait for 1 ns;		  
		assert SR_data = afterSub report "invShiftRow failed";
		
		data_in <= afterSub;--1ns		
		wait for 1 ns;		  		  
		assert SB_data = data report "invSbox failed";
 
		wait;
END PROCESS TEST_FUNCTION_ENTITIES;
END TB_ARCHITECTURE;


