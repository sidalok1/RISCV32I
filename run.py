import pathlib as pl
import subprocess as sp
import numpy as np
import logging as log
import argparse
logger = log.getLogger(__name__)

projDir: pl.Path = pl.Path(__file__).parent

flags: list[str] = []

type cmd = list[str]
iverilogCMD: cmd = ["iverilog", "-o", "sim.cmv","-s", "TB"]
vvpCMD: cmd = ["vvp", "sim.cmv"]

cmdFile: pl.Path = projDir / "ivList.txt"
srcDir: pl.Path = projDir / "src"
testDir: pl.Path = projDir / "test"

def updateCmdFile() -> bool:
    srcsTime = srcDir.stat().st_mtime
    testsTime = testDir.stat().st_mtime
    if cmdFile.exists():
        cmdTime = cmdFile.stat().st_mtime
        if srcsTime < cmdTime and testsTime < cmdTime:
            return False
    return True

if __name__ == "__main__":
    sources = [x.as_posix() for x in srcDir.iterdir() if x.suffix == ".v"]
    tests = [x.as_posix() for x in testDir.iterdir() if x.suffix == ".v"]

    ivlog = sp.run(iverilogCMD + sources + tests, capture_output=True, text=True)
    if ivlog.returncode != 0:
        print("Error running Icarus Verilog compilation")
        print(iverilogCMD + sources + tests)
        print(ivlog.stderr)
        raise ChildProcessError
    else:
        print(ivlog.stdout)
    vpp = sp.run(vvpCMD, capture_output=True, text=True)
    if vpp.returncode != 0:
        print(vpp.stderr)
        raise ChildProcessError
    else:
        print(vpp.stdout)