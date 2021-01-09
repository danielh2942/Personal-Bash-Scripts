#!/bin/bash

#Basically I had to run top a lot to find PIDs so I could kill them when things crashed so I made this
#It gets everything running at the moment, grabs relevant processes using grep then reformats them with awk
#run it like pidlist processname
echo -e "PID\t\tCOMMAND"

OUTPUT=$(ps -x | grep "$1" | awk '{split($0,a," ");printf("%s\t\t%s\n",a[1],a[5]);}')

echo -e "$OUTPUT"
