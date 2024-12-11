library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shiftRows is
	port( clk : in std_logic; dataIn : in std_logic_vector(0 to 127); encrypt : in std_logic; dataOut : out std_logic_vector(0 to 127));
end entity shiftRows;


architecture dataFlow of shiftRows is
																								   
begin	
	--dont care about clk for dataflow	
	dataOut( 0 to 7 )	<=  dataIn( 0  to 7); --
	dataOut(32 to 39)	<=  dataIn(32  to 39);							
	dataOut(64 to 71)	<=  dataIn(64  to 71);
	dataOut(96 to 103)	<=  dataIn(96  to 103);		
	dataOut(8  to 15)	<=  dataIn(40  to 47) when encrypt = '0' else --
							dataIn(104 to 111);		 		
	dataOut(40 to 47)	<=  dataIn(72  to 79) when encrypt = '0' else
							dataIn( 8  to 15);
	dataOut(72 to 79)	<=  dataIn(104 to 111) when encrypt = '0' else
							dataIn(40  to 47);		
	dataOut(104 to 111)	<=  dataIn(8   to 15) when encrypt = '0' else
							dataIn(72  to 79);
	dataOut(16 to 23)	<=  dataIn(80  to 87);--
	dataOut(48 to 55)	<=  dataIn(112 to 119);							
	dataOut(80 to 87)	<=  dataIn(16  to 23);
	dataOut(112 to 119)	<=  dataIn(48  to 55);
	dataOut(24 to 31)	<=  dataIn(120 to 127) when encrypt = '0' else--
							dataIn(56  to 63);
	dataOut(56 to 63)	<=  dataIn(24  to 31) when encrypt = '0' else
							dataIn(88  to 95);
	dataOut(88 to 95)	<=  dataIn(56  to 63) when encrypt = '0' else
							dataIn(120 to 127);
	dataOut(120 to 127)	<=  dataIn(88  to 95) when encrypt = '0' else
							dataIn(24  to 31); 
end dataFlow;  

architecture structural of shiftRows is
component simple_register_128
	port(
		clk: in std_logic;	
		Clr: in std_logic; 
		Ld: in std_logic; 
		D: in std_logic_vector(0 to 127);
	    Qout: out std_logic_vector(0 to 127)
		);
end component;
signal to_dec_IR, to_enc_IR: std_logic_vector(0 to 127);

begin
encrypt_reg : simple_register_128	 
	port map( 
			  CLK=>clk,
			  Clr => '0',
			  Ld => '1',
			  D => dataIn(0   to 7)&
						dataIn(40  to 47)&
						dataIn(80  to 87)&
						dataIn(120 to 127)&
						dataIn(32  to 39)&
						dataIn(72  to 79)&
						dataIn(112 to 119)&
						dataIn(24  to 31)&
						dataIn(64  to 71)&
						dataIn(104 to 111)&
						dataIn(16  to 23)&
						dataIn(56  to 63)&
						dataIn(96  to 103)&
						dataIn(8   to 15)&
						dataIn(48  to 55)&
						dataIn(88  to 95),
			  Qout => to_enc_IR
			);	 
decrypt_reg :	simple_register_128	 
	port map( 
			  CLK=>clk,
			  Clr => '0',
			  Ld => '1',
			  D => dataIn(0   to 7)&	  --0 7
						dataIn(104 to 111)&	  --8 15
						dataIn(80  to 87)&	  --16 23
						dataIn(56  to 63)&	  --24 31
						dataIn(32  to 39)&	  --32
						dataIn(8   to 15)&	  --40
						dataIn(112 to 119)&	  --48
						dataIn(88  to 95)&	  --56
						dataIn(64  to 71)&	  --64
						dataIn(40  to 47)&	  --72
						dataIn(16  to 23)&	  --80
						dataIn(120 to 127)&	  --88
						dataIn(96  to 103)&	  --96
						dataIn(72  to 79)&	  --104
						dataIn(48  to 55)&	  --112
						dataIn(24  to 31),	  --120
			  Qout => to_dec_IR
			); 


  	dataOut <= to_enc_IR when encrypt = '0' else to_dec_IR;
end architecture structural;