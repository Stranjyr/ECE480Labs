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
add wave -noupdate -binary /alu/Aen
add wave -noupdate -hex /alu/ALU_CTL
add wave -noupdate -binary /alu/ALU_CTLen
add wave -noupdate -binary /alu/Cen
add wave -noupdate -binary /alu/ALUin
add wave -noupdate -binary /alu/ALUout
add wave -noupdate -binary /alu/FF_Out_8
force -freeze clk 0 0 ns, 1 10 ns -repeat 20 ns

# Force the named inputs to specific values
run 15 ns ;#15 ns clk on
force Aen 2#1 -deposit
force ALUin 2#10000101 -deposit

run 30 ns ;#45 ns clk off
force Aen 2#0 -deposit
force ALUin 2#10000011
run 20 ns ;#65 ns clk off
force ALU_CTLen 2#1 -deposit
force Cen 2#1 -deposit



force ALU_CTL 10#0 -deposit
run 20 ns ;#85 clk off
force ALU_CTL 10#1 -deposit
run 20 ns ;#105 clk off
force ALU_CTL 10#2 -deposit
run 20 ns ;#125 clk off
force ALU_CTL 10#3 -deposit
run 20 ns ;#145 clk off
force ALU_CTL 10#4 -deposit
run 20 ns ;#165 clk off
force ALU_CTL 10#5 -deposit
run 20 ns ;#185 clk off
force ALU_CTL 10#6 -deposit
run 20 ns ;#205 clk off
force ALU_CTL 10#7 -deposit
run 20 ns ;#225 clk off
force ALU_CTL 10#8 -deposit
run 20 ns ;#245 clk off
force ALU_CTL 10#9 -deposit
run 20 ns ;#265 clk off


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
# Run for an additional 35 ns
run 35 ns
# Restore the waveform zoom level to the the first 350 ns
WaveRestoreZoom {0 ns} {350 ns}
# Update the wave pane
update