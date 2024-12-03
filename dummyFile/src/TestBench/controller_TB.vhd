library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity controller_tb is
end controller_tb;

architecture TB_ARCHITECTURE of controller_tb is
	-- Component declaration of the tested unit
	component controller
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		load_key : in std_logic;
		start : out STD_LOGIC;
		init_key : in STD_LOGIC_VECTOR(0 to 127);
		key_out : out STD_LOGIC_VECTOR(0 to 127);
		key_done : out STD_LOGIC;
		done : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;					 
	signal load_key : STD_LOGIC;					 
	
	signal init_key : STD_LOGIC_VECTOR(0 to 127);
	signal key_done : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal current_round_constant : STD_LOGIC_VECTOR(0 to 7);
	signal start_round : STD_LOGIC;
	signal start : STD_LOGIC;
	signal key_out : STD_LOGIC_VECTOR(0 to 127);
	signal done : STD_LOGIC;
      	signal SIMULATIONACTIVE:BOOLEAN:=TRUE;		
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : controller
		port map (
			clk => clk,
			reset => reset,
			load_key => load_key,
			start => start,
			init_key => init_key,
			key_out => key_out,
			key_done => key_done,
			done => done
		);

	-- Add your stimulus here ...
	process 
	variable i : integer := 1;
	begin
		while simulationActive loop
			clk <='0'; wait for 50ns;
			clk <='1'; wait for 50ns; 
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
variable tempKey : std_logic_vector(0 to 127);
begin	 
	
	init_key <= key0;
	load_key <= '1';
	start <= '1';
	wait until clk'event AND clk = '1' AND key_done = '1';
	tempKey := key_out;	
	report "out: " & to_hstring(tempKey);
	load_key <= '0';
	wait until clk'event AND clk = '1';
	while done = '0' loop
	init_key <= tempKey;
	load_key <= '1';
	wait until clk'event AND clk = '1' AND key_done = '1';
	tempKey := key_out;	
	report "out: " & to_hstring(tempKey);
	load_key <= '0';
	wait until clk'event AND clk = '1'; 
	end loop;
		
		
end process;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_controller of controller_tb is
	for TB_ARCHITECTURE
		for UUT : controller
			use entity work.controller(dataflow);
		end for;
	end for;
end TESTBENCH_FOR_controller;

