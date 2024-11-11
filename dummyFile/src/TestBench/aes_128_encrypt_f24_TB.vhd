library dummyFile;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use dummyFile.function_package.all;

	-- Add your library and packages declaration here ...

entity aes_128_encrypt_f24_tb is
end aes_128_encrypt_f24_tb;

architecture TB_ARCHITECTURE of aes_128_encrypt_f24_tb is
	-- Component declaration of the tested unit
	component aes_128_encrypt_f24
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		start : in STD_LOGIC;
		key_load : in STD_LOGIC;
		IV_load : in STD_LOGIC;
		db_load : in STD_LOGIC;
		stream : in STD_LOGIC;
		ECB_mode : in STD_LOGIC;
		CBC_mode : in STD_LOGIC;
		dataIn : in STD_LOGIC_VECTOR(0 to 31);
		dataOut : out STD_LOGIC_VECTOR(0 to 31);
		Done : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	signal start : STD_LOGIC;
	signal key_load : STD_LOGIC;
	signal IV_load : STD_LOGIC;
	signal db_load : STD_LOGIC;
	signal stream : STD_LOGIC;
	signal ECB_mode : STD_LOGIC;
	signal CBC_mode : STD_LOGIC;
	signal dataIn : STD_LOGIC_VECTOR(0 to 31);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal dataOut : STD_LOGIC_VECTOR(0 to 31);
	signal Done : STD_LOGIC;
   	signal SIMULATIONACTIVE:BOOLEAN:=TRUE;		 
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : aes_128_encrypt_f24
		port map (
			clk => clk,
			reset => reset,
			start => start,
			key_load => key_load,
			IV_load => IV_load,
			db_load => db_load,
			stream => stream,
			ECB_mode => ECB_mode,
			CBC_mode => CBC_mode,
			dataIn => dataIn,
			dataOut => dataOut,
			Done => Done
		);
		
		 process
	begin
		while simulationActive loop
			clk <='0'; wait for 1ns;
			clk <='1'; wait for 1ns;
		end loop;
		wait;	
	end process;
		
	-- Add your stimulus here ...
	clockProcess:process
	begin	 	
		wait until clk'event AND clk = '1';
		reset <= '1';
		wait until clk'event AND clk = '1';
		reset <= '0';
		wait until clk'event AND clk = '1';
		start <= '1';  
		wait until clk'event AND clk = '1';
		key_load <= '1';
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(to_unsigned(0, dataIn(0 to  31)'length));
		wait until clk'event AND clk = '1';
		dataIn(0 to 31) <= std_logic_vector(to_unsigned(1, dataIn(0 to  31)'length));
		for i in 0 to 15 loop	  	
			wait until clk'event AND clk = '1';
			report "clk " & to_string(i);
		end loop;
		
		
		simulationactive<= false;
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_aes_128_encrypt_f24 of aes_128_encrypt_f24_tb is
	for TB_ARCHITECTURE
		for UUT : aes_128_encrypt_f24
			use entity work.aes_128_encrypt_f24(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_aes_128_encrypt_f24;

