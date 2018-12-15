#!/bin/bash
cat $1 | awk -v var=$3 ' NR % 2 == 1 { print $0; } NR % 2 == 0 { print substr($0,1,var); }' > $2
