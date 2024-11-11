library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shiftRows is
	port(inverse : in std_logic; x : in std_logic_vector(0 to 127); z : out std_logic_vector(0 to 127));
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
	process(inverse, x)
	variable b0, b1, b2, b3, temp : std_logic_vector(0 to 7);
	begin					 
		--One loop for each row
		for i in 0 to 3 loop
			--Equate each column bytes based on row
			b0 := x(32*i      to 32*i + 7);
			b1 := x(32*i + 8  to 32*i + 15);
			b2 := x(32*i + 16 to 32*i + 23);
			b3 := x(32*i + 24 to 32*i + 31);
			--note: rotate 1 column left = rotate 3 columns right. Therefore below conditions can 
			--act as forward and reverse operations depending on i and inverse
			if ((i = 1 AND inverse = '0') OR (i = 3 AND inverse = '1')) then
				temp := b0;
				b0 := b1;
				b1 := b2;
				b2 := b3;
				b3 := temp;
			elsif(i=2) then	
				temp := b0;
				b0 := b2;
				b2 := temp;
				temp := b1;
				b1 := b3;
				b3 := temp;
			elsif((i = 3 AND inverse = '0') OR (i = 1 AND inverse = '1')) then
				temp := b0;
				b0 := b3;
				b3 := b2;
				b2 := b1;
				b1 := temp;
			end if;
			--assign rotated bits to the corresponding indices on the 128 bit array
			z(32*i      to 32*i + 7)  <= b0;
			z(32*i + 8  to 32*i + 15) <= b1;
			z(32*i + 16 to 32*i + 23) <= b2;
			z(32*i + 24 to 32*i + 31) <= b3;
		end loop;				
	end process;
end behavioral; 