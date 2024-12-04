library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shiftRows is
	port( dataIn : in std_logic_vector(0 to 127); encrypt : in std_logic; dataOut : out std_logic_vector(0 to 127));
end entity shiftRows;


architecture behavioral of shiftRows is
	
--| r0  |  0-7  |  8-15 | 16-23 | 24-31 |
--| r1  | 32-39 | 40-47 | 48-55 | 56-63 |
--| r2  | 64-71 | 72-79 | 80-87 | 88-95 |
--| r3  | 96-103|104-111|112-119|120-127|	
--	\/ \/ \/ 		   /\ /\ /\
--	\/ \/ \/		   /\ /\ /\
--| r0  |  0-7  |  8-15 | 16-23 | 24-31 |
--| r1  | 40-47 | 48-55 | 56-63 | 32-39 | 
--| r2  | 80-87 | 88-95 | 64-71 | 72-79 |
--| r3  |120-127| 96-103|104-111|112-119|		

begin	

			dataOut(8*15 to 8*16- 1) 	<= dataIn(8*11  to 8*12 -1) when encrypt = '0';
			dataOut(8*14 to 8*15 - 1)	<= dataIn(8*6 to 8*7 - 1) when encrypt = '0';
			dataOut(8*13 to 8*14 -1) 	<= dataIn(8*1   to  8*2 - 1) when encrypt = '0'; 
			dataOut(8*12 to 8*13 - 1) 	<= dataIn(8*12  to  8*13 - 1) when encrypt = '0';
			dataOut(8*11 to 8*12 - 1) 	<= dataIn(8*7   to  8*8 -1) when encrypt = '0';
			dataOut(8*10 to 8*11 - 1) 	<= dataIn(8*2   to  8*3 - 1) when encrypt = '0'; 
			dataOut(8*9 to 8*10-1) 		<= dataIn(8*13  to  8*14-1) when encrypt = '0';
			dataOut(8*8 to 8*9-1) 		<= dataIn(8*8   to  8*9-1) when encrypt = '0';
			dataOut(8*7 to 8*8-1) 		<= dataIn(8*3   to  8*4-1) when encrypt = '0';
			dataOut(8*6 to 8*7-1) 		<= dataIn(8*14  to  8*15-1) when encrypt = '0';
			dataOut(8*5 to 8*6-1) 		<= dataIn(8*9  to  8*10-1) when encrypt = '0';
			dataOut(8*4 to 8*5-1) 		<= dataIn(8*4   to  8*5-1) when encrypt = '0';
			dataOut(8*3 to 8*4-1) 		<= dataIn(8*15  to  8*16-1) when encrypt = '0';
			dataOut(8*2 to 8*3-1) 		<= dataIn(8*10  to  8*11-1) when encrypt = '0';
			dataOut(8*1 to 8*2-1) 		<= dataIn(8*5   to  8*6-1) when encrypt = '0';
			dataOut(8*0 to 8*1-1) 		<= dataIn(8*0   to  8*1-1) when encrypt = '0'; 			 
			
			dataOut(8*11  to 8*12 -1) 	<= dataIn(8*15 to 8*16- 1) when encrypt = '1';
			dataOut(8*6 to 8*7 - 1) 	<= dataIn(8*14 to 8*15 - 1) when encrypt = '1';
			dataOut(8*1   to  8*2 - 1) 	<= dataIn(8*13 to 8*14 -1) when encrypt = '1'; 
			dataOut(8*12  to  8*13 - 1) <= dataIn(8*12 to 8*13 - 1) when encrypt = '1';
			dataOut(8*7   to  8*8 -1) 	<= dataIn(8*11 to 8*12 - 1) when encrypt = '1';
			dataOut(8*2   to  8*3 - 1)  <= dataIn(8*7   to  8*8 -1) when encrypt = '1'; 
			dataOut(8*13  to  8*14-1) 	<= dataIn(8*9 to 8*10-1) when encrypt = '1';
			dataOut(8*8   to  8*9-1) 	<= dataIn(8*8 to 8*9-1) when encrypt = '1';
			dataOut(8*3   to  8*4-1) 	<= dataIn(8*7 to 8*8-1) when encrypt = '1';
			dataOut(8*14  to  8*15-1) 	<= dataIn(8*6 to 8*7-1) when encrypt = '1';
			dataOut(8*9  to  8*10-1) 	<= dataIn(8*5 to 8*6-1) when encrypt = '1';
			dataOut(8*4   to  8*5-1) 	<= dataIn(8*4 to 8*5-1) when encrypt = '1';
			dataOut(8*15  to  8*16-1) 	<= dataIn(8*3 to 8*4-1) when encrypt = '1';
			dataOut(8*10  to  8*11-1) 	<= dataIn(8*2 to 8*3-1) when encrypt = '1';
			dataOut(8*5   to  8*6-1) 	<= dataIn(8*1 to 8*2-1) when encrypt = '1';
			dataOut(8*0   to  8*1-1) 	<= dataIn(8*0 to 8*1-1) when encrypt = '1'; 

end behavioral; 