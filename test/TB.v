`timescale 1ns / 1ps
module TB();

    reg clk;
    mainBus core (.clk(clk));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $dumpfile("signals.vcd"); // Name of the signal dump file
        $dumpvars(0, TB, TB.core.regFile.regs[10], TB.core.regFile.regs[11]); // Signals to dump
        #2000;  // Simulation time
        $finish();
    end

endmodule
