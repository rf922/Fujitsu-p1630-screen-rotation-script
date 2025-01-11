#!/bin/bash
###############
# File   : rotate-screen-v2.sh
# Author : rf922
# Description : Bash script to handle rotating screen 90 degrees clockwise
# relative to the screens current orientation
# Usage : bash rotate-screen-v2.sh
#
###############

W="1280"
H="768"

# Define the calibration settings for each rotation
normal_calibration=(
"Option  \"Calibration\"  \"102 3908 340 3974\""
"Option  \"SwapXY\"  \"0\""
"Option  \"InvertX\"  \"0\""
"Option  \"InvertY\"  \"0\""
)
right_calibration=(
"Option  \"Calibration\"  \"340 3974 102 3908\""
"Option  \"SwapXY\"  \"1\""
"Option  \"InvertX\"  \"0\""
"Option  \"InvertY\"  \"1\""
)
inverted_calibration=(
"Option  \"Calibration\"  \"102 3908 3974 340\""
"Option  \"SwapXY\"  \"0\""
"Option  \"InvertX\"  \"1\""
"Option  \"InvertY\"  \"1\""
)
left_calibration=(
"Option  \"Calibration\"  \"340 3974 102 3908\""
"Option  \"SwapXY\"  \"1\""
"Option  \"InvertX\"  \"1\""
"Option  \"InvertY\"  \"0\""
)

# Translation Matrices to handle mapping the touch screen to the correct orientation
right="0 1 0 -1 0 1 0 0 1"           # 90
inverted="-1 0 1 0 -1 1 0 0 1"       # inverted
left="0 -1 1 1 0 0 0 0 1"            # 270 rotation
normal="1 0 0 0 1 0 0 0 1"           # normal 

# Get the current rotation
rotation="$(xrandr --query --verbose | grep 'LVDS-1' | cut --delimiter=' ' -f6)"

# Determine the next rotation state and calibration
case "${rotation}" in
  "normal")
    next_rotation="right"
    new_calibration=("${right_calibration[@]}")
    transform_matrix="$right"
    ;;
  "right")
    next_rotation="inverted"
    new_calibration=("${inverted_calibration[@]}")
    transform_matrix="$inverted"
    ;;
  "inverted")
    next_rotation="left"
    new_calibration=("${left_calibration[@]}")
    transform_matrix="$left"
    ;;
  *)
    next_rotation="normal"
    new_calibration=("${normal_calibration[@]}")
    transform_matrix="$normal"
    ;;
esac

# Set the new rotation
xrandr --output LVDS-1 --rotate "${next_rotation}"

# Update the calibration file
{
    echo 'Section "InputClass"'
    echo '    Identifier  "calibration"'
    echo '    MatchProduct    "Fujitsu Component USB Touch Panel"'
    echo '    Driver  "evdev"'
    for option in "${new_calibration[@]}"; do
        echo "    $option"
    done
    echo 'EndSection'
} > /etc/X11/xorg.conf.d/99-calibration.conf

# Set the transform matrix
xinput set-prop "Fujitsu Component USB Touch Panel" "Coordinate Transformation Matrix" $transform_matrix

