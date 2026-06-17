#!/usr/bin/env bash
export NVPRESENT_ENABLE_SMOOTH_MOTION=1
export DXVK_NVAPI_VKREFLEX=1
export PROTON_ENABLE_NGX_UPDATER=1

exec switcherooctl launch -- gamemoderun mangohud "$@"
