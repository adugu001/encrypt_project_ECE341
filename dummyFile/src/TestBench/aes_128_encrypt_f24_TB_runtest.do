SetActiveLib -work
comp -include "$dsn\src\function_package.vhd" 
comp -include "$dsn\src\aes_128_encrypt_f24.vhd" 
comp -include "$dsn\src\TestBench\aes_128_encrypt_f24_TB.vhd" 
asim +access +r TESTBENCH_FOR_aes_128_encrypt_f24 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg start
wave -noreg key_load
wave -noreg IV_load
wave -noreg db_load
wave -noreg stream
wave -noreg ECB_mode
wave -noreg CBC_mode
wave -noreg dataIn
wave -noreg dataOut
wave -noreg Done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\aes_128_encrypt_f24_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_aes_128_encrypt_f24 
