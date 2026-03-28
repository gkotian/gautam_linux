#!/usr/bin/env python

"""Simulates a Control key press every minute."""

import datetime
import subprocess
import time

def main():
    while True:
        print(datetime.datetime.now().isoformat(timespec='seconds'))
        subprocess.run(["xdotool", "key", "ctrl"], check=True)
        time.sleep(500)

if __name__ == "__main__":
    main()
