PCF_OPTS = --pcf-allow-unconstrained

all: gtkwave

$(PROJECT_NAME).asc: $(PROJECT_NAME).json
	nextpnr-ice40 --package cb132 --hx8k --json $(PROJECT_NAME).json \
		--asc $(PROJECT_NAME).asc $(PCF_OPTS)

gui: $(PROJECT_NAME).json
	nextpnr-ice40 --package cb132 --hx8k --json $(PROJECT_NAME).json \
		--gui $(PCF_OPTS)

gtkwave: *.v
	iverilog -o $(PROJECT_NAME)_tb.out -D VCD_OUTPUT=$(PROJECT_NAME)_tb $(PROJECT_NAME)_tb.v $(PROJECT_NAME).v 
	vvp $(PROJECT_NAME)_tb.out 
	gtkwave $(PROJECT_NAME)_tb.vcd $(PROJECT_NAME)_tb.gtkw

$(PROJECT_NAME).json: *.v
	iverilog -o hardware.out *.v
	yosys -p 'synth_ice40 -top $(PROJECT_NAME) -json $(PROJECT_NAME).json' \
		*.v

clean:
	rm -f *.bin *.asc *.json *.out *.vcd
