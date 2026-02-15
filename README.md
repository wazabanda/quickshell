# Quickshell Configuration (MADE WITH AI ASSISTANCE)
A modern, themed Wayland panel for Hyprland with a reusable dropdown menu system.

## Features

- 🎨 **Centralized Theming** - All colors, spacing, and styling in one place (`Theme.qml`)
- 📊 **System Statistics** - CPU, Memory, and Temperature monitoring with visual radial/horizontal bars
- 🎮 **Mode Selector** - Switch between Work and Game modes
- 🔧 **Reusable Dropdown System** - Easy-to-use components for creating custom dropdowns
- 🖥️ **Workspace Management** - Hyprland workspace integration
- 📡 **System Info** - Network, Volume, Battery, Clock widgets
- 🎯 **Smart Positioning** - Dropdowns automatically align with their buttons

## Quick Start

### File Structure

```
quickshell/
├── README.md                       # This file
├── DROPDOWN_SYSTEM.md              # Full dropdown documentation
├── DROPDOWN_QUICK_REFERENCE.md     # Quick reference guide
├── qmldir                          # Module definition
├── Theme.qml                       # Theme singleton
├── shell.qml                       # Main panel configuration
└── widgets/
    ├── DropdownButton.qml          # Reusable dropdown button
    ├── DropdownMenu.qml            # Reusable dropdown menu
    ├── ModeButton.qml              # Work/Game mode button
    ├── ModeDropdown.qml            # Work/Game mode selector
    ├── StatsGroup.qml              # System stats button
    ├── StatsDropdown.qml           # System stats display
    ├── RadialBarWidget.qml         # Circular progress bar
    ├── TempBarWidget.qml           # Horizontal temperature bar
    ├── BatteryWidget.qml           # Battery indicator
    ├── ClockWidget.qml             # Date/time display
    ├── CpuTempWidget.qml           # CPU temperature (data source)
    ├── CpuWidget.qml               # CPU usage (data source)
    ├── MemoryWidget.qml            # Memory usage (data source)
    ├── NetworkWidget.qml           # Network status
    ├── VolumeWidget.qml            # Volume control
    ├── WorkspacesWidget.qml        # Hyprland workspaces
    └── Separator.qml               # Visual separator
```

## Customization

### Changing Colors and Theme

Edit `Theme.qml` to customize the entire panel:

```qml
// Colors (Tokyo Night palette)
readonly property color background: "#1a1b26"
readonly property color foreground: "#a9b1d6"
readonly property color cyan: "#0db9d7"
readonly property color blue: "#7aa2f7"
// ... more colors

// Spacing
readonly property int spacingSmall: 4
readonly property int spacingMedium: 8
// ... more spacing

// Borders
readonly property int borderWidth: 2
readonly property int borderRadius: 8
```

### Adding a New Dropdown

See `DROPDOWN_QUICK_REFERENCE.md` for a quick guide, or `DROPDOWN_SYSTEM.md` for full documentation.

**TL;DR:**

1. Create button widget extending `DropdownButton`
2. Create dropdown widget extending `DropdownMenu`
3. Add to `shell.qml`

### Configuring Mode Commands

Edit `widgets/ModeDropdown.qml` to customize what happens when switching modes:

```qml
// Work mode commands (line ~120)
Process {
  id: workModeProcess
  command: ["sh", "-c", "your-work-commands-here"]
}

// Game mode commands (line ~126)
Process {
  id: gameModeProcess
  command: ["sh", "-c", "your-game-commands-here"]
}
```

Example commands:
- Change CPU governor: `cpupower frequency-set -g performance`
- Adjust display: `hyprctl keyword monitor DP-1,2560x1440@144,0x0,1`
- Toggle compositor effects: `hyprctl keyword decoration:blur:enabled false`
- Launch applications: `steam &`

## Panel Layout

```
┌────────────────────────────────────────────────────────────────┐
│ [Workspaces] ... [Mode] | [Net] | [Vol] | [Bat] | [Clock] | [Stats] │
└────────────────────────────────────────────────────────────────┘
```

### Widgets (Left to Right)

1. **Workspaces** - Shows 10 Hyprland workspaces, click to switch
2. **Mode** - Toggle between Work/Game modes
3. **Network** - Network status, click to open network manager
4. **Volume** - Volume level, click to open pavucontrol
5. **Battery** - Battery percentage and status
6. **Clock** - Date and time, click to open calendar
7. **Stats** - System statistics dropdown

## Dependencies

- **Quickshell** - The shell framework
- **Hyprland** - Window manager
- **JetBrainsMono Nerd Font** - Font with icons
- **pactl** - For volume control
- **nmrs** - Network manager (or modify NetworkWidget.qml)

## Documentation

- **[DROPDOWN_SYSTEM.md](DROPDOWN_SYSTEM.md)** - Complete dropdown system documentation
  - Architecture overview
  - Component API reference
  - Creating custom dropdowns
  - Positioning system
  - Styling guide
  - Troubleshooting

- **[DROPDOWN_QUICK_REFERENCE.md](DROPDOWN_QUICK_REFERENCE.md)** - Quick reference
  - TL;DR guide
  - Common patterns
  - Property cheatsheet
  - Icon reference
  - Example code snippets

## Theme Properties Reference

### Colors
- `background`, `foreground`, `muted`
- `cyan`, `blue`, `yellow`, `red`, `green`, `orange`
- `borderColor`

### Typography
- `fontFamily` - "JetBrainsMono Nerd Font"
- `fontSize` - 14
- `fontSizeSmall` - 12
- `fontSizeLarge` - 16

### Spacing
- `spacingSmall` - 4px
- `spacingMedium` - 8px
- `spacingLarge` - 12px
- `spacingXLarge` - 16px
- `spacingXXLarge` - 20px

### Borders
- `borderWidth` - 2px
- `borderRadius` - 8px

### Panel
- `panelHeight` - 32px
- `panelMargins` - 8px

### Dropdown
- `dropdownWidth` - 280px
- `dropdownHeight` - 300px
- `dropdownMargins` - 16px

## Examples

### Example 1: Change Dropdown Alignment

```qml
StatsDropdown {
  id: statsDropdown
  anchor.window: panel
  buttonItem: statsGroup
  alignment: "center"  // Change from "right" to "center"
}
```

### Example 2: Adjust Dropdown Size

```qml
ModeDropdown {
  id: modeDropdown
  anchor.window: panel
  buttonItem: modeButton
  alignment: "right"
  dropdownWidth: 350   // Wider
  dropdownHeight: 500  // Taller
}
```

### Example 3: Add Custom Widget to Panel

```qml
// In shell.qml, inside RowLayout
Separator {}

MyCustomWidget {
  // Your widget here
}

Separator {}
```

## Troubleshooting

### Panel Not Showing
- Check Quickshell is running: `ps aux | grep quickshell`
- Check logs: `journalctl -f | grep quickshell`

### Dropdown Not Appearing
- Verify `anchor.window: panel` is set
- Check `buttonItem` reference is correct
- Ensure `onToggleDropdown` handler exists

### Styling Not Applied
- Verify `import ".." as Root` in widget files
- Use `Root.Theme.property` not `Theme.property`
- Check `qmldir` exists in root directory

### Icons Not Showing
- Install JetBrainsMono Nerd Font
- Verify font is loaded: `fc-list | grep JetBrains`

### Stats Not Updating
- Check process permissions for `/proc/stat`, `/sys/class/thermal/`, etc.
- Verify commands work in terminal: `head -1 /proc/stat`

## Contributing

When adding new features:

1. Follow the existing code structure
2. Use Theme properties for all styling
3. Document your changes
4. Test with different alignments and sizes
5. Update relevant documentation

## License

Personal configuration - feel free to use and modify.

## Credits

- **Tokyo Night** color scheme
- **Nerd Fonts** for icons
- **Quickshell** framework
- **Hyprland** window manager

