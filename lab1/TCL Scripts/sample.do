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
add wave -noupdate -binary /updown4/clock
add wave -noupdate -binary /updown4/dir
add wave -noupdate -binary /updown4/q
add wave -noupdate -hex /updown4/count
# Create a 50 MHz clock signal with value '0' at time '0'
# that changes to '1' at 10 ns and repeats every 20 ns
force -freeze clock 0 0 ns, 1 10 ns -repeat 20 ns
# Force the named inputs to specific values
force -freeze dir 0 0 ns, 1 1600 ns
force count 10#0 -deposit


# This force will be useful in setting counters and
# other signals to specific values at specific times in the simulation

run 1600 ns

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
# Run for an additional 900 ns
run 1600 ns
# Restore the waveform zoom level to the the first 1000 ns
WaveRestoreZoom {0 ns} {3200 ns}
# Update the wave pane
update