all: gtkwave

$(PROJECT_NAME).bin: $(PROJECT_NAME).asc
	icepack $(PROJECT_NAME).asc $(PROJECT_NAME).bin

$(PROJECT_NAME).asc: $(PROJECT_NAME).json $(PROJECT_NAME).pcf
	nextpnr-ice40 --package cb132 --hx8k --json $(PROJECT_NAME).json \
		--asc $(PROJECT_NAME).asc --pcf $(PROJECT_NAME).pcf

gui: $(PROJECT_NAME).json $(PROJECT_NAME).pcf
	nextpnr-ice40 --package cb132 --hx8k --json $(PROJECT_NAME).json \
		--pcf $(PROJECT_NAME).pcf --gui

$(PROJECT_NAME).json: *.v
	iverilog -o hardware.out *.v
	yosys -p 'synth_ice40 -top $(PROJECT_NAME) -json $(PROJECT_NAME).json' \
		*.v

burn: $(PROJECT_NAME).bin
	iceFUNprog $(PROJECT_NAME).bin

gtkwave: *.v
	iverilog -o $(PROJECT_NAME)_tb.out -D VCD_OUTPUT=$(PROJECT_NAME)_tb $(PROJECT_NAME)_tb.v $(PROJECT_NAME).v 
	vvp $(PROJECT_NAME)_tb.out 
	gtkwave $(PROJECT_NAME)_tb.vcd $(PROJECT_NAME)_tb.gtkw

clean:
	rm -f *.bin *.asc *.json *.out *.vcd
