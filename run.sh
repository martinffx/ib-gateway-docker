#!/bin/bash

set -e
set -o errexit

rm -f /tmp/.X0-lock

Xvfb :0 &
sleep 1

echo "Starting x11vnc: $VNC_PORT and socat: $TWS_PORT"
x11vnc -rfbport $VNC_PORT -display :0 -usepw -forever &
socat TCP-LISTEN:$TWS_PORT,fork TCP:localhost:4001,forever &

echo "Starting ibcstart.sh with $TRADING_MODE"
# Start this last and directly, so that if the gateway terminates for any reason, the container will stop as well.
# Retry behavior can be implemented by re-running the container.
/opt/ibc/scripts/ibcstart.sh $(ls ~/Jts) --gateway "--mode=$TRADING_MODE" "--user=$TWSUSERID" "--pw=$TWSPASSWORD"
