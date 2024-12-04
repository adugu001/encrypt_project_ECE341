SetActiveLib -work
comp -include "$dsn\src\encrypter_decrypter.vhd" 
comp -include "$dsn\src\TestBench\encrypter_decrypter_TB.vhd" 
asim +access +r TESTBENCH_FOR_encrypter_decrypter 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg invert
wave -noreg data_in
wave -noreg start
wave -noreg init_key
wave -noreg key_return
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\encrypter_decrypter_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_encrypter_decrypter 
