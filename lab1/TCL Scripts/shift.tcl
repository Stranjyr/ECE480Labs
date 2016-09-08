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
add wave -noupdate -binary /shift74164/clk
add wave -noupdate -binary /shift74164/clr_n
add wave -noupdate -binary /shift74164/a
add wave -noupdate -binary /shift74164/b
add wave -noupdate -hex /shift74164/q_vector
add wave -noupdate -binary /shift74164/Qa
add wave -noupdate -binary /shift74164/Qb
add wave -noupdate -binary /shift74164/Qc
add wave -noupdate -binary /shift74164/Qd
add wave -noupdate -binary /shift74164/Qe
add wave -noupdate -binary /shift74164/Qf
add wave -noupdate -binary /shift74164/Qg
add wave -noupdate -binary /shift74164/Qh

# Create a 50 MHz clock signal with value '0' at time '0'
# that changes to '1' at 10 ns and repeats every 20 ns
force -freeze clk 0 0 ns, 1 10 ns -repeat 20 ns
# Force the named inputs to specific values
force clr_n 0
run 10 ns
force clr_n 1
force -freeze a 0 0 ns, 1 40 ns -repeat 80 ns
force -freeze b 0 0 ns, 1 60 ns -repeat 120 ns



# This force will be useful in setting counters and
# other signals to specific values at specific times in the simulation

run 200 ns


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
WaveRestoreZoom {0 ns} {500 ns}
# Update the wave pane
update