#!/usr/bin/env bash

# Terminal environment configuration
export LANG=C

echo "=== Pending Updates ==="
echo ""

# Display official repository updates
if command -v checkupdates &> /dev/null; then
    echo "--- Repository Updates ---"
    checkupdates || echo "No repository updates."
else
    echo "Error: checkupdates not found."
fi

echo ""

# Display AUR updates using the preferred helper
if command -v yay &> /dev/null; then
    echo "--- AUR Updates (yay) ---"
    yay -Qu --aur || echo "No AUR updates."
elif command -v paru &> /dev/null; then
    echo "--- AUR Updates (paru) ---"
    paru -Qu --aur || echo "No AUR updates."
else
    echo "Warning: No AUR helper (yay/paru) found for preview."
fi

echo ""
read -p "Proceed with system update? [y/N]: " choice

# Check user input
if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Update aborted."
    sleep 1
    exit 0
fi

echo ""
echo "=== Starting System Update ==="
echo ""

# Execute EndeavourOS update utility with AUR support
if command -v eos-update &> /dev/null; then
    eos-update --aur
else
    echo "Error: eos-update command not found."
    echo ""
    echo "Press any key to close this window..."
    read -n 1 -s
    exit 1
fi

echo ""
echo "=== Update process finished ==="
echo "Press any key to close this window..."
read -n 1 -s
