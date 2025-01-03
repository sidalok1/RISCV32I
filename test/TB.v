`timescale 1ns / 1ps
module TB();

    integer i;
    reg clk;
    mainBus core (.clk(clk));

    always #5 clk = ~clk;

    initial begin
        clk = 1;
        $dumpfile("signals.vcd"); // Name of the signal dump file
        $dumpvars(0, TB); // Signals to dump
        for (i = 0; i < 32; i = i + 1)
            $dumpvars(0, TB.core.regFile.regs[i]); // reg dump
        for (i = 0; i < 4096; i = i + 1)
            $dumpvars(0, TB.core.mem.memory[i]); // mem dump
        #10000;  // Simulation time
        $finish();
    end

endmodule
