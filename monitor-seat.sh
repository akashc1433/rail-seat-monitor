#!/data/data/com.termux/files/usr/bin/bash

source ./config.sh

while true
do
    echo ""
    echo "===== TRAIN SEAT MONITOR ====="
    echo "$(date)"

    ./check-seat.sh
    RESULT=$?

    if [ "$RESULT" -eq 0 ]; then
        echo ""
        echo "🚨 SEAT AVAILABLE - MONITORING STOPPED"
        break
    fi

    echo ""
    echo "No seat available."
    echo "Next check in $CHECK_INTERVAL seconds..."
    sleep "$CHECK_INTERVAL"
done
