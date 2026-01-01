#!/usr/bin/env python

"""Simulates a Control key press every minute."""

import subprocess
import time

def main():
    while True:
        subprocess.run(["xdotool", "key", "ctrl"], check=True)
        time.sleep(60)

if __name__ == "__main__":
    main()
