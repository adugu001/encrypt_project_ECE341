library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shiftRows is
	port( dataIn : in std_logic_vector(0 to 127); encrypt : in std_logic; dataOut : out std_logic_vector(0 to 127));
end entity shiftRows;


architecture behavioral of shiftRows is
	
	
		

begin	
		
	dataOut( 0 to 7 )	<=  dataIn( 0  to 7);
	dataOut(32 to 39)	<=  dataIn(32  to 39);							
	dataOut(64 to 71)	<=  dataIn(64  to 71);
	dataOut(96 to 103)	<=  dataIn(96  to 103);		
	dataOut(8  to 15)	<=  dataIn(40  to 47) when encrypt = '0' else
							dataIn(104 to 111);		 		
	dataOut(40 to 47)	<=  dataIn(72  to 79) when encrypt = '0' else
							dataIn( 8  to 15);
	dataOut(72 to 79)	<=  dataIn(104 to 111) when encrypt = '0' else
							dataIn(40  to 47);		
	dataOut(104 to 111)	<=  dataIn(8   to 15) when encrypt = '0' else
							dataIn(72  to 79);
	dataOut(16 to 23)	<=  dataIn(80  to 87);
	dataOut(48 to 55)	<=  dataIn(112 to 119);							
	dataOut(80 to 87)	<=  dataIn(16  to 23);
	dataOut(112 to 119)	<=  dataIn(48  to 55);
	dataOut(24 to 31)	<=  dataIn(120 to 127) when encrypt = '0' else
							dataIn(56  to 63);
	dataOut(56 to 63)	<=  dataIn(24  to 31) when encrypt = '0' else
							dataIn(88  to 95);
	dataOut(88 to 95)	<=  dataIn(56  to 63) when encrypt = '0' else
							dataIn(120 to 127);
	dataOut(120 to 127)	<=  dataIn(88  to 95) when encrypt = '0' else
							dataIn(24  to 31); 
		
	
	
	

end behavioral; 