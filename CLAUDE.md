# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a ZMK firmware configuration for the TOTEM split keyboard, a 38-key column-staggered split keyboard designed to run ZMK firmware on SEEED XIAO BLE microcontrollers.

## Build and Development Commands

### Building Firmware
Firmware builds automatically via GitHub Actions on push/PR to the `master` branch. The workflow is defined in [.github/workflows/build.yml](.github/workflows/build.yml) and uses the ZMK build-user-config workflow.

Build configuration is in [build.yaml](build.yaml), which specifies:
- Left half: `seeeduino_xiao_ble` board with `totem_left` shield
- Right half: `seeeduino_xiao_ble` board with `totem_right` shield
- Settings reset shield for troubleshooting

The compiled firmware artifacts will be available under Actions → firmware.zip containing:
- `totem_left-seeeduino_xiao_ble-zmk.uf2`
- `totem_right-seeeduino_xiao_ble-zmk.uf2`

### Flashing Firmware
1. Connect keyboard half via USB
2. Press reset button twice to enter bootloader mode
3. Drag and drop the corresponding `.uf2` file to the mass storage device
4. Repeat for the other half

## Architecture

### Repository Structure

- **config/**: Main firmware configuration directory (referenced in [west.yml](config/west.yml))
  - [totem.keymap](config/totem.keymap): Primary keymap definition
  - [totem.conf](config/totem.conf): Global configuration options
  - **boards/shields/totem/**: Shield-specific hardware definitions
    - [totem.dtsi](config/boards/shields/totem/totem.dtsi): Shared device tree definitions (matrix transform, kscan)
    - [totem_left.overlay](config/boards/shields/totem/totem_left.overlay) / [totem_right.overlay](config/boards/shields/totem/totem_right.overlay): Side-specific hardware configs
    - [totem.keymap](config/boards/shields/totem/totem.keymap): Duplicate keymap (keep in sync with config/totem.keymap)

### Keymap Layers

The keymap in [config/totem.keymap](config/totem.keymap) defines 6 layers:

1. **BASE (0)**: COLEMAK-DH layout with home row mods (GACS on left, SCAG on right)
2. **NAV (1)**: Navigation keys, arrow keys, brackets, and numpad
3. **SYM (2)**: Symbols, international characters (German Ä/Ö/Ü/ß), media controls, currency symbols
4. **ADJ (3)**: System functions (reset, bootloader, Bluetooth controls), F-keys
5. **TVP1 (4)**: Video editing shortcuts (toggled via combo on keys 11-12-13)
6. **TVP2 (5)**: Extended video editing shortcuts

### Hardware Configuration

The keyboard uses a 4x10 matrix defined in [totem.dtsi](config/boards/shields/totem/totem.dtsi):
- 4 rows, 10 columns (5 per half)
- Col2row diode direction
- Matrix scan on GPIO pins D0-D3

### Custom Behaviors

- **Home Row Mods**: 125ms tapping term, tap-preferred, 125ms quick-tap
- **Combos**:
  - Keys 0+1: ESC (50ms timeout)
  - Keys 3+6: Caps Word (50ms timeout)
  - Keys 11+12+13: Toggle TVP1 layer (100ms timeout)
- **Macros**: `gif` macro types "#gif"

### West Configuration

[config/west.yml](config/west.yml) points to the main ZMK repository at `zmkfirmware/zmk` on the `main` branch.

## Important Notes

- Keep both keymap files synchronized: [config/totem.keymap](config/totem.keymap) and [config/boards/shields/totem/totem.keymap](config/boards/shields/totem/totem.keymap)
- The repository currently has BT_CLR disabled (see recent commit) with debugging enabled
- Uses settings_reset shield for troubleshooting Bluetooth issues
