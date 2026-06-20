#!/usr/bin/env bash
noctalia msg session lock
sleep 1
systemctl suspend --no-ask-password
