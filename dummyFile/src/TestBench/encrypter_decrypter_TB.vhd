library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity encrypter_decrypter_tb is
end encrypter_decrypter_tb;

architecture TB_ARCHITECTURE of encrypter_decrypter_tb is
	-- Component declaration of the tested unit
	component encrypter_decrypter
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		encrypt : in STD_LOGIC;
		data_in : in STD_LOGIC_VECTOR(0 to 127);
		start : in STD_LOGIC;  
		init_key : in STD_LOGIC_VECTOR(0 to 127);
		data_to_main : out STD_LOGIC_VECTOR(0 to 127) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	signal encrypt : STD_LOGIC;
	signal data_in : STD_LOGIC_VECTOR(0 to 127);
	signal start : STD_LOGIC;	

	signal init_key : STD_LOGIC_VECTOR(0 to 127);
	signal data_to_main : STD_LOGIC_VECTOR(0 to 127);
	-- Observed signals - signals mapped to the output ports of tested entity
	   signal SIMULATIONACTIVE:BOOLEAN:=TRUE;	
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : encrypter_decrypter
		port map (
			clk => clk,
			reset => reset,
			encrypt => encrypt,
			data_in => data_in,
			start => start,
			init_key => init_key,
			data_to_main => data_to_main
		);

	-- Add your stimulus here ...
	   process 
	variable i : integer := 1;
	begin
		while simulationActive loop
			clk <='0'; wait for 150ns;
			clk <='1'; wait for 150ns; 
			report "clk cycle " & to_string(i);
			i := i + 1;
		end loop;
		wait;	
end process;

clockProcess:process  
variable key0 : std_logic_vector(0 to 127):= 	"00101011"&"01111110"&"00010101"&"00010110"&
												"00101000"&"10101110"&"11010010"&"10100110"&
												"10101011"&"11110111"&"00010101"&"10001000"&
												"00001001"&"11001111"&"01001111"&"00111100"; 
variable data0 : std_logic_vector(0 to 127):= "00110010010000111111011010101000100010000101101000110000100011010011000100110001100110001010001011100000001101110000011100110100";
												
variable tempKey : std_logic_vector(0 to 127);
begin	 
	reset <= '1';
	wait until clk'event AND clk = '1';
	reset <= '0'; 
	data_in <= data0;
	encrypt<= '0';
	init_key <= key0;
	start <= '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';	
	wait until clk'event AND clk = '1';	   
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';	
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	wait until clk'event AND clk = '1';
	
--	tempKey := key_out;	
--	report "out: " & to_hstring(tempKey);
--	load_key <= '0';
--	wait until clk'event AND clk = '1';
--	while done = '0' loop
--	init_key <= tempKey;
--	load_key <= '1';
--	wait until clk'event AND clk = '1' AND key_done = '1';
--	tempKey := key_out;	
--	report "out: " & to_hstring(tempKey);
--	load_key <= '0';
--	wait until clk'event AND clk = '1'; 
--	end loop;
	simulationActive <= false;
	wait;	
		
end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_encrypter_decrypter of encrypter_decrypter_tb is
	for TB_ARCHITECTURE
		for UUT : encrypter_decrypter
			use entity work.encrypter_decrypter(dataflow);
		end for;
	end for;
end TESTBENCH_FOR_encrypter_decrypter;

