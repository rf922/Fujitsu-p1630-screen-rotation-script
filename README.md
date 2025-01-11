# Fujitsu-p1630-screen-rotation-script
A script in bash to handle rotating the orientation of the screen. Translates touchscreen coordinates to ensure touch screen maps to correct position on screen ralative to the current screen orientation

# Screen Orientation Script for Fujitsu P1630

## Overview
This script allows users to rotate the screen orientation of a Fujitsu P1630 running Debian 12 with XFCE. The script manages the display orientation and touch panel calibration to ensure that touch input remains aligned with the rotated screen.

## Features
- Rotates the screen 90 degrees clockwise relative to its current orientation.
- Updates the touch panel calibration automatically for each screen rotation.
- Designed specifically for the Fujitsu Component USB Touch Panel and 1280x768 resolution.

## Requirements
- Fujitsu P1630 running Debian 12 with XFCE.
- `xrandr` and `xinput` installed.
- Root privileges to update touch panel calibration.

## Configuration Details
### Screen Information
- **Resolution**: 1280x768
- **Device**: Fujitsu Component USB Touch Panel
- **Default Coordinate Transformation Matrix**: `1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000`

### Touch Panel Calibration Settings
The calibration settings are defined for four orientations:
1. **Normal**
   - Calibration: `102 3908 340 3974`
   - SwapXY: `0`
   - InvertX: `0`
   - InvertY: `0`
2. **Right (90 degrees)**
   - Calibration: `340 3974 102 3908`
   - SwapXY: `1`
   - InvertX: `0`
   - InvertY: `1`
3. **Inverted (180 degrees)**
   - Calibration: `102 3908 3974 340`
   - SwapXY: `0`
   - InvertX: `1`
   - InvertY: `1`
4. **Left (270 degrees)**
   - Calibration: `340 3974 102 3908`
   - SwapXY: `1`
   - InvertX: `1`
   - InvertY: `0`

## Script Details
### File: `rotate-screen-v2.sh`
#### Description
A Bash script that:
- Rotates the screen using `xrandr`.
- Updates the touch panel calibration using a dynamically generated configuration file.
- Maps the touch panel's input coordinates to match the rotated screen using a transformation matrix.

#### Usage
Run the script with:
```bash
sudo bash rotate-screen-v2.sh
```

#### Workflow
1. **Check Current Orientation**: Determines the current orientation of the screen using `xrandr`.
2. **Calculate Next State**: Determines the next orientation and corresponding touch panel calibration.
3. **Update Screen Orientation**: Applies the new rotation using `xrandr`.
4. **Update Touch Calibration**: Writes the calibration settings to `/etc/X11/xorg.conf.d/99-calibration.conf` and applies the transformation matrix using `xinput`.

## Notes
- Ensure the script has execute permissions: `chmod +x rotate-screen-v2.sh`

## Acknowledgments
- Author: rf922

