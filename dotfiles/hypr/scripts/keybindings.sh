#!/usr/bin/env bash

# Parse keybinds.lua directly for categories + keybindings
# Shows grouped output via rofi with Pango markup

CONFIG="$HOME/.config/hypr/keybinds.lua"

awk '
BEGIN {
    category = ""
    in_separator_block = 0
    printed_category = 0
    in_workspace_loop = 0
    in_group_loop = 0
    pending_key = ""
    pending_desc = ""
}

/^-- ───/ {
    # Flush any pending multi-line bind
    if (pending_key != "" && pending_desc != "") {
        combo = toupper(pending_key)
        if (category != "" && !printed_category) {
            printf "<span color=\"#00e5ff\" size=\"smaller\"><b>── %s ──</b></span>\n", category
            printed_category = 1
        }
        printf "<b>%-28s</b> <span color=\"#888\">➔</span> <i>%s</i>\n", pending_desc, combo
    }
    pending_key = ""
    pending_desc = ""

    if (in_separator_block) {
        in_separator_block = 0
    } else {
        in_separator_block = 1
        printed_category = 0
    }
    next
}

in_separator_block && /^-- [A-Z]/ {
    cat = $0
    sub(/^-- /, "", cat)
    sub(/ \(.*\)/, "", cat)
    category = cat
    next
}

in_separator_block && !/^-- / {
    in_separator_block = 0
}

# Handle workspace for loop (1-9)
/^for i = 1, 9 do/ {
    in_workspace_loop = 1
    if (category != "" && !printed_category) {
        printf "<span color=\"#00e5ff\" size=\"smaller\"><b>── %s ──</b></span>\n", category
        printed_category = 1
    }
    for (i = 1; i <= 9; i++) {
        printf "<b>Workspace %-22s</b> <span color=\"#888\">➔</span> <i>SUPER + %d</i>\n", i, i
    }
    next
}

in_workspace_loop && /SHIFT/ {
    for (i = 1; i <= 9; i++) {
        printf "<b>Move to workspace %-12s</b> <span color=\"#888\">➔</span> <i>SUPER + SHIFT + %d</i>\n", i, i
    }
    in_workspace_loop = 0
    next
}

/^end$/ && in_workspace_loop {
    in_workspace_loop = 0
    next
}

# Handle group index for loop (1-5)
/^for i = 1, 5 do/ {
    in_group_loop = 1
    next
}

in_group_loop && /hl\.bind/ {
    for (i = 1; i <= 5; i++) {
        printf "<b>Group index %-23s</b> <span color=\"#888\">➔</span> <i>SUPER + ALT + %d</i>\n", i, i
    }
    in_group_loop = 0
    next
}

/^end$/ && in_group_loop {
    in_group_loop = 0
    next
}

in_workspace_loop || in_group_loop { next }

# Handle multi-line hl.bind() - description on same line
/hl\.bind\(.*description/ {
    line = $0

    if (match(line, /hl\.bind\(M \.\. "([^"]+)"/, m)) {
        raw_key = "SUPER" m[1]
    } else if (match(line, /hl\.bind\("([^"]+)"/, m)) {
        raw_key = m[1]
    } else {
        next
    }

    match(line, /description = "([^"]+)"/, d)
    desc = d[1]

    if (desc == "" || raw_key == "") next

    combo = toupper(raw_key)

    if (category != "" && !printed_category) {
        printf "<span color=\"#00e5ff\" size=\"smaller\"><b>── %s ──</b></span>\n", category
        printed_category = 1
    }
    printf "<b>%-28s</b> <span color=\"#888\">➔</span> <i>%s</i>\n", desc, combo
    next
}

# Handle multi-line hl.bind() - key only (description on next line)
/hl\.bind\(/ && !/description/ {
    line = $0

    if (match(line, /hl\.bind\(M \.\. "([^"]+)"/, m)) {
        pending_key = "SUPER" m[1]
    } else if (match(line, /hl\.bind\("([^"]+)"/, m)) {
        pending_key = m[1]
    } else {
        next
    }
    pending_desc = ""
    next
}

# Handle description line (continuation of multi-line hl.bind)
pending_key != "" && /description/ {
    match($0, /description = "([^"]+)"/, d)
    desc = d[1]

    if (desc != "") {
        combo = toupper(pending_key)
        if (category != "" && !printed_category) {
            printf "<span color=\"#00e5ff\" size=\"smaller\"><b>── %s ──</b></span>\n", category
            printed_category = 1
        }
        printf "<b>%-28s</b> <span color=\"#888\">➔</span> <i>%s</i>\n", desc, combo
    }
    pending_key = ""
    pending_desc = ""
    next
}
' "$CONFIG" | grep -v '^$' | rofi -dmenu -replace -p "Keybinds" -matching fuzzy -i -markup-rows -config ~/.config/rofi/config-keybinds.rasi
