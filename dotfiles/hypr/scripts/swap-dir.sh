#!/usr/bin/env bash
# Smart swap: menyesuaikan perintah swap dengan layout workspace aktif.
#   - scrolling : konsumsi/keluarkan antar kolom (consume_or_expel) untuk kiri/kanan
#   - lainnya   : swap window sesuai arah (dwindle/master)
dir="${1:-left}"
layout="$(hyprctl activeworkspace -j | jq -r '.tiledLayout // "dwindle"')"

case "$layout" in
    scrolling)
        if [[ "$dir" == "left" ]]; then
            hyprctl eval "hl.dispatch(hl.dsp.layout('consume_or_expel prev'))" >/dev/null
        elif [[ "$dir" == "right" ]]; then
            hyprctl eval "hl.dispatch(hl.dsp.layout('consume_or_expel next'))" >/dev/null
        else
            hyprctl eval "hl.dispatch(hl.dsp.window.swap({ direction = '$dir' }))" >/dev/null
        fi
        ;;
    *)
        hyprctl eval "hl.dispatch(hl.dsp.window.swap({ direction = '$dir' }))" >/dev/null
        ;;
esac
