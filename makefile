default: signals.vcd
	gtkwave signals.vcd

signals.vcd: sim
	vvp sim

sim: src test
	iverilog -o sim test/TB.v src/mainBus.v src/InstructionMemory.v

clean:
	rm -f sim
	rm -f signals.vcd
