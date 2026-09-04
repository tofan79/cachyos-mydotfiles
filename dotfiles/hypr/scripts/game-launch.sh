#!/usr/bin/env bash
# Launch game dengan GPU NVIDIA + GameMode + MangoHud
# Gunakan di Steam Launch Options: game-launch.sh %command%
set -euo pipefail

# Paksa render NVIDIA (default sistem = AMD iGPU)
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __VK_LAYER_NV_optimus=NVIDIA_only

exec gamemoderun mangohud "$@"