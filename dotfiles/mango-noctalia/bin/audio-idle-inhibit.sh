#!/bin/bash
# Audio Idle Inhibitor for Mango
# Prevents screen sleep when audio is playing or being recorded
INHIBIT_PID=""
INHIBIT_ACTIVE=0

cleanup() {
    if [ -n "$INHIBIT_PID" ]; then
        kill "$INHIBIT_PID" 2>/dev/null
    fi
    exit 0
}

trap cleanup EXIT

check_audio_playing() {
    local active_streams
    active_streams=$(pw-dump 2>/dev/null | jq -r '[
        .[] | select(
            .type == "PipeWire:Interface:Node" and
            .info.state == "running" and
            (
                .info.props["media.class"] == "Stream/Output/Audio" or
                .info.props["media.class"] == "Stream/Input/Audio" or
                .info.props["media.class"] == "Stream/Input/Video"
            )
        )
    ] | length')

    if [ "$active_streams" -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

while true; do
    if check_audio_playing; then
        if [ "$INHIBIT_ACTIVE" -eq 0 ]; then
            systemd-inhibit --what=idle --who="audio-idle-inhibit" --why="Audio/Video is active" sleep infinity &
            INHIBIT_PID=$!
            INHIBIT_ACTIVE=1
        fi
    else
        if [ "$INHIBIT_ACTIVE" -eq 1 ]; then
            kill "$INHIBIT_PID" 2>/dev/null
            wait "$INHIBIT_PID" 2>/dev/null
            INHIBIT_PID=""
            INHIBIT_ACTIVE=0
        fi
    fi
    sleep 2
done
