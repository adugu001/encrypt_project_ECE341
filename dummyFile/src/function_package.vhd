library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package function_package is
    function sbox ( byte : in std_logic_vector(0 to 127);  invert : std_logic ) return std_logic_vector;
    function shiftRows( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector;
	function mixCol( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector;
	function addRoundKey( data : std_logic_vector(0 to 127); key : std_logic_vector(0 to 127)) return std_logic_vector;
end package function_package;	 	

package body function_package is																   
	
	
--------------------------------------------------------------------------------------------------------------------------------------
--Substitution by LUT
function sbox ( byte : in std_logic_vector(0 to 127) ; invert : std_logic ) return std_logic_vector is
type ROM is array (0 to 15, 0 to 15) of integer;
constant encrypt_substitution : ROM := (	   
--0			1		2		3		4		5		6		7		8		9	  10/A	  11/B	  12/C	  13/D	  14/E	  15/F
(16#63#, 16#7c#, 16#77#, 16#7b#, 16#f2#, 16#6b#, 16#6f#, 16#c5#, 16#30#, 16#01#, 16#67#, 16#2b#, 16#fe#, 16#d7#, 16#ab#, 16#76#),--0
(16#ca#, 16#82#, 16#c9#, 16#7d#, 16#fa#, 16#59#, 16#47#, 16#f0#, 16#ad#, 16#d4#, 16#a2#, 16#af#, 16#9c#, 16#a4#, 16#72#, 16#c0#),--1
(16#b7#, 16#fd#, 16#93#, 16#26#, 16#36#, 16#3f#, 16#f7#, 16#cc#, 16#34#, 16#a5#, 16#e5#, 16#f1#, 16#71#, 16#d8#, 16#31#, 16#15#),--2
(16#04#, 16#c7#, 16#23#, 16#c3#, 16#18#, 16#96#, 16#05#, 16#9a#, 16#07#, 16#12#, 16#80#, 16#e2#, 16#eb#, 16#27#, 16#b2#, 16#75#),--3
(16#09#, 16#83#, 16#2c#, 16#1a#, 16#1b#, 16#6e#, 16#5a#, 16#a0#, 16#52#, 16#3b#, 16#d6#, 16#b3#, 16#29#, 16#e3#, 16#2f#, 16#84#),--4
(16#53#, 16#d1#, 16#00#, 16#ed#, 16#20#, 16#fc#, 16#b1#, 16#5b#, 16#6a#, 16#cb#, 16#be#, 16#39#, 16#4a#, 16#4c#, 16#58#, 16#cf#),--5
(16#d0#, 16#ef#, 16#aa#, 16#fb#, 16#43#, 16#4d#, 16#33#, 16#85#, 16#45#, 16#f9#, 16#02#, 16#7f#, 16#50#, 16#3c#, 16#9f#, 16#a8#),--6
(16#51#, 16#a3#, 16#40#, 16#8f#, 16#92#, 16#9d#, 16#38#, 16#f5#, 16#bc#, 16#b6#, 16#da#, 16#21#, 16#10#, 16#ff#, 16#f3#, 16#d2#),--7
(16#cd#, 16#0c#, 16#13#, 16#ec#, 16#5f#, 16#97#, 16#44#, 16#17#, 16#c4#, 16#a7#, 16#7e#, 16#3d#, 16#64#, 16#5d#, 16#19#, 16#73#),--8
(16#60#, 16#81#, 16#4f#, 16#dc#, 16#22#, 16#2a#, 16#90#, 16#88#, 16#46#, 16#ee#, 16#b8#, 16#14#, 16#de#, 16#5e#, 16#0b#, 16#db#),--9
(16#e0#, 16#32#, 16#3a#, 16#0a#, 16#49#, 16#06#, 16#24#, 16#5c#, 16#c2#, 16#d3#, 16#ac#, 16#62#, 16#91#, 16#95#, 16#e4#, 16#79#),--10/A
(16#e7#, 16#c8#, 16#37#, 16#6d#, 16#8d#, 16#d5#, 16#4e#, 16#a9#, 16#6c#, 16#56#, 16#f4#, 16#ea#, 16#65#, 16#7a#, 16#ae#, 16#08#),--11/B
(16#ba#, 16#78#, 16#25#, 16#2e#, 16#1c#, 16#a6#, 16#b4#, 16#c6#, 16#e8#, 16#dd#, 16#74#, 16#1f#, 16#4b#, 16#bd#, 16#8b#, 16#8a#),--12/C
(16#70#, 16#3e#, 16#b5#, 16#66#, 16#48#, 16#03#, 16#f6#, 16#0e#, 16#61#, 16#35#, 16#57#, 16#b9#, 16#86#, 16#c1#, 16#1d#, 16#9e#),--13/D
(16#e1#, 16#f8#, 16#98#, 16#11#, 16#69#, 16#d9#, 16#8e#, 16#94#, 16#9b#, 16#1e#, 16#87#, 16#e9#, 16#ce#, 16#55#, 16#28#, 16#df#),--14/E
(16#8c#, 16#a1#, 16#89#, 16#0d#, 16#bf#, 16#e6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2d#, 16#0f#, 16#b0#, 16#54#, 16#bb#, 16#16#) --15/F
); 

constant decrypt_substitution : ROM := (
(16#52#, 16#09#, 16#6a#, 16#d5#, 16#30#, 16#36#, 16#a5#, 16#38#, 16#bf#, 16#40#, 16#a3#, 16#9e#, 16#81#, 16#f3#, 16#d7#, 16#fb#),
(16#7c#, 16#e3#, 16#39#, 16#82#, 16#9b#, 16#2f#, 16#ff#, 16#87#, 16#34#, 16#8e#, 16#43#, 16#44#, 16#c4#, 16#de#, 16#e9#, 16#cb#),
(16#54#, 16#7b#, 16#94#, 16#32#, 16#a6#, 16#c2#, 16#23#, 16#3d#, 16#ee#, 16#4c#, 16#95#, 16#0b#, 16#42#, 16#fa#, 16#c3#, 16#4e#),
(16#08#, 16#2e#, 16#a1#, 16#66#, 16#28#, 16#d9#, 16#24#, 16#b2#, 16#76#, 16#5b#, 16#a2#, 16#49#, 16#6d#, 16#8b#, 16#d1#, 16#25#),
(16#72#, 16#f8#, 16#f6#, 16#64#, 16#86#, 16#68#, 16#98#, 16#16#, 16#d4#, 16#a4#, 16#5c#, 16#cc#, 16#5d#, 16#65#, 16#b6#, 16#92#),
(16#6c#, 16#70#, 16#48#, 16#50#, 16#fd#, 16#ed#, 16#b9#, 16#da#, 16#5e#, 16#15#, 16#46#, 16#57#, 16#a7#, 16#8d#, 16#9d#, 16#84#),
(16#90#, 16#d8#, 16#ab#, 16#00#, 16#8c#, 16#bc#, 16#d3#, 16#0a#, 16#f7#, 16#e4#, 16#58#, 16#05#, 16#b8#, 16#b3#, 16#45#, 16#06#),
(16#d0#, 16#2c#, 16#1e#, 16#8f#, 16#ca#, 16#3f#, 16#0f#, 16#02#, 16#c1#, 16#af#, 16#bd#, 16#03#, 16#01#, 16#13#, 16#8a#, 16#6b#),
(16#3a#, 16#91#, 16#11#, 16#41#, 16#4f#, 16#67#, 16#dc#, 16#ea#, 16#97#, 16#f2#, 16#cf#, 16#ce#, 16#f0#, 16#b4#, 16#e6#, 16#73#),
(16#96#, 16#ac#, 16#74#, 16#22#, 16#e7#, 16#ad#, 16#35#, 16#85#, 16#e2#, 16#f9#, 16#37#, 16#e8#, 16#1c#, 16#75#, 16#df#, 16#6e#),
(16#47#, 16#f1#, 16#1a#, 16#71#, 16#1d#, 16#29#, 16#c5#, 16#89#, 16#6f#, 16#b7#, 16#62#, 16#0e#, 16#aa#, 16#18#, 16#be#, 16#1b#),
(16#fc#, 16#56#, 16#3e#, 16#4b#, 16#c6#, 16#d2#, 16#79#, 16#20#, 16#9a#, 16#db#, 16#c0#, 16#fe#, 16#78#, 16#cd#, 16#5a#, 16#f4#),
(16#1f#, 16#dd#, 16#a8#, 16#33#, 16#88#, 16#07#, 16#c7#, 16#31#, 16#b1#, 16#12#, 16#10#, 16#59#, 16#27#, 16#80#, 16#ec#, 16#5f#),
(16#60#, 16#51#, 16#7f#, 16#a9#, 16#19#, 16#b5#, 16#4a#, 16#0d#, 16#2d#, 16#e5#, 16#7a#, 16#9f#, 16#93#, 16#c9#, 16#9c#, 16#ef#),
(16#a0#, 16#e0#, 16#3b#, 16#4d#, 16#ae#, 16#2a#, 16#f5#, 16#b0#, 16#c8#, 16#eb#, 16#bb#, 16#3c#, 16#83#, 16#53#, 16#99#, 16#61#),
(16#17#, 16#2b#, 16#04#, 16#7e#, 16#ba#, 16#77#, 16#d6#, 16#26#, 16#e1#, 16#69#, 16#14#, 16#63#, 16#55#, 16#21#, 16#0c#, 16#7d#)
);	

variable x, y : integer := 0;	
variable output :  std_logic_vector(0 to 127);
begin 	  
	for i in 0 to 15 loop 
		x := to_integer(unsigned(std_logic_vector(byte(i*4     to (i*4)+3))));
		y := to_integer(unsigned(std_logic_vector(byte((i*4)+4 to (i*4)+3))));
		if invert = '0' then
			output(i*4 to (i*4)+7) := std_logic_vector(to_unsigned(encrypt_substitution(x, y), 8));
		else
			output(i*4 to (i*4)+7) := std_logic_vector(to_unsigned(decrypt_substitution(x, y), 8)); 
		end if;
	end loop;
	--debug	
--		report "test";
--		test :=  Sbox(to_integer(unsigned(byte(0 to 3))), to_integer(unsigned(byte(4 to 7))) );
--		report "test" & to_string(test);	   		  
return output;
end function sbox;
  
--------------------------------------------------------------------------------------------------------------------------------------	
function shiftRows( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector is
variable b0, b1, b2, b3, temp : std_logic_vector(0 to 7);
variable output : std_logic_vector(0 to 127);
begin			 
		--One loop for each row
		for i in 0 to 3 loop
			--Equate each column bytes based on row
			b0 := data(32*i      to 32*i + 7);
			b1 := data(32*i + 8  to 32*i + 15);
			b2 := data(32*i + 16 to 32*i + 23);
			b3 := data(32*i + 24 to 32*i + 31);
			--note: rotate 1 column left = rotate 3 columns right. Therefore below conditions can 
			--act as forward and reverse operations depending on i and inverse
			if ((i = 1 AND invert = '0') OR (i = 3 AND invert = '1')) then
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
			elsif((i = 3 AND invert = '0') OR (i = 1 AND invert = '1')) then
				temp := b0;
				b0 := b3;
				b3 := b2;
				b2 := b1;
				b1 := temp;
			end if;
			--assign rotated bits to the corresponding indices on the 128 bit array
			output(32*i      to 32*i + 7)  := b0;
			output(32*i + 8  to 32*i + 15) := b1;
			output(32*i + 16 to 32*i + 23) := b2;
			output(32*i + 24 to 32*i + 31) := b3;
			return output;
		end loop;
end function shiftRows;
--------------------------------------------------------------------------------------------------------------------------------------
function mixCol( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector is
variable b0, b1, b2, b3, temp : std_logic_vector(0 to 7);
variable output : std_logic_vector(0 to 127);
begin			 
		--One loop for each row
		for i in 0 to 3 loop
			--Equate each column bytes based on row
			b0 := data(32*i      to 32*i + 7);
			b1 := data(32*i + 8  to 32*i + 15);
			b2 := data(32*i + 16 to 32*i + 23);
			b3 := data(32*i + 24 to 32*i + 31);
			--note: rotate 1 column left = rotate 3 columns right. Therefore below conditions can 
			--act as forward and reverse operations depending on i and inverse
			if invert = '0' then
				temp := b0;
				b0 := b3;
				b3 := b1;
				b1 := b2;
				b2 := temp;
			else	
				temp := b0;
				b0 := b2;
				b2 := b3;
				b3 := b0;
				b1 := temp;
			end if;
			--assign rotated bits to the corresponding indices on the 128 bit array
			output(32*i      to 32*i + 7)  := b0;
			output(32*i + 8  to 32*i + 15) := b1;
			output(32*i + 16 to 32*i + 23) := b2;
			output(32*i + 24 to 32*i + 31) := b3;
			end loop;
		return output;
end function mixCol;
--------------------------------------------------------------------------------------------------------------------------------------
function addRoundKey( data : std_logic_vector(0 to 127); key : std_logic_vector(0 to 127)) return std_logic_vector is
variable output : std_logic_vector(0 to 127);
begin			 
	output := data XOR key;
	return output;
end function addRoundKey;
--------------------------------------------------------------------------------------------------------------------------------------
end package body;