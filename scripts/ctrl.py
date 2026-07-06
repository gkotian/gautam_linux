#!/usr/bin/env python

"""Simulates a Control key press at a given interval."""

import argparse
import datetime
import subprocess
import time

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "interval",
        nargs="?",
        default="1m",
        help="Sleep interval between presses (e.g. 1m, 5m, 10m). Defaults to 1m.",
    )
    args = parser.parse_args()

    if not args.interval.endswith("m"):
        parser.error("interval must end with 'm' (e.g. 5m)")
    try:
        minutes = int(args.interval[:-1])
    except ValueError:
        parser.error("only whole minutes are allowed (e.g. 5m, not 1.5m)")
    if minutes < 1:
        parser.error("interval must be at least 1m")
    seconds = minutes * 60

    while True:
        subprocess.run(["xdotool", "key", "ctrl"], check=True)
        print(datetime.datetime.now().isoformat(timespec='seconds'))
        time.sleep(seconds)

if __name__ == "__main__":
    main()
