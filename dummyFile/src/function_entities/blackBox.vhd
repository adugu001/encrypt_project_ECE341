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
signal stateData, subData, shiftData, mixData, key : work.function_package.dataStore;

begin
stateData(0) <= dataIn XOR key(0);

gen: for i in 1 to 9 generate
	subBox_entity :  entity work.sub_box	 port map(dataIn => stateData(i-1), encrypt => encrypt, dataOut => subData(i));	--1ns
	shiftRow_entity: entity work.shiftRows 	 port map(dataIn => subData(i), 	encrypt => encrypt, dataOut => shiftdata(i));	--1ns
	mix_col_entity : entity work.mix_columns port map(datain => shiftData(i), 	encrypt => encrypt, dataout => mixData(i));	--4ns
	stateData(i) <= mixData(i) XOR key(i);
end generate;

subBox_entity :  entity work.shiftRows	 port map(dataIn => stateData(9), encrypt => encrypt, dataOut => subData(10));
shiftRow_entity: entity work.shiftRows 	 port map(dataIn => subData(10),  encrypt => encrypt, dataOut => shiftdata(10));
dataOut <= shiftData(10) XOR key(10);
end architecture;