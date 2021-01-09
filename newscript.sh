#!/bin/bash

echo -e "PID\t\tCOMMAND"

OUTPUT=$(ps -x | grep "$1" | awk '{split($0,a," ");printf("%s\t\t%s\n",a[1],a[5]);}')

echo -e "$OUTPUT"
