#!/usr/bin/env bash
# Take a screenshot, save it, and copy the file PATH (not the image) to the clipboard.
# Usage: screenshot.sh window|region

set -euo pipefail

mode="${1:-region}"
dir="$HOME/Pictures"
mkdir -p "$dir"
file="$dir/screenshot_$(date +%Y-%m-%d-%H%M%S).png"

case "$mode" in
    window)
        geom=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$geom" "$file"
        ;;
    region)
        geom=$(slurp) || exit 0
        grim -g "$geom" "$file"
        ;;
    output|screen)
        grim "$file"
        ;;
    *)
        echo "unknown mode: $mode" >&2
        exit 1
        ;;
esac

printf %s "$file" | wl-copy
notify-send -a "Screenshot" -i "$file" "Screenshot saved" "Path copied to clipboard:\n$file"
