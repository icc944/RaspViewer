#!/bin/bash
sleep 10

source /etc/environment
sudo /usr/bin/lxterminal --working-directory="$CPATH" --command="sudo $CPATH/main.sh"
