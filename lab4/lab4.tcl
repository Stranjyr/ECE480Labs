# Break the DO file on any error that occurs
onerror {break}
# Create a wave pane
quietly WaveActivateNextPane {} 0
# Force a restart of the simulation and delete any old waveforms in the wave pane
restart -force
delete wave *
# Add all the signals of interest for the simulation.
# All will have a binary radix, except for the signal 'count'.
# See the ModelSim Command Reference Manual for additional options
add wave -noupdate -binary /Mem_toplevel/clk50
add wave -noupdate -hex /Mem_toplevel/sw
add wave -noupdate -hex /Mem_toplevel/key
add wave -noupdate -binary /Mem_toplevel/mem_input
add wave -noupdate -binary /Mem_toplevel/mem_wr_addr
add wave -noupdate -binary /Mem_toplevel/mem_rd_addr
add wave -noupdate -binary /Mem_toplevel/mem_output

add wave -noupdate -hex /Mem_toplevel/upcount_data


force -freeze clk50 0 0 ns, 1 5 ns -repeat 10 ns
force key 16#f
force sw 16#000
force /Mem_toplevel/upcount_data 16#0 -deposit
force /Mem_toplevel/upcount_addr_rd 16#0 -deposit
force /Mem_toplevel/upcount_addr_wr 16#0 -deposit

force key(0) 0
run 20 ns
force key(0) 1
#count =1 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =2 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =3 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =4 
run 10 ns

force sw 16#03f
force sw(6) 1
run 20 ns
force key(1) 0
run 20 ns
force sw(6) 0
force key(1) 1

force key(0) 0
run 20 ns
force key(0) 1 
#count =5 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =6 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =7 
run 10 ns
force key(0) 0
run 20 ns
force key(0) 1 
#count =8 
run 10 ns



# Update all waveforms in the wave pane
TreeUpdate [SetDefaultTree]
# Set the cursor to the beginning of the simulation time
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
# Configure some options controlling how waves look in the simulation
configure wave -namecolwidth 149
configure wave -valuecolwidth 99
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

run 35 ns
# Restore the waveform zoom level to the the first 350 ns
WaveRestoreZoom {0 ns} {350 ns}
# Update the wave pane
update
