onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sc_lifo_tb/DUT/clk
add wave -noupdate /sc_lifo_tb/DUT/reset_n
add wave -noupdate -expand -group input /sc_lifo_tb/DUT/clear
add wave -noupdate -expand -group input /sc_lifo_tb/DUT/wr
add wave -noupdate -expand -group input /sc_lifo_tb/DUT/data_in
add wave -noupdate -expand -group output /sc_lifo_tb/DUT/rd
add wave -noupdate -expand -group output /sc_lifo_tb/DUT/data_out
add wave -noupdate -expand -group status /sc_lifo_tb/DUT/full
add wave -noupdate -expand -group status /sc_lifo_tb/DUT/empty
add wave -noupdate -expand -group status -radix unsigned /sc_lifo_tb/DUT/use_words
add wave -noupdate /sc_lifo_tb/DUT/ram
add wave -noupdate -radix unsigned /sc_lifo_tb/DUT/wr_ptr
add wave -noupdate -radix unsigned /sc_lifo_tb/DUT/rd_ptr
add wave -noupdate -max 4096.0 -radix unsigned /sc_lifo_tb/DUT/cnt_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {247520 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 161
configure wave -valuecolwidth 100
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
update
WaveRestoreZoom {246593 ns} {254495 ns}
