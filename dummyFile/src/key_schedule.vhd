library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	  


entity key_schedule is
	port (
		clk : in std_logic;
		reset : in std_logic; --assuming we need a reset
		key : in std_logic_vector(127 downto 0);	--full key
		round_const : in std_logic_vector(7 downto 0);	--single round byte (unimplemented so far)
		round_key : out std_logic_vector(127 downto 0) --output. Initially the input key, then round keys
	);
end key_schedule;
  

architecture behavioral of key_schedule is			
	--these signals should all be intermediate signals. I think we should load the key from the controller.
	signal subkey : std_logic_vector(127 downto 0);
	signal reg_in : std_logic_vector(127 downto 0);
	signal reg_out : std_logic_vector(127 downto 0);
begin
reg_in <= key when reset = '0' else subkey;	  
	--store full key in generic register map
	reg_inst : entity work.dffreg
		generic map(
			size => 128)
		port map(
			clk => clk,
			d   => reg_in,
			q   => reg_out);	
end architecture behavioral;