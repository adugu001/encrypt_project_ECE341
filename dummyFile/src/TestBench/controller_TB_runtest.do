SetActiveLib -work
comp -include "$dsn\src\key_controller.vhd" 
comp -include "$dsn\src\TestBench\controller_TB.vhd" 
asim +access +r TESTBENCH_FOR_controller 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg current_round_constant
wave -noreg start_round
wave -noreg start
wave -noreg init_key
wave -noreg key_return
wave -noreg key_out
wave -noreg key_done
wave -noreg done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\controller_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_controller 
