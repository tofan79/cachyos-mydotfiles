#!/usr/bin/env bash
# Smart focus: menyesuaikan perintah focus dengan layout workspace aktif.
#   - scrolling / monocle : pakai layoutmsg focus (fokus antar kolom)
#   - layout lainnya      : pakai focusdir biasa
# CATATAN: deskriptor hl.dsp.* harus dibungkus hl.dispatch() agar benar2 dijalankan
# (hl.dsp.* saja hanya membuat deskriptor; di keybind hl.bind yang mengeksekusi).
dir="${1:-left}"
layout="$(hyprctl activeworkspace -j | jq -r '.tiledLayout // "dwindle"')"

case "$layout" in
    scrolling)
        hyprctl eval "hl.dispatch(hl.dsp.layout('focus $dir'))" >/dev/null
        ;;
    monocle)
        if [[ "$dir" == "up" || "$dir" == "down" ]]; then
            hyprctl eval "hl.dispatch(hl.dsp.layout('focus $dir'))" >/dev/null
        else
            hyprctl eval "hl.dispatch(hl.dsp.layout('focus current'))" >/dev/null
        fi
        ;;
    *)
        hyprctl eval "hl.dispatch(hl.dsp.focus({ direction = '$dir' }))" >/dev/null
        ;;
esac
