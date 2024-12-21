default: signals.vcd
	gtkwave signals.vcd

signals.vcd: sim
	vvp sim

sim: src test
	iverilog -o sim test/TB.v -y src

clean:
	rm -f sim
	rm -f signals.vcd
