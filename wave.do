onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /minilab3_tb/TXR
add wave -noupdate /minilab3_tb/RXT
add wave -noupdate -divider Tester
add wave -noupdate /minilab3_tb/tester/clk
add wave -noupdate /minilab3_tb/tester/rst_n
add wave -noupdate /minilab3_tb/tester/iocs
add wave -noupdate /minilab3_tb/tester/iorw
add wave -noupdate /minilab3_tb/tester/rda
add wave -noupdate /minilab3_tb/tester/tbr
add wave -noupdate /minilab3_tb/tester/ioaddr
add wave -noupdate /minilab3_tb/tester/databus
add wave -noupdate /minilab3_tb/tester/txd
add wave -noupdate /minilab3_tb/tester/rxd
add wave -noupdate -radix unsigned /minilab3_tb/tester/DB
add wave -noupdate /minilab3_tb/tester/DC
add wave -noupdate -radix decimal /minilab3_tb/tester/iDC
add wave -noupdate /minilab3_tb/tester/tx_data
add wave -noupdate /minilab3_tb/tester/rx_data
add wave -noupdate /minilab3_tb/tester/status_reg
add wave -noupdate /minilab3_tb/tester/databus_i
add wave -noupdate /minilab3_tb/tester/uart_clk
add wave -noupdate /minilab3_tb/tester/tbr_i
add wave -noupdate /minilab3_tb/tester/rda_i
add wave -noupdate /minilab3_tb/tester/rxd_i
add wave -noupdate /minilab3_tb/tester/txd_i
add wave -noupdate /minilab3_tb/tester/transmit
add wave -noupdate -divider {Spart Dut}
add wave -noupdate /minilab3_tb/duts0/iocs
add wave -noupdate /minilab3_tb/duts0/iorw
add wave -noupdate /minilab3_tb/duts0/rda
add wave -noupdate /minilab3_tb/duts0/tbr
add wave -noupdate /minilab3_tb/duts0/ioaddr
add wave -noupdate /minilab3_tb/duts0/databus
add wave -noupdate /minilab3_tb/duts0/txd
add wave -noupdate /minilab3_tb/duts0/rxd
add wave -noupdate -radix unsigned /minilab3_tb/duts0/DB
add wave -noupdate /minilab3_tb/duts0/DC
add wave -noupdate /minilab3_tb/duts0/iDC
add wave -noupdate -expand /minilab3_tb/duts0/tx_data
add wave -noupdate /minilab3_tb/duts0/rx_data
add wave -noupdate /minilab3_tb/duts0/status_reg
add wave -noupdate /minilab3_tb/duts0/databus_i
add wave -noupdate /minilab3_tb/duts0/uart_clk
add wave -noupdate /minilab3_tb/duts0/tbr_i
add wave -noupdate /minilab3_tb/duts0/rda_i
add wave -noupdate /minilab3_tb/duts0/rxd_i
add wave -noupdate /minilab3_tb/duts0/txd_i
add wave -noupdate /minilab3_tb/duts0/transmit
add wave -noupdate -radix binary /minilab3_tb/duts0/rx/rx_data
add wave -noupdate -divider {Driver dut}
add wave -noupdate /minilab3_tb/dutd0/br_cfg
add wave -noupdate /minilab3_tb/dutd0/iocs
add wave -noupdate /minilab3_tb/dutd0/iorw
add wave -noupdate /minilab3_tb/dutd0/rda
add wave -noupdate /minilab3_tb/dutd0/tbr
add wave -noupdate /minilab3_tb/dutd0/ioaddr
add wave -noupdate /minilab3_tb/dutd0/databus
add wave -noupdate /minilab3_tb/dutd0/iocs_reg
add wave -noupdate /minilab3_tb/dutd0/iorw_reg
add wave -noupdate /minilab3_tb/dutd0/ioaddr_reg
add wave -noupdate /minilab3_tb/dutd0/data_out
add wave -noupdate /minilab3_tb/dutd0/save_buffer
add wave -noupdate -radix unsigned /minilab3_tb/dutd0/baud_divisor
add wave -noupdate /minilab3_tb/dutd0/data_bus_en
add wave -noupdate /minilab3_tb/dutd0/save
add wave -noupdate /minilab3_tb/dutd0/current_state
add wave -noupdate /minilab3_tb/dutd0/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 117
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {0 ns} {68 ns}
