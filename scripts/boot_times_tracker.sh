#!/bin/bash

TRACKING_FILE=/home/gautam/tmp_home/BOOT_TIMES.txt

echo "Current timestamp:" >> $TRACKING_FILE
echo "------------------" >> $TRACKING_FILE
date >> $TRACKING_FILE
echo "" >> $TRACKING_FILE

echo "Latest boot time:" >> $TRACKING_FILE
echo "-----------------" >> $TRACKING_FILE
who -b | sed 's/^\s*//g' >> $TRACKING_FILE
echo "" >> $TRACKING_FILE

echo "Last three shutdown times:" >> $TRACKING_FILE
echo "--------------------------" >> $TRACKING_FILE
last -x | grep shutdown | head -3 >> $TRACKING_FILE
echo "" >> $TRACKING_FILE

echo "=======================================================" >> $TRACKING_FILE
echo "" >> $TRACKING_FILE
