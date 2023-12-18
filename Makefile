IVERILOG = iverilog
VVP = vvp
YOSYS = yosys
GTKWAVE = gtkwave

SOURCE = sync_arith_unit_29.sv
TB_SOURCE = sync_arith_unit_29_tb.sv
SYNTH_SCRIPT = synth_script.ys
OUTPUT = a.out
SYNTH_OUTPUT = synth_sync_arith_unit_29.v
WAVEFORM = waveform.vcd

all: test synth

test: $(TB_SOURCE)
	echo "Running Icarus Verilog Simulation..."
	$(IVERILOG) -o $(OUTPUT) $(TB_SOURCE)
	$(VVP) $(OUTPUT)

synth: $(SOURCE)
	echo "Running Yosys Synthesis..."
	$(YOSYS) -s $(SYNTH_SCRIPT) -o $(SYNTH_OUTPUT)

wave: $(WAVEFORM)
	echo "Opening Waveform in GTKWave..."
	$(GTKWAVE) $(WAVEFORM)

clean:
	echo "Cleaning up..."
	rm -f $(OUTPUT) $(SYNTH_OUTPUT) $(WAVEFORM)

.PHONY: all test synth wave clean
