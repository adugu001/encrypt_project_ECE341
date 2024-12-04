library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mix_columns is
	port(
		dataIn: in std_logic_vector(0 to 127);
		invert: in std_logic;
		dataOut : out std_logic_vector(0 to 127)
		);
end entity;

architecture dataflow of mix_columns is
type matrix is array (0 to 3,0 to 3) of std_logic_vector(0 to 7);
type tt	is array(0 to 3, 0 to 15) of std_logic_vector(0 to 7); 
type gg	is array(0 to 3, 0 to 7) of std_logic_vector(0 to 7);
signal S, D : matrix;
signal t : tt;
signal g : gg;
begin 
	s(0,0) <= datain(0   to 7 );
	s(0,1) <= datain(8   to 15);
	s(0,2) <= datain(16  to 23);
	s(0,3) <= datain(24  to 31);   
	s(1,0) <= datain(32  to 39); 
	s(1,1) <= datain(40  to 47);
	s(1,2) <= datain(48  to 55);
	s(1,3) <= datain(56  to 63);
	s(2,0) <= datain(64  to 71); 
	s(2,1) <= datain(72  to 79);
	s(2,2) <= datain(80  to 87);
	s(2,3) <= datain(88  to 95);
	s(3,0) <= datain(96  to 103);
	s(3,1) <= datain(104 to 111);
	s(3,2) <= datain(112 to 119);
	s(3,3) <= datain(120 to 127);
	
	IM: for i in 0 to 3 generate
		begin
		byte00: entity work.GF_Multiplier 
			port map(a => "00001110", b => s(i,0), product => t(i,0));	
		byte01: entity work.GF_Multiplier 
			port map(a => "00001011", b => s(i,1), product => t(i,1));
		byte02: entity work.GF_Multiplier 
			port map(a => "00001101", b => s(i,2), product => t(i,2));
		byte03: entity work.GF_Multiplier 
			port map(a => "00001001", b => s(i,3), product => t(i,3)); 
			
		byte10: entity work.GF_Multiplier 						 
			port map(a => "00001001", b => s(i,0), product => t(i,4));	
		byte11: entity work.GF_Multiplier 
			port map(a => "00001110", b => s(i,1), product => t(i,5));
		byte12: entity work.GF_Multiplier 
			port map(a => "00001011", b => s(i,2), product => t(i,6));
		byte13: entity work.GF_Multiplier 
			port map(a => "00001101", b => s(i,3), product => t(i,7));
			
		byte20: entity work.GF_Multiplier 
			port map(a => "00001101", b => s(i,0), product => t(i,8));	
		byte21: entity work.GF_Multiplier 
			port map(a => "00001001", b => s(i,1), product => t(i,9));
		byte22: entity work.GF_Multiplier 
			port map(a => "00001110", b => s(i,2), product => t(i,10));
		byte23: entity work.GF_Multiplier 
			port map(a => "00001011", b => s(i,3), product => t(i,11)); 
			
		byte30: entity work.GF_Multiplier 					   
			port map(a => "00001011", b => s(i,0), product => t(i,12));	
		byte31: entity work.GF_Multiplier 
			port map(a => "00001101", b => s(i,1), product => t(i,13));
		byte32: entity work.GF_Multiplier 
			port map(a => "00001001", b => s(i,2), product => t(i,14));
		byte33: entity work.GF_Multiplier 
			port map(a => "00001110", b => s(i,3), product => t(i,15));			
	end generate IM;	  
	
	EM: for i in 0 to 3 generate
		begin
		byte00: entity work.GF_Multiplier 
			port map(a => "00000010", b => s(i,0), product => g(i,0));	
		byte01: entity work.GF_Multiplier 
			port map(a => "00000011", b => s(i,1), product => g(i,1)); 
			
		byte11: entity work.GF_Multiplier 
			port map(a => "00000010", b => s(i,1), product => g(i,2));
		byte12: entity work.GF_Multiplier 
			port map(a => "00000011", b => s(i,2), product => g(i,3));

		byte22: entity work.GF_Multiplier 
			port map(a => "00000010", b => s(i,2), product => g(i,4));
		byte23: entity work.GF_Multiplier 
			port map(a => "00000011", b => s(i,3), product => g(i,5)); 
			
		byte30: entity work.GF_Multiplier 					   
			port map(a => "00000011", b => s(i,0), product => g(i,6));	
		byte33: entity work.GF_Multiplier 
			port map(a => "00000010", b => s(i,3), product => g(i,7));			
	end generate EM;
	
	D(0,0) <= 	g(0,0)  XOR g(0,1)  XOR s(0,2)  XOR s(0,3) when  invert = '0' else
				t(0,0)  XOR t(0,1)  XOR t(0,2)  XOR t(0,3) after 1ps;
	D(0,1) <= 	s(0,0)  XOR g(0,2)  XOR g(0,3)  XOR s(0,3) when  invert = '0' else
				t(0,4)  XOR t(0,5)  XOR t(0,6)  XOR t(0,7) after 1ps;
	D(0,2) <= 	s(0,0)  XOR s(0,1)  XOR g(0,4)  XOR g(0,5) when  invert = '0' else
				t(0,8)  XOR t(0,9)  XOR t(0,10) XOR t(0,11) after 1ps;
	D(0,3) <= 	g(0,6)  XOR s(0,1)  XOR s(0,2)  XOR g(0,7) when  invert = '0' else
				t(0,12) XOR t(0,13) XOR t(0,14) XOR t(0,15) after 1ps;	 
	
	D(1,0) <= 	g(1,0)  XOR g(1,1)  XOR s(1,2)  XOR s(1,3) when  invert = '0' else
				t(1,0)  XOR t(1,1)  XOR t(1,2)  XOR t(1,3) after 1ps;
	D(1,1) <= 	s(1,0)  XOR g(1,2)  XOR g(1,3)  XOR s(1,3) when  invert = '0' else
				t(1,4)  XOR t(1,5)  XOR t(1,6)  XOR t(1,7) after 1ps;
	D(1,2) <= 	s(1,0)  XOR s(1,1)  XOR g(1,4)  XOR g(1,5) when  invert = '0' else
				t(1,8)  XOR t(1,9)  XOR t(1,10) XOR t(1,11) after 1ps;
	D(1,3) <= 	g(1,6)  XOR s(1,1)  XOR s(1,2)  XOR g(1,7) when  invert = '0' else
				t(1,12) XOR t(1,13) XOR t(1,14) XOR t(1,15) after 1ps;
	
	D(2,0) <= 	g(2,0)  XOR g(2,1)  XOR s(2,2)  XOR s(2,3) when  invert = '0' else
				t(2,0)  XOR t(2,1)  XOR t(2,2)  XOR t(2,3) after 2ps;
	D(2,1) <= 	s(2,0)  XOR g(2,2)  XOR g(2,3)  XOR s(2,3) when  invert = '0' else
				t(2,4)  XOR t(2,5)  XOR t(2,6)  XOR t(2,7) after 2ps;
	D(2,2) <= 	s(2,0)  XOR s(2,1)  XOR g(2,4)  XOR g(2,5) when  invert = '0' else
				t(2,8)  XOR t(2,9)  XOR t(2,10) XOR t(2,11) after 2ps;
	D(2,3) <= 	g(2,6)  XOR s(2,1)  XOR s(2,2)  XOR g(2,7) when  invert = '0' else
				t(2,12) XOR t(2,13) XOR t(2,14) XOR t(2,15) after 2ps;
	
	D(3,0) <= 	g(3,0)  XOR g(3,1)  XOR s(3,2)  XOR s(3,3) when  invert = '0' else
				t(3,0)  XOR t(3,1)  XOR t(3,2)  XOR t(3,3) after 2ps;
	D(3,1) <= 	s(3,0)  XOR g(3,2)  XOR g(3,3)  XOR s(3,3) when  invert = '0' else
				t(3,4)  XOR t(3,5)  XOR t(3,6)  XOR t(3,7) after 2ps;
	D(3,2) <= 	s(3,0)  XOR s(3,1)  XOR g(3,4)  XOR g(3,5) when  invert = '0' else
				t(3,8)  XOR t(3,9)  XOR t(3,10) XOR t(3,11) after 2ps;
	D(3,3) <= 	g(3,6)  XOR s(3,1)  XOR s(3,2)  XOR g(3,7) when  invert = '0' else
				t(3,12) XOR t(3,13) XOR t(3,14) XOR t(3,15) after 2ps;	 
	
	dataOut(0   to 7 ) <= D(0,0) after 3ps;
	dataOut(8   to 15) <= D(0,1) after 3ps;
	dataOut(16  to 23) <= D(0,2) after 3ps;
	dataOut(24  to 31) <= D(0,3) after 3ps;   
	dataOut(32  to 39) <= D(1,0) after 3ps; 
	dataOut(40  to 47) <= D(1,1) after 3ps;
	dataOut(48  to 55) <= D(1,2) after 3ps;
	dataOut(56  to 63) <= D(1,3) after 3ps;
	dataOut(64  to 71) <= D(2,0) after 3ps; 
	dataOut(72  to 79) <= D(2,1) after 3ps;
	dataOut(80  to 87) <= D(2,2) after 3ps;
	dataOut(88  to 95) <= D(2,3) after 3ps;
	dataOut(96  to 103) <= D(3,0) after 3ps;
	dataOut(104 to 111) <= D(3,1) after 3ps;
	dataOut(112 to 119) <= D(3,2) after 3ps;
	dataOut(120 to 127) <= D(3,3) after 3ps;
end architecture;
