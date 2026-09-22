#!/data/data/com.termux/files/usr/bin/bash

source ./config.sh

API_KEY="$RAILRADAR_KEY"

URL="https://api.railradar.in/v1/trains/$TRAIN/seats?journeyDate=$DATE&source=$FROM&destination=$TO&classCode=$CLASS&quotaCode=$QUOTA"

RESPONSE=$(curl -s -S "$URL" \
  -H "Authorization: Bearer $API_KEY")

DATA=$(echo "$RESPONSE" | jq -r --arg d "$DATE" '
  .data.calendar[]?
  | select(.date == $d)
')

STATUS=$(echo "$DATA" | jq -r '.status // ""')
AVAILABLE=$(echo "$DATA" | jq -r '.isAvailable // false')
SEATS=$(echo "$DATA" | jq -r '.availableSeats // 0')

echo "Train: $TRAIN"
echo "Route: $FROM -> $TO"
echo "Date: $DATE"
echo "Class: $CLASS"
echo "Quota: $QUOTA"
echo "Status: $STATUS"
echo "Available: $AVAILABLE"
echo "Available Seats: $SEATS"

if [ "$AVAILABLE" = "true" ]; then

    echo ""
    echo "SEAT AVAILABLE!"

    termux-notification \
        --title "TRAIN SEAT AVAILABLE" \
        --content "$TRAIN | $FROM -> $TO | $CLASS | $STATUS | Seats: $SEATS" \
        --priority high

    exit 0

else

    echo ""
    echo "No confirmed availability."

    exit 1

fi
