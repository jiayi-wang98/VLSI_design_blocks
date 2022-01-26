onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_sort_tb/clk
add wave -noupdate /data_sort_tb/rstn
add wave -noupdate /data_sort_tb/sob
add wave -noupdate /data_sort_tb/in_vld
add wave -noupdate /data_sort_tb/out_vld
add wave -noupdate -radix decimal /data_sort_tb/din
add wave -noupdate -radix decimal /data_sort_tb/dout
add wave -noupdate /data_sort_tb/dut/we
add wave -noupdate -radix decimal /data_sort_tb/dut/data_in
add wave -noupdate -radix unsigned /data_sort_tb/dut/ctrl_0/addr
add wave -noupdate -radix unsigned /data_sort_tb/dut/ctrl_0/cnt
add wave -noupdate -childformat {{{/data_sort_tb/dut/data_buff_0/data_buff[0]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[1]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[2]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[3]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[4]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[5]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[6]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[7]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[8]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[9]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[10]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[11]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[12]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[13]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[14]} -radix decimal} {{/data_sort_tb/dut/data_buff_0/data_buff[15]} -radix decimal}} -expand -subitemconfig {{/data_sort_tb/dut/data_buff_0/data_buff[0]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[1]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[2]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[3]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[4]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[5]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[6]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[7]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[8]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[9]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[10]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[11]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[12]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[13]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[14]} {-height 15 -radix decimal} {/data_sort_tb/dut/data_buff_0/data_buff[15]} {-height 15 -radix decimal}} /data_sort_tb/dut/data_buff_0/data_buff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40270 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {88590 ps}
