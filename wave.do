onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arbiter_circle_tb/clk
add wave -noupdate /arbiter_circle_tb/rst_n
add wave -noupdate /arbiter_circle_tb/req
add wave -noupdate /arbiter_circle_tb/gnt
add wave -noupdate -radix hexadecimal -childformat {{{/arbiter_circle_tb/dut/priority_seq[15]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[14]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[13]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[12]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[11]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[10]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[9]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[8]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[7]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[6]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[5]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[4]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[3]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[2]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[1]} -radix hexadecimal} {{/arbiter_circle_tb/dut/priority_seq[0]} -radix hexadecimal}} -subitemconfig {{/arbiter_circle_tb/dut/priority_seq[15]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[14]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[13]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[12]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[11]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[10]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[9]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[8]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[7]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[6]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[5]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[4]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[3]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[2]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[1]} {-height 15 -radix hexadecimal} {/arbiter_circle_tb/dut/priority_seq[0]} {-height 15 -radix hexadecimal}} /arbiter_circle_tb/dut/priority_seq
add wave -noupdate -radix unsigned /arbiter_circle_tb/dut/state
add wave -noupdate /arbiter_circle_tb/dut/en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119580 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 164
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {61630 ps}
