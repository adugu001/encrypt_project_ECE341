library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	  


entity GF_Multiplier is
	port (
		a : in std_logic_vector(0 to 7);  
		b : in std_logic_vector(0 to 7);
		product : out std_logic_vector(0 to 7)
	);
end GF_Multiplier;

architecture dataFlow of GF_Multiplier is 
type byte_ARR is array (0 to 7) of std_logic_vector(0 to 15);
type byte_ARR_2D is array (0 to 7) of byte_ARR;
constant irreducible: byte_ARR :=("0000000100011011",
								  "0000001000110110",
								  "0000010001101100",
								  "0000100011011000",
								  "0001000110110000",
								  "0010001101100000",
								  "0100011011000000",
								  "1000110110000000");
signal reduced : byte_ARR_2D;																		
signal tempA  : std_logic_vector(0 to 15);
signal tempB, sum  : std_logic_vector(0 to 15);
signal d, before_reduction : byte_ARR := (others => "0000000000000000");

begin					--index 012345678...15
	tempA <= "00000000" & a;
	tempB <= "00000000" & b;		
		 
	
	d(0) <= tempB sll 0 when tempA(15) = '1' else (others => '0') after 1ps;
	before_reduction(0) <= X"0000" xor d(0) after 2ps;
	reduced(0)(0) <= before_reduction(0) XOR irreducible(7) when before_reduction(0)(0) = '1' else before_reduction(0) after 3ps;
	reduced(0)(1) <= reduced(0)(0) XOR irreducible(6) when reduced(0)(0)(1) = '1' else reduced(0)(0) after 4ps;
	reduced(0)(2) <= reduced(0)(1) XOR irreducible(5) when reduced(0)(1)(2) = '1' else reduced(0)(1) after 5ps; 
	reduced(0)(3) <= reduced(0)(2) XOR irreducible(4) when reduced(0)(2)(3) = '1' else reduced(0)(2) after 6ps;
	reduced(0)(4) <= reduced(0)(3) XOR irreducible(3) when reduced(0)(3)(4) = '1' else reduced(0)(3) after 7ps;
	reduced(0)(5) <= reduced(0)(4) XOR irreducible(2) when reduced(0)(4)(5) = '1' else reduced(0)(4) after 8ps;
	reduced(0)(6) <= reduced(0)(5) XOR irreducible(1) when reduced(0)(5)(6) = '1' else reduced(0)(5) after 9ps;
	reduced(0)(7) <= reduced(0)(6) XOR irreducible(0) when reduced(0)(6)(7) = '1' else reduced(0)(6) after 10ps;
	
	d(1) <= tempB sll 1 when tempA(14) = '1' else (others => '0') after 11ps;
	before_reduction(1) <= reduced(0)(7) xor d(1)  after 12ps;
	reduced(1)(0) <= before_reduction(1) XOR irreducible(7) when before_reduction(1)(0) = '1' else before_reduction(1) after 13ps;
	reduced(1)(1) <= reduced(1)(0) XOR irreducible(6) when reduced(1)(0)(1) = '1' else reduced(1)(0) after 14ps;
	reduced(1)(2) <= reduced(1)(1) XOR irreducible(5) when reduced(1)(1)(2) = '1' else reduced(1)(1) after 15ps; 
	reduced(1)(3) <= reduced(1)(2) XOR irreducible(4) when reduced(1)(2)(3) = '1' else reduced(1)(2) after 16ps;
	reduced(1)(4) <= reduced(1)(3) XOR irreducible(3) when reduced(1)(3)(4) = '1' else reduced(1)(3) after 17ps;
	reduced(1)(5) <= reduced(1)(4) XOR irreducible(2) when reduced(1)(4)(5) = '1' else reduced(1)(4) after 18ps;
	reduced(1)(6) <= reduced(1)(5) XOR irreducible(1) when reduced(1)(5)(6) = '1' else reduced(1)(5) after 19ps;
	reduced(1)(7) <= reduced(1)(6) XOR irreducible(0) when reduced(1)(6)(7) = '1' else reduced(1)(6) after 20ps; 
	
	d(2) <= tempB sll 2 when tempA(13) = '1' else (others => '0') after 21ps;
	before_reduction(2) <= reduced(1)(7) xor d(2) after 22ps;
	reduced(2)(0) <= before_reduction(2) XOR irreducible(7) when before_reduction(2)(0) = '1' else before_reduction(2) after 23ps;
	reduced(2)(1) <= reduced(2)(0) XOR irreducible(6) when reduced(2)(0)(1) = '1' else reduced(2)(0) after 24ps;
	reduced(2)(2) <= reduced(2)(1) XOR irreducible(5) when reduced(2)(1)(2) = '1' else reduced(2)(1) after 25ps; 
	reduced(2)(3) <= reduced(2)(2) XOR irreducible(4) when reduced(2)(2)(3) = '1' else reduced(2)(2) after 26ps;
	reduced(2)(4) <= reduced(2)(3) XOR irreducible(3) when reduced(2)(3)(4) = '1' else reduced(2)(3) after 27ps;
	reduced(2)(5) <= reduced(2)(4) XOR irreducible(2) when reduced(2)(4)(5) = '1' else reduced(2)(4) after 28ps;
	reduced(2)(6) <= reduced(2)(5) XOR irreducible(1) when reduced(2)(5)(6) = '1' else reduced(2)(5) after 29ps;
	reduced(2)(7) <= reduced(2)(6) XOR irreducible(0) when reduced(2)(6)(7) = '1' else reduced(2)(6) after 30ps; 
	
	d(3) <= tempB sll 3 when tempA(12) = '1' else (others => '0') after 31ps;
	before_reduction(3) <= reduced(2)(7) xor d(3) after 32ps;
	reduced(3)(0) <= before_reduction(3) XOR irreducible(7) when before_reduction(3)(0) = '1' else before_reduction(3) after 33ps;
	reduced(3)(1) <= reduced(3)(0) XOR irreducible(6) when reduced(3)(0)(1) = '1' else reduced(3)(0) after 34ps;
	reduced(3)(2) <= reduced(3)(1) XOR irreducible(5) when reduced(3)(1)(2) = '1' else reduced(3)(1) after 35ps; 
	reduced(3)(3) <= reduced(3)(2) XOR irreducible(4) when reduced(3)(2)(3) = '1' else reduced(3)(2) after 36ps;
	reduced(3)(4) <= reduced(3)(3) XOR irreducible(3) when reduced(3)(3)(4) = '1' else reduced(3)(3) after 37ps;
	reduced(3)(5) <= reduced(3)(4) XOR irreducible(2) when reduced(3)(4)(5) = '1' else reduced(3)(4) after 38ps;
	reduced(3)(6) <= reduced(3)(5) XOR irreducible(1) when reduced(3)(5)(6) = '1' else reduced(3)(5) after 39ps;
	reduced(3)(7) <= reduced(3)(6) XOR irreducible(0) when reduced(3)(6)(7) = '1' else reduced(3)(6) after 40ps;
	
	d(4) <= tempB sll 4 when tempA(11) = '1' else (others => '0') after 41ps;
	before_reduction(4) <= reduced(3)(7) xor d(4) after 42ps;
	reduced(4)(0) <= before_reduction(4) XOR irreducible(7) when before_reduction(4)(0) = '1' else before_reduction(4) after 43ps;
	reduced(4)(1) <= reduced(4)(0) XOR irreducible(6) when reduced(4)(0)(1) = '1' else reduced(4)(0) after 44ps;
	reduced(4)(2) <= reduced(4)(1) XOR irreducible(5) when reduced(4)(1)(2) = '1' else reduced(4)(1) after 45ps; 
	reduced(4)(3) <= reduced(4)(2) XOR irreducible(4) when reduced(4)(2)(3) = '1' else reduced(4)(2) after 46ps;
	reduced(4)(4) <= reduced(4)(3) XOR irreducible(3) when reduced(4)(3)(4) = '1' else reduced(4)(3) after 47ps;
	reduced(4)(5) <= reduced(4)(4) XOR irreducible(2) when reduced(4)(4)(5) = '1' else reduced(4)(4) after 48ps;
	reduced(4)(6) <= reduced(4)(5) XOR irreducible(1) when reduced(4)(5)(6) = '1' else reduced(4)(5) after 49ps;
	reduced(4)(7) <= reduced(4)(6) XOR irreducible(0) when reduced(4)(6)(7) = '1' else reduced(4)(6) after 50ps;--* 
	
	d(5) <= tempB sll 5 when tempA(10) = '1' else (others => '0') after 51ps;
	before_reduction(5) <= reduced(4)(7) xor d(5) after 52ps;
	reduced(5)(0) <= before_reduction(5) XOR irreducible(7) when before_reduction(5)(0) = '1' else before_reduction(5) after 53ps;
	reduced(5)(1) <= reduced(5)(0) XOR irreducible(6) when reduced(5)(0)(1) = '1' else reduced(5)(0)  after 54ps;
	reduced(5)(2) <= reduced(5)(1) XOR irreducible(5) when reduced(5)(1)(2) = '1' else reduced(5)(1) after 55ps; 
	reduced(5)(3) <= reduced(5)(2) XOR irreducible(4) when reduced(5)(2)(3) = '1' else reduced(5)(2) after 56ps;
	reduced(5)(4) <= reduced(5)(3) XOR irreducible(3) when reduced(5)(3)(4) = '1' else reduced(5)(3) after 57ps;
	reduced(5)(5) <= reduced(5)(4) XOR irreducible(2) when reduced(5)(4)(5) = '1' else reduced(5)(4) after 58ps;
	reduced(5)(6) <= reduced(5)(5) XOR irreducible(1) when reduced(5)(5)(6) = '1' else reduced(5)(5) after 59ps;
	reduced(5)(7) <= reduced(5)(6) XOR irreducible(0) when reduced(5)(6)(7) = '1' else reduced(5)(6) after 60ps;
	
	d(6) <= tempB sll 6 when tempA(9) = '1' else (others => '0') after 61ps;
	before_reduction(6) <= reduced(5)(7) xor d(6) after 62ps;
	reduced(6)(0) <= before_reduction(6) XOR irreducible(7) when before_reduction(6)(0) = '1' else before_reduction(6) after 63ps;
	reduced(6)(1) <= reduced(6)(0) XOR irreducible(6) when reduced(6)(0)(1) = '1' else reduced(6)(0) after 64ps;
	reduced(6)(2) <= reduced(6)(1) XOR irreducible(5) when reduced(6)(1)(2) = '1' else reduced(6)(1) after 65ps; 
	reduced(6)(3) <= reduced(6)(2) XOR irreducible(4) when reduced(6)(2)(3) = '1' else reduced(6)(2) after 66ps;
	reduced(6)(4) <= reduced(6)(3) XOR irreducible(3) when reduced(6)(3)(4) = '1' else reduced(6)(3) after 67ps;
	reduced(6)(5) <= reduced(6)(4) XOR irreducible(2) when reduced(6)(4)(5) = '1' else reduced(6)(4) after 68ps;
	reduced(6)(6) <= reduced(6)(5) XOR irreducible(1) when reduced(6)(5)(6) = '1' else reduced(6)(5) after 69ps;
	reduced(6)(7) <= reduced(6)(6) XOR irreducible(0) when reduced(6)(6)(7) = '1' else reduced(6)(6) after 70ps; 
	
	d(7) <= tempB sll 7 when tempA(8) = '1' else (others => '0') after 71ps; 
	before_reduction(7) <= reduced(6)(7) xor d(7) after 72ps;
	reduced(7)(0) <= before_reduction(7) XOR irreducible(7) when before_reduction(7)(0) = '1' else before_reduction(7) after 73ps;
	reduced(7)(1) <= reduced(7)(0) XOR irreducible(6) when reduced(7)(0)(1) = '1' else reduced(7)(0) after 74ps;
	reduced(7)(2) <= reduced(7)(1) XOR irreducible(5) when reduced(7)(1)(2) = '1' else reduced(7)(1) after 75ps; 
	reduced(7)(3) <= reduced(7)(2) XOR irreducible(4) when reduced(7)(2)(3) = '1' else reduced(7)(2) after 76ps;
	reduced(7)(4) <= reduced(7)(3) XOR irreducible(3) when reduced(7)(3)(4) = '1' else reduced(7)(3) after 77ps;
	reduced(7)(5) <= reduced(7)(4) XOR irreducible(2) when reduced(7)(4)(5) = '1' else reduced(7)(4) after 78ps;
	reduced(7)(6) <= reduced(7)(5) XOR irreducible(1) when reduced(7)(5)(6) = '1' else reduced(7)(5) after 79ps;
	reduced(7)(7) <= reduced(7)(6) XOR irreducible(0) when reduced(7)(6)(7) = '1' else reduced(7)(6) after 80ps;
	sum <= reduced(7)(7) after 81ps;
	
	product <= sum(8 to 15) after 82ps;
end architecture;		  