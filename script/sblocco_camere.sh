#!/bin/bash

###############################################################################
# Hikvision HWI-B140H Profile Scheduler Workaround
# Version: 1.0.0
#
# Uses official Hikvision ISAPI commands to force a correct reload of the
# Day/Night image profile after the firmware scheduler bug.
#
# NOTE:
# - Replace the placeholders below with your environment values.
# - Keep the XML payloads exactly as tested.
###############################################################################

# ============================================================================
# CONFIGURATION
# ============================================================================

NVR_IP="YOUR_NVR_IP"

CAMERA_USER="YOUR_USERNAME"
CAMERA_PASSWORD="YOUR_PASSWORD"

PORTS=(65001 65002 65003 65004 65005 65006)

# ============================================================================
# CURRENT DATE/TIME
# ============================================================================

CURRENT_MONTH=$(date +%-m)
CURRENT_HOUR=$(date +%H)
CURRENT_MINUTE=$(date +%M)

RUN_WORKAROUND=0

case $CURRENT_MONTH in
    1)  [ "$CURRENT_HOUR" -eq 06 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    2)  [ "$CURRENT_HOUR" -eq 06 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
    3)  [ "$CURRENT_HOUR" -eq 05 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    4)  [ "$CURRENT_HOUR" -eq 05 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
    5)  [ "$CURRENT_HOUR" -eq 04 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    6)  [ "$CURRENT_HOUR" -eq 04 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
    7)  [ "$CURRENT_HOUR" -eq 04 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    8)  [ "$CURRENT_HOUR" -eq 05 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
    9)  [ "$CURRENT_HOUR" -eq 05 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    10) [ "$CURRENT_HOUR" -eq 06 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
    11) [ "$CURRENT_HOUR" -eq 06 ] && [ "$CURRENT_MINUTE" -eq 40 ] && RUN_WORKAROUND=1 ;;
    12) [ "$CURRENT_HOUR" -eq 07 ] && [ "$CURRENT_MINUTE" -eq 10 ] && RUN_WORKAROUND=1 ;;
esac

[ "$RUN_WORKAROUND" -ne 1 ] && exit 0

echo "=================================================="
echo " Hikvision Profile Scheduler Workaround v1.0.0"
echo "=================================================="
echo "Time: $CURRENT_HOUR:$CURRENT_MINUTE  Month: $CURRENT_MONTH"
echo

for PORT in "${PORTS[@]}"; do

    echo "Processing camera on port $PORT"

    # STEP 1 - Disable scheduler
    curl -s -X PUT --digest -u "$CAMERA_USER:$CAMERA_PASSWORD" \
    "http://$NVR_IP:$PORT/ISAPI/Image/channels/1/displayParamSwitch" \
    -H "Content-Type: application/xml" \
    -d "<REPLACE_WITH_YOUR_ORIGINAL_DISABLE_SCHEDULER_XML>"

    sleep 10

    # STEP 2 - Force Low Illumination
    curl -s -X PUT --digest -u "$CAMERA_USER:$CAMERA_PASSWORD" \
    "http://$NVR_IP:$PORT/ISAPI/Image/channels/1/mountingScenario" \
    -H "Content-Type: application/xml" \
    -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?><MountingScenario><mode>lowIllumination</mode></MountingScenario>"

    sleep 10

    # STEP 3 - Force Normal profile
    curl -s -X PUT --digest -u "$CAMERA_USER:$CAMERA_PASSWORD" \
    "http://$NVR_IP:$PORT/ISAPI/Image/channels/1/mountingScenario" \
    -H "Content-Type: application/xml" \
    -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?><MountingScenario><mode>normal</mode></MountingScenario>"

    sleep 10

    # STEP 4 - Restore monthly scheduler
    curl -s -X PUT --digest -u "$CAMERA_USER:$CAMERA_PASSWORD" \
    "http://$NVR_IP:$PORT/ISAPI/Image/channels/1/displayParamSwitch" \
    -H "Content-Type: application/xml" \
    -d "<REPLACE_WITH_YOUR_ORIGINAL_MONTHLY_SCHEDULER_XML>"

    sleep 5

done

echo
echo "Workaround completed."
