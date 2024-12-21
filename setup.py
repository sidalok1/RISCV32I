import pathlib as pl
import subprocess as sp
import numpy as np
import logging as log
import argparse
logger = log.getLogger(__name__)

if __name__ == "__main__":
    log.basicConfig(format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=log.INFO)
    logger.info(f"Checking directories for new files.")