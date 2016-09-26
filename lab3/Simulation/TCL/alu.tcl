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
add wave -noupdate -binary /alu/clk
add wave -noupdate -binary /alu/Aen_n
add wave -noupdate -hex /alu/ALU_CTL
add wave -noupdate -binary /alu/ALU_CTLen_n
add wave -noupdate -binary /alu/Cen_n
add wave -noupdate -binary /alu/ALUin
add wave -noupdate -binary /alu/A
add wave -noupdate -binary /alu/B
add wave -noupdate -binary /alu/ALUout
force -freeze clk 0 0 ns, 1 10 ns -repeat 20 ns

# Force the named inputs to specific values
force Aen_n 1
force Cen_n 1
force ALU_CTLen_n 1
force ALUin 0#10
run 20 ns
force Aen_n 0
force ALUin 10000101
run 20 ns

force Aen_n 1
force ALU_CTLen_n 0
force ALUin 00000000
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000001
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000010
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000011
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000100
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000101
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000110
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00000111
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00001000
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns

force Cen_n 1
force ALU_CTLen_n 0
force ALUin 00001001
run 20 ns
force ALU_CTLen_n 1
force Cen_n 0
force ALUin 10000011
run 20 ns



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
