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
add wave -noupdate -binary /vending/clock
add wave -noupdate -binary /vending/n
add wave -noupdate -binary /vending/d
add wave -noupdate -binary /vending/q
add wave -noupdate -binary /vending/p
#7 segment values
add wave -noupdate -hex /vending/total 
add wave -noupdate -decimal /vending/total_in
add wave -noupdate -binary /vending/state
force -freeze clock 0 0 ns, 1 10 ns -repeat 20 ns

# Force the named inputs to default values
force n 1
force d 1
force q 1
run 20 ns
#run n count from 0 to 50
force n 0
run 200 ns
#run d count
force n 1
force d 0
run 100 ns
#run q count
force d 1
force q 0
run 40 ns
#run mixed count
force d 0
force q 1
run 20 ns
force d 1
force n 0
run 20 ns
force q 0
force n 1
run 20 ns
force d 0
force q 1
run 40 ns
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
# Restore the waveform zoom level to the the first 350 ns
WaveRestoreZoom {0 ns} {350 ns}
# Update the wave pane
update