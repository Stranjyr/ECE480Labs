# Break the DO file on any error that occurs
onerror {break}
# Create a wave pane
quietly WaveActivateNextPane {} 0
# Force a restart of the simulation and delete any old waveforms in the wave pane
restart -force
delete wave *

add wave -noupdate -binary /compare4/a
add wave -noupdate -binary /compare4/b
add wave -noupdate -binary /compare4/AeqB
add wave -noupdate -binary /compare4/AltB
add wave -noupdate -binary /compare4/AgtB
# Force the named inputs to specific values

force a 0000
force b 0001
run 100 ps
force a 0000
force b 0000
run 100 ps
force a 0001
force b 0000
run 100 ps

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
configure wave -timelineunits ps
# Restore the waveform zoom level to the the first 1000 ns
WaveRestoreZoom {0 ps} {250 ps}
# Update the wave pane
update