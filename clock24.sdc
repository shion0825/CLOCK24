create_clock -name CLK -period 20.8333 [get_ports {CLK}]
derive_clock_uncertainty
set_input_delay -clock { CLK } 1 [get_ports {KEY[2] KEY[0] KEY[1] RST}]
set_output_delay -clock { CLK } 1 [get_ports {DIG[0] DIG[1] DIG[2] DIG[3] HEX0[0] HEX0[1] HEX0[2] HEX0[3] HEX0[4] HEX0[5] HEX0[6]}]