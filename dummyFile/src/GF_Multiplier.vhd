library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	  


entity GF_Multiplier is
	port (
		clk : in std_logic;
		a : in std_logic_vector(0 to 7);  
		b : in std_logic_vector(0 to 7);
		product : out std_logic_vector(0 to 7)
	);
end GF_Multiplier;

architecture dataFlow of GF_Multiplier is 
type byte_ARR is array (0 to 7) of std_logic_vector(0 to 15);
type byte_ARR_2D is array (0 to 7) of byte_ARR;
constant irreducible: byte_ARR :=("1000110110000000",
								  "0100011011000000",
								  "0010001101100000",
								  "0001000110110000",
								  "0000100011011000",
								  "0000010001101100",
								  "0000001000110110",
								  "0000000100011011");
signal reduced : byte_ARR_2D;																		
signal tempA  : std_logic_vector(0 to 15);
signal tempB, sum  : std_logic_vector(0 to 15);
signal d, before_reduction : byte_ARR := (others => "0000000000000000");

begin
	tempA <= "00000000" & a;
	tempB <= "00000000" & b;		
		 
	
	d(0) <= tempB sll 0 when tempA(0) = '1' else (others => '0');
	before_reduction(0) <= X"0000" xor d(0);
	reduced(0)(0) <= before_reduction(0) XOR irreducible(0) when before_reduction(0)(0) = '1' else before_reduction(0);
	reduced(0)(1) <= reduced(0)(0) XOR irreducible(1) when reduced(0)(0)(1) = '1' else reduced(0)(0);
	reduced(0)(2) <= reduced(0)(1) XOR irreducible(2) when reduced(0)(1)(2) = '1' else reduced(0)(1); 
	reduced(0)(3) <= reduced(0)(2) XOR irreducible(3) when reduced(0)(2)(3) = '1' else reduced(0)(2);
	reduced(0)(4) <= reduced(0)(3) XOR irreducible(4) when reduced(0)(3)(4) = '1' else reduced(0)(3);
	reduced(0)(5) <= reduced(0)(4) XOR irreducible(5) when reduced(0)(4)(5) = '1' else reduced(0)(4);
	reduced(0)(6) <= reduced(0)(5) XOR irreducible(6) when reduced(0)(5)(6) = '1' else reduced(0)(5);
	reduced(0)(7) <= reduced(0)(6) XOR irreducible(7) when reduced(0)(6)(7) = '1' else reduced(0)(6);
	
	d(1) <= tempB sll 1 when tempA(1) = '1' else (others => '0');
	before_reduction(1) <= reduced(0)(7) xor tempB; -- d(1);
	reduced(1)(0) <= before_reduction(1) XOR irreducible(0) when before_reduction(1)(0) = '1' else before_reduction(1);
	reduced(1)(1) <= reduced(1)(0) XOR irreducible(1) when reduced(1)(0)(1) = '1' else reduced(1)(0);
	reduced(1)(2) <= reduced(1)(1) XOR irreducible(2) when reduced(1)(1)(2) = '1' else reduced(1)(1); 
	reduced(1)(3) <= reduced(1)(2) XOR irreducible(3) when reduced(1)(2)(3) = '1' else reduced(1)(2);
	reduced(1)(4) <= reduced(1)(3) XOR irreducible(4) when reduced(1)(3)(4) = '1' else reduced(1)(3);
	reduced(1)(5) <= reduced(1)(4) XOR irreducible(5) when reduced(1)(4)(5) = '1' else reduced(1)(4);
	reduced(1)(6) <= reduced(1)(5) XOR irreducible(6) when reduced(1)(5)(6) = '1' else reduced(1)(5);
	reduced(1)(7) <= reduced(1)(6) XOR irreducible(7) when reduced(1)(6)(7) = '1' else reduced(1)(6); 
	
	d(2) <= tempB sll 2 when tempA(2) = '1' else (others => '0');
	before_reduction(2) <= reduced(1)(7) xor d(2);
	reduced(2)(0) <= before_reduction(2) XOR irreducible(0) when before_reduction(2)(0) = '1' else before_reduction(2);
	reduced(2)(1) <= reduced(2)(0) XOR irreducible(1) when reduced(2)(0)(1) = '1' else reduced(2)(0);
	reduced(2)(2) <= reduced(2)(1) XOR irreducible(2) when reduced(2)(1)(2) = '1' else reduced(2)(1); 
	reduced(2)(3) <= reduced(2)(2) XOR irreducible(3) when reduced(2)(2)(3) = '1' else reduced(2)(2);
	reduced(2)(4) <= reduced(2)(3) XOR irreducible(4) when reduced(2)(3)(4) = '1' else reduced(2)(3);
	reduced(2)(5) <= reduced(2)(4) XOR irreducible(5) when reduced(2)(4)(5) = '1' else reduced(2)(4);
	reduced(2)(6) <= reduced(2)(5) XOR irreducible(6) when reduced(2)(5)(6) = '1' else reduced(2)(5);
	reduced(2)(7) <= reduced(2)(6) XOR irreducible(7) when reduced(2)(6)(7) = '1' else reduced(2)(6); 
	
	d(3) <= tempB sll 3 when tempA(3) = '1' else (others => '0');
	before_reduction(3) <= reduced(2)(7) xor d(3);
	reduced(3)(0) <= before_reduction(3) XOR irreducible(0) when before_reduction(3)(0) = '1' else before_reduction(3);
	reduced(3)(1) <= reduced(3)(0) XOR irreducible(1) when reduced(3)(0)(1) = '1' else reduced(3)(0);
	reduced(3)(2) <= reduced(3)(1) XOR irreducible(2) when reduced(3)(1)(2) = '1' else reduced(3)(1); 
	reduced(3)(3) <= reduced(3)(2) XOR irreducible(3) when reduced(3)(2)(3) = '1' else reduced(3)(2);
	reduced(3)(4) <= reduced(3)(3) XOR irreducible(4) when reduced(3)(3)(4) = '1' else reduced(3)(3);
	reduced(3)(5) <= reduced(3)(4) XOR irreducible(5) when reduced(3)(4)(5) = '1' else reduced(3)(4);
	reduced(3)(6) <= reduced(3)(5) XOR irreducible(6) when reduced(3)(5)(6) = '1' else reduced(3)(5);
	reduced(3)(7) <= reduced(3)(6) XOR irreducible(7) when reduced(3)(6)(7) = '1' else reduced(3)(6);
	
	d(4) <= tempB sll 4 when tempA(4) = '1' else (others => '0');
	before_reduction(4) <= reduced(3)(7) xor d(4);
	reduced(4)(0) <= before_reduction(4) XOR irreducible(0) when before_reduction(4)(0) = '1' else before_reduction(4);
	reduced(4)(1) <= reduced(4)(0) XOR irreducible(1) when reduced(4)(0)(1) = '1' else reduced(4)(0);
	reduced(4)(2) <= reduced(4)(1) XOR irreducible(2) when reduced(4)(1)(2) = '1' else reduced(4)(1); 
	reduced(4)(3) <= reduced(4)(2) XOR irreducible(3) when reduced(4)(2)(3) = '1' else reduced(4)(2);
	reduced(4)(4) <= reduced(4)(3) XOR irreducible(4) when reduced(4)(3)(4) = '1' else reduced(4)(3);
	reduced(4)(5) <= reduced(4)(4) XOR irreducible(5) when reduced(4)(4)(5) = '1' else reduced(4)(4);
	reduced(4)(6) <= reduced(4)(5) XOR irreducible(6) when reduced(4)(5)(6) = '1' else reduced(4)(5);
	reduced(4)(7) <= reduced(4)(6) XOR irreducible(7) when reduced(4)(6)(7) = '1' else reduced(4)(6); 
	
	d(5) <= tempB sll 5 when tempA(5) = '1' else (others => '0');
	before_reduction(5) <= reduced(4)(7) xor d(5);
	reduced(5)(0) <= before_reduction(5) XOR irreducible(0) when before_reduction(5)(0) = '1' else before_reduction(5);
	reduced(5)(1) <= reduced(5)(0) XOR irreducible(1) when reduced(5)(0)(1) = '1' else reduced(5)(0);
	reduced(5)(2) <= reduced(5)(1) XOR irreducible(2) when reduced(5)(1)(2) = '1' else reduced(5)(1); 
	reduced(5)(3) <= reduced(5)(2) XOR irreducible(3) when reduced(5)(2)(3) = '1' else reduced(5)(2);
	reduced(5)(4) <= reduced(5)(3) XOR irreducible(4) when reduced(5)(3)(4) = '1' else reduced(5)(3);
	reduced(5)(5) <= reduced(5)(4) XOR irreducible(5) when reduced(5)(4)(5) = '1' else reduced(5)(4);
	reduced(5)(6) <= reduced(5)(5) XOR irreducible(6) when reduced(5)(5)(6) = '1' else reduced(5)(5);
	reduced(5)(7) <= reduced(5)(6) XOR irreducible(7) when reduced(5)(6)(7) = '1' else reduced(5)(6);
	
	d(6) <= tempB sll 6 when tempA(6) = '1' else (others => '0');
	before_reduction(6) <= reduced(5)(7) xor d(6);
	reduced(6)(0) <= before_reduction(6) XOR irreducible(0) when before_reduction(6)(0) = '1' else before_reduction(6);
	reduced(6)(1) <= reduced(6)(0) XOR irreducible(1) when reduced(6)(0)(1) = '1' else reduced(6)(0);
	reduced(6)(2) <= reduced(6)(1) XOR irreducible(2) when reduced(6)(1)(2) = '1' else reduced(6)(1); 
	reduced(6)(3) <= reduced(6)(2) XOR irreducible(3) when reduced(6)(2)(3) = '1' else reduced(6)(2);
	reduced(6)(4) <= reduced(6)(3) XOR irreducible(4) when reduced(6)(3)(4) = '1' else reduced(6)(3);
	reduced(6)(5) <= reduced(6)(4) XOR irreducible(5) when reduced(6)(4)(5) = '1' else reduced(6)(4);
	reduced(6)(6) <= reduced(6)(5) XOR irreducible(6) when reduced(6)(5)(6) = '1' else reduced(6)(5);
	reduced(6)(7) <= reduced(6)(6) XOR irreducible(7) when reduced(6)(6)(7) = '1' else reduced(6)(6); 
	
	d(7) <= tempB sll 7 when tempA(7) = '1' else (others => '0'); 
	before_reduction(7) <= reduced(6)(7) xor d(7);
	reduced(7)(0) <= before_reduction(7) XOR irreducible(0) when before_reduction(7)(0) = '1' else before_reduction(7);
	reduced(7)(1) <= reduced(7)(0) XOR irreducible(1) when reduced(7)(0)(1) = '1' else reduced(7)(0);
	reduced(7)(2) <= reduced(7)(1) XOR irreducible(2) when reduced(7)(1)(2) = '1' else reduced(7)(1); 
	reduced(7)(3) <= reduced(7)(2) XOR irreducible(3) when reduced(7)(2)(3) = '1' else reduced(7)(2);
	reduced(7)(4) <= reduced(7)(3) XOR irreducible(4) when reduced(7)(3)(4) = '1' else reduced(7)(3);
	reduced(7)(5) <= reduced(7)(4) XOR irreducible(5) when reduced(7)(4)(5) = '1' else reduced(7)(4);
	reduced(7)(6) <= reduced(7)(5) XOR irreducible(6) when reduced(7)(5)(6) = '1' else reduced(7)(5);
	reduced(7)(7) <= reduced(7)(6) XOR irreducible(7) when reduced(7)(6)(7) = '1' else reduced(7)(6);
	sum <= reduced(7)(7);
	
	product <= sum(8 to 15);
end architecture;		  