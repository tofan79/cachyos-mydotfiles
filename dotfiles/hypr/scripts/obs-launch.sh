#!/usr/bin/env bash
# Launch OBS dengan GPU NVIDIA (renderer + NVENC encoder)
# Default sistem = AMD iGPU. Launcher ini memaksa OBS aktif di NVIDIA
# untuk render UI + encoding lebih cepat saat streaming/recording.
set -euo pipefail

export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only

exec obs "$@"