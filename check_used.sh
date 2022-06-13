#!/usr/bin/bash

echo "Available disk space is:"
df -k /dev/sda1 | awk '{print $4}'

echo "Number of items in root file:"
ls / | wc -l 

echo "Files in directory are:"

ls /
