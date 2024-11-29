library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package function_package is	 
	--TODO
	type key_store is array (0 to 9) of std_logic_vector(0 to 127);
    impure function sbox( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector;
	impure function sbox_byte( byte : std_logic_vector(0 to 7);  invert : std_logic ) return std_logic_vector;
    impure function shiftRows( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector;
	impure function addRoundKey( data : std_logic_vector(0 to 127); key : std_logic_vector(0 to 127)) return std_logic_vector;
	impure function gfMult_byte( a : in std_logic_vector(0 to 7);  b : in std_logic_vector(0 to 7)) return std_logic_vector;
	impure function mixColumns( data : in std_logic_vector(0 to 127); invert : in std_logic) return std_logic_vector;
	impure function to_INT( data : std_logic_vector(0 to 7)) return integer;
	impure function to_byte( data : integer ) return std_logic_vector;	
	impure function generateRoundKeys(fullKey : std_logic_vector; encrypt : std_logic) return key_store;
end package function_package;	 	

package body function_package is																   
----------------------------------------------------------------------------------------------------------------------------------------
--COMPLETE, TESTED THROUGH ALL RANGES
impure function sbox_byte ( byte : std_logic_vector(0 to 7);  invert : std_logic ) return std_logic_vector is
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
variable output : std_logic_vector(0 to 7);
begin 	   
		x := to_integer(unsigned(std_logic_vector(byte(0 to 3))));
		y := to_integer(unsigned(std_logic_vector(byte(4 to 7))));
		if invert = '0' then 
			output := std_logic_vector(to_unsigned(encrypt_substitution(x, y), 8));
		else
			output := std_logic_vector(to_unsigned(decrypt_substitution(x, y), 8));
		end if;   		  
return output;
end function sbox_byte;
--------------------------------------------------------------------------------------------------------------------------------------
--Substitution by LUT
impure function sbox( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector is
variable byte : std_logic_vector(0 to 7);
variable output :  std_logic_vector(0 to 127);
begin 	  
	for i in 0 to 15 loop 
		byte := data(i*8 to i*8 + 7);	
		byte := sbox_byte(byte, invert);
		output(i*8 to i*8 + 7) := byte;
	end loop;	   		  
return output;
end function sbox;
  
--------------------------------------------------------------------------------------------------------------------------------------	

impure function shiftRows( data : std_logic_vector(0 to 127); invert : std_logic) return std_logic_vector is
variable temp, old1, old2, old3, new0, new1, new2, new3 : std_logic_vector(0 to 7);
variable output : std_logic_vector(0 to 127);
type matrix is array(0 to 3, 0 to 3) of std_logic_vector(0 to 7);
variable blockMatrix : matrix;

begin	   
	if(invert = '0') then
		output(8*15 to 8*16- 1) := data(8*11  to 8*12 -1);
		output(8*14 to 8*15 - 1) := data(8*6 to 8*7 - 1);
		output(8*13 to 8*14 -1) := data(8*1   to  8*2 - 1); 
		output(8*12 to 8*13 - 1) := data(8*12  to  8*13 - 1);
		output(8*11 to 8*12 - 1) := data(8*7   to  8*8 -1);
		output(8*10 to 8*11 - 1) := data(8*2   to  8*3 - 1); 
		output(8*9 to 8*10-1) := data(8*13  to  8*14-1);
		output(8*8 to 8*9-1) := data(8*8   to  8*9-1);
		output(8*7 to 8*8-1) := data(8*3   to  8*4-1);
		output(8*6 to 8*7-1) := data(8*14  to  8*15-1);
		output(8*5 to 8*6-1) := data(8*9  to  8*10-1);
		output(8*4 to 8*5-1) := data(8*4   to  8*5-1);
		output(8*3 to 8*4-1) := data(8*15  to  8*16-1);
		output(8*2 to 8*3-1) := data(8*10  to  8*11-1);
		output(8*1 to 8*2-1) := data(8*5   to  8*6-1);
		output(8*0 to 8*1-1) := data(8*0   to  8*1-1); 
	return output;			 
	else
		output(8*11  to 8*12 -1) := data(8*15 to 8*16- 1);
		output(8*6 to 8*7 - 1) := data(8*14 to 8*15 - 1) ;
		output(8*1   to  8*2 - 1) := data(8*13 to 8*14 -1) ; 
		output(8*12  to  8*13 - 1) := data(8*12 to 8*13 - 1) ;
		output(8*7   to  8*8 -1) := data(8*11 to 8*12 - 1);
		output(8*2   to  8*3 - 1)  := output(8*7   to  8*8 -1) ; 
		output(8*13  to  8*14-1) := data(8*9 to 8*10-1) ;
		output(8*8   to  8*9-1) := data(8*8 to 8*9-1);
		output(8*3   to  8*4-1) := data(8*7 to 8*8-1);
		output(8*14  to  8*15-1) := data(8*6 to 8*7-1);
		output(8*9  to  8*10-1) := data(8*5 to 8*6-1);
		output(8*4   to  8*5-1) := data(8*4 to 8*5-1);
		output(8*15  to  8*16-1) := data(8*3 to 8*4-1);
		output(8*10  to  8*11-1) := data(8*2 to 8*3-1);
		output(8*5   to  8*6-1) := data(8*1 to 8*2-1);
		output(8*0   to  8*1-1) := data(8*0 to 8*1-1); 
		return output;
		end if;
end function shiftRows;	   

--------------------------------------------------------------------------------------------------------------------------------------
impure function addRoundKey( data : std_logic_vector(0 to 127); key : std_logic_vector(0 to 127)) return std_logic_vector is
variable output : std_logic_vector(0 to 127);
begin			 
	return  data XOR key;
end function addRoundKey;
--------------------------------------------------------------------------------------------------------------------------------------
impure function gfMult_byte ( a : in std_logic_vector(0 to 7);  b : in std_logic_vector(0 to 7) ) return std_logic_vector is
variable irreducible : std_logic_vector(0 to 15) := "1000110110000000";	  --shifted
variable bitmask2, sum, temp_b : std_logic_vector(0 to 15) := "1000000000000000";
variable bitmask1, output : std_logic_vector(0 to 7);
variable Aint, Bint : integer;

begin
	bitmask1 := "00000001";		--Isolate each "variable" in polynomial form to allow distributive multiplication						
	sum := "0000000000000000";
	temp_b := "00000000"&b;
	for i in 0 to 7 loop
		if (bitmask1 AND a) /= "00000000" then
			sum :=temp_B xor sum;
		end if;
		while (to_integer(unsigned(sum)) > 255) loop   --Looped subtraction in place of division by irreducible polynomial
			
			for i in 0 to 7 loop
				if (bitmask2 and sum) /= "0000000000000000" then
					sum := sum xor irreducible;
				end if;
				irreducible := irreducible srl 1;
				bitmask2 := bitmask2 srl 1;
			end loop;
			bitmask2 := "1000000000000000";
			irreducible := "1000110110000000";
		end loop;
		bitmask1 := bitmask1 sll 1;
		temp_b := temp_b sll 1;
	end loop;
	output := sum(8 to 15);
	return output;
	
end function gfMult_byte;
--------------------------------------------------------------------------------------------------------------------------------------
impure function mixColumns ( data : in std_logic_vector(0 to 127); invert : in std_logic) return std_logic_vector is
variable s0, s1, s2, s3, d0, d1, d2, d3 : std_logic_vector(0 to 7);
variable output : std_logic_vector(0 to 127);
begin
	if (invert = '0') then
		for i in 0 to 3 loop
		s0 := data(  32*i    to 32*i + 7);
		s1 := data(32*i + 8  to 32*i + 15);
		s2 := data(32*i + 16 to 32*i + 23);
		s3 := data(32*i + 24 to 32*i + 31);
		
		d0 := gfMult_byte("00000010", s0) XOR gfMult_byte("00000011", s1) XOR s2 XOR s3;
		d1 := s0 XOR gfMult_byte("00000010", s1) XOR gfMult_byte("00000011", s2) XOR s3;
		d2 := s0 XOR s1 XOR gfMult_byte("00000010", s2) XOR gfMult_byte("00000011", s3);
		d3 := gfMult_byte("00000011", s0) XOR s1 XOR s2 XOR gfMult_byte("00000010", s3);
		
		output(  32*i    to 32*i + 7)  := d0;
		output(32*i + 8  to 32*i + 15) := d1;
		output(32*i + 16 to 32*i + 23) := d2;
		output(32*i + 24 to 32*i + 31) := d3;
		end loop;
	else
		for i in 0 to 3 loop
		s0 := data(  32*i    to 32*i + 7);
		s1 := data(32*i + 8  to 32*i + 15);
		s2 := data(32*i + 16 to 32*i + 23);
		s3 := data(32*i + 24 to 32*i + 31);
		
		d0 := gfMult_byte("00001110", s0) XOR gfMult_byte("00001011", s1) XOR gfMult_byte("00001101", s2) XOR gfMult_byte("00001001", s3);
		d1 := gfMult_byte("00001001", s0) XOR gfMult_byte("00001110", s1) XOR gfMult_byte("00001011", s2) XOR gfMult_byte("00001101", s3);
		d2 := gfMult_byte("00001101", s0) XOR gfMult_byte("00001001", s1) XOR gfMult_byte("00001110", s2) XOR gfMult_byte("00001011", s3);
		d3 := gfMult_byte("00001011", s0) XOR gfMult_byte("00001101", s1) XOR gfMult_byte("00001001", s2) XOR gfMult_byte("00001110", s3);
		
		output(  32*i    to 32*i + 7)  := d0;
		output(32*i + 8  to 32*i + 15) := d1;
		output(32*i + 16 to 32*i + 23) := d2;
		output(32*i + 24 to 32*i + 31) := d3;
		end loop;
	end if;
	return output;
end function mixColumns;
--------------------------------------------------------------------------------------------------------------------------------------
impure function to_INT( data : std_logic_vector(0 to 7)) return integer is
begin			 
	return to_integer(unsigned(data));
end function to_INT;
--------------------------------------------------------------------------------------------------------------------------------------
impure function to_byte( data : integer ) return std_logic_vector is
begin			 
	return std_logic_vector(to_unsigned(data, 8));
end function to_byte; 
-------------------------------------------------------------------------------------------------------------------------------------- 
 type roundConstants is array (0 to 39) of integer;
	constant rc : roundConstants := (
    (16#01#, 16#00#, 16#00#, 16#00#,
	16#02#,16#00#,16#00#,16#00#,
	16#04#,16#00#,16#00#,16#00#,
	16#08#,16#00#,16#00#,16#00#,
	16#10#,16#00#,16#00#,16#00#,
	16#20#,16#00#,16#00#,16#00#,
	16#40#,16#00#,16#00#,16#00#,
	16#80#,16#00#,16#00#,16#00#,
	16#1b#,16#00#,16#00#,16#00#,
	16#36#,16#00#,16#00#,16#00#
	)
);
impure function rc_LUT ( byte : in std_logic_vector(0 to 7))
    return std_logic_vector is	
	variable count : integer := 0;
	variable newVector : std_logic_vector(0 to 7);	
	variable test : integer := 0;
	begin 

		test :=  rc(to_integer(unsigned(byte(0 to 7))) );
		newVector := std_logic_vector(to_unsigned(test, newVector'length));
    return std_logic_vector(newVector);
  end function; 		  
-------------------------------------------------------------------------------------------------------------------------------------- 

impure function sbox_LUT ( byteIn : in std_logic_vector(0 to 7))
    return std_logic_vector is	
	variable count : integer := 0;
	variable newVector : std_logic_vector(0 to 7);	
	begin 
		newVector := sbox_byte(byteIn(0 to 7), '0' ) ;
    return std_logic_vector(newVector);	   
  end function; 

 type mult_matrix is array (0 to 3, 0 to 3) of integer;
	constant mul : mult_matrix := (
    (2,3,1,1),
	(1,2,3,1),
	(1,1,2,3),
	(3,1,1,2)
	); 


-------------------------------------------------------------------------------------------------------------------------------------- 

impure function generateRoundKeys(fullKey : std_logic_vector; encrypt : std_logic) return key_store is 
variable roundKeys: key_store;  
variable tempWord : std_logic_vector(0 to 31);
variable expansionMatrix : std_logic_vector(0 to 127);
variable rc_return: std_logic_vector(0 to 7);
variable rc_count : integer := 0;
begin
	 tempWord := fullKey(96 to 127);
			expansionMatrix := fullKey;

			
			for i in 0 to 9 loop	
			--Step 1: shift left 	
			tempWord := expansionMatrix(96 to 127);	 
			tempWord(0 to 31) := tempWord rol 8;
			
			--Step 2: Sub bytes for those in sBox 
			for i in 0 to 3 loop
				tempWord(i*8 to (i*8)+7) := sbox_LUT(tempWord(i*8 to (i*8)+7));	
			end loop;
			
			--Step 3: add round constant 
			tempWord(0 to 7) := std_logic_vector(tempWord(0 to 7) XOR rc_LUT(std_logic_vector(to_unsigned((rc_count*4),8)))(0 to 7));
			
			--Step 4: add first column with new key		
				 
			for i in 0 to 3 loop
				tempWord(i*8 to (i*8)+7) := std_logic_vector(unsigned(tempWord(i*8 to (i*8)+7)) XOR unsigned(expansionMatrix(i*8 to (i*8)+7)));
			end loop;
			
			expansionMatrix(0 to 31) := tempWord(0 to 31);
			
			--Step 5: add second column with new key	  
			for i in 0 to 3 loop
				tempWord(i*8 to (i*8)+7) := std_logic_vector(unsigned(tempWord(i*8 to (i*8)+7)) XOR unsigned(expansionMatrix((i+4)*8 to ((i+4)*8)+7)));
			end loop;
			
			
			expansionMatrix(32 to 63) := tempWord(0 to 31); 
			--report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
			
			--Step 6: add third column with new key
			for i in 0 to 3 loop
				tempWord(i*8 to (i*8)+7) := std_logic_vector(unsigned(tempWord(i*8 to (i*8)+7)) XOR unsigned(expansionMatrix((i+8)*8 to ((i+8)*8)+7)));
			end loop;
			
			expansionMatrix(64 to 95) := tempWord(0 to 31);
	
			--report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
			
			--Step 7: add last column with new key
			for i in 0 to 3 loop
				tempWord(i*8 to (i*8)+7) := std_logic_vector(unsigned(tempWord(i*8 to (i*8)+7)) XOR unsigned(expansionMatrix((i+12)*8 to ((i+12)*8)+7)));
			end loop;
			
			expansionMatrix(96 to 127) := tempWord(0 to 31);
	
			--report "round " & to_string(i) & "to expanded: " & to_hstring(expansionMatrix);
			roundKeys(i) := expansionMatrix;
		    rc_count := rc_count + 1;
			end loop;
			return roundKeys;
	end function generateRoundKeys;
end package body;