library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sub_box is
	port(
		dataIn: in std_logic_vector(0 to 127);
		encrypt: in std_logic;
		dataOut : out std_logic_vector(0 to 127)
		);
end entity;

architecture dataflow of Sub_box is	
begin
	gen: for i in 0 to 15 generate
		sub_a_byte: entity work.sbox 
			port map(dataIn => datain(i*8 to i*8 + 7), encrypt => encrypt, dataOut => dataOut(i*8 to i*8 + 7));
	end generate; 		  
end architecture;
		