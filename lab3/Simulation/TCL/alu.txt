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
add wave -noupdate -binary /b2g_convert/A
add wave -noupdate -binary /b2g_convert/B
add wave -noupdate -binary /b2g_convert/C
add wave -noupdate -binary /b2g_convert/D
add wave -noupdate -binary /b2g_convert/Q
add wave -noupdate -binary /b2g_convert/R
add wave -noupdate -binary /b2g_convert/S
add wave -noupdate -binary /b2g_convert/T

# Force the named inputs to specific values
force -freeze D 0 0 ns, 1 10 ns -repeat 20 ns
force -freeze C 0 0 ns, 1 20 ns -repeat 40 ns
force -freeze B 0 0 ns, 1 40 ns -repeat 80 ns
force -freeze A 0 0 ns, 1 80 ns -repeat 160 ns

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
run 200 ns
# Restore the waveform zoom level to the the first 1000 ns
WaveRestoreZoom {0 ns} {1000 ns}
# Update the wave pane
update