default: signals.vcd
	gtkwave signals.vcd memView.sav

signals.vcd: sim
	vvp sim > sim.log

sim: src test test/init.mem
	iverilog -o sim test/TB.v -y src

test/init.mem: traces/test.txt
	python3 ./initMem.py

traces/test.txt: traces/test.asm
	java -jar ./rars1_6.jar a dump .text HexText ./traces/test.txt ./traces/test.asm

clean:
	rm -f sim
	rm -f signals.vcd
