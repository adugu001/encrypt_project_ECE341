library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blackBox is
	port(
			dataIn: in std_logic_vector(0 to 127);
			encrypt: in std_logic;
			roundKey: in work.function_package.dataStore; 
			dataOut : out std_logic_vector(0 to 127)
		);
end entity;

architecture dataflow of blackBox is 
signal e_Data, e_subData, e_shiftData, e_mixData, d_Data, d_subData, d_shiftData, d_mixData, key : work.function_package.dataStore;

begin 
--E	
e_Data(0) <= dataIn XOR key(0);
encryptor_3000: for i in 1 to 9 generate
	subBox_entity :  entity work.sub_box	 port map(dataIn => e_Data(i-1), 	encrypt => encrypt, dataOut => e_subData(i));	--1ns
	shiftRow_entity: entity work.shiftRows 	 port map(dataIn => e_subData(i), 	encrypt => encrypt, dataOut => e_shiftdata(i));	--1ns
	mix_col_entity : entity work.mix_columns port map(datain => e_shiftData(i), encrypt => encrypt, dataout => e_mixData(i));	--4ns
	e_Data(i) <= e_mixData(i) XOR key(i);
end generate;
e_subBox_entity :  entity work.shiftRows	 port map(dataIn => e_Data(9), 		encrypt => encrypt, dataOut => e_subData(10));
e_shiftRow_entity: entity work.shiftRows 	 port map(dataIn => e_subData(10),  encrypt => encrypt, dataOut => e_shiftdata(10));
e_data(10) <= e_shiftData(10) XOR key(10);

--D
d_data(10) <= dataIn XOR key(10);
d_shiftRow_entity: entity work.shiftRows 	 port map(dataIn => d_data(10),  	 encrypt => encrypt, dataOut => d_shiftdata(10));
d_subBox_entity :  entity work.shiftRows	 port map(dataIn => d_shiftData(10), encrypt => encrypt, dataOut => d_subData(10));
decryptor_3000: for i in 9 downto 1 generate
	d_Data(i) <= d_mixData(i) XOR key(i);
	mix_col_entity : entity work.mix_columns port map(datain => d_Data(i+1), encrypt => encrypt, dataout => d_mixData(i)); 
	shiftRow_entity: entity work.shiftRows 	 port map(dataIn => d_mixData(i), 	encrypt => encrypt, dataOut => d_shiftdata(i));
	subBox_entity :  entity work.sub_box	 port map(dataIn => d_shiftData(i), 	encrypt => encrypt, dataOut => d_subData(i));	--1ns
end generate;
d_Data(0) <= d_subData(1) XOR key(0);

dataOut <=  e_data(10) when encrypt = '0' else d_data(0);

end architecture;