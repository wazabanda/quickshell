# Dropdown System Documentation

## Overview

The Quickshell dropdown system provides a reusable, flexible way to create dropdown menus in your panel. It consists of two main components that work together:

1. **DropdownButton** - The clickable button in the panel
2. **DropdownMenu** - The popup window that appears when the button is clicked

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Panel                             │
│  ┌──────────────┐              ┌──────────────┐    │
│  │ ModeButton   │              │ StatsGroup   │    │
│  │ (Dropdown    │              │ (Dropdown    │    │
│  │  Button)     │              │  Button)     │    │
│  └──────────────┘              └──────────────┘    │
└─────────────────────────────────────────────────────┘
         │                                │
         │ toggleDropdown()               │ toggleDropdown()
         ▼                                ▼
  ┌─────────────┐                  ┌─────────────┐
  │ ModeDropdown│                  │StatsDropdown│
  │ (Dropdown   │                  │ (Dropdown   │
  │  Menu)      │                  │  Menu)      │
  └─────────────┘                  └─────────────┘
```

## Components

### 1. DropdownButton

A reusable button widget that can toggle any dropdown menu.

**File:** `widgets/DropdownButton.qml`

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | string | "Menu" | The text label displayed next to the icon |
| `icon` | string | "󰅂" | Icon shown when dropdown is closed |
| `iconOpen` | string | "󰅀" | Icon shown when dropdown is open |
| `dropdownWindow` | var | null | Reference to the dropdown window to control |
| `buttonX` | int | (calculated) | Read-only: Button's X position in panel |
| `buttonWidth` | int | (calculated) | Read-only: Button's width |
| `buttonHeight` | int | (calculated) | Read-only: Button's height |

#### Signals

- `toggleDropdown()` - Emitted when the button is clicked

#### Example Usage

```qml
ModeButton {
  id: modeButton
  dropdownWindow: modeDropdown
  
  onToggleDropdown: {
    modeDropdown.visible = !modeDropdown.visible
  }
}
```

---

### 2. DropdownMenu

A reusable dropdown container that provides consistent styling and positioning.

**File:** `widgets/DropdownMenu.qml`

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | string | "Menu" | Title displayed at the top of the dropdown |
| `dropdownWidth` | int | 280 | Width of the dropdown in pixels |
| `dropdownHeight` | int | 300 | Height of the dropdown in pixels |
| `buttonItem` | var | null | Reference to the button for relative positioning |
| `alignment` | string | "right" | How to align with button: "left", "center", "right" |
| `alignmentOffset` | int | 0 | Additional pixel offset after alignment |
| `offsetX` | int | -1 | Manual X position (legacy mode, set >= 0 to use) |
| `offsetY` | int | panel.height | Manual Y position |
| `content` | alias | - | The content to display inside the dropdown |

#### Positioning Modes

##### Mode 1: Button-Relative (Recommended)

Set `buttonItem` to automatically position relative to the button.

```qml
ModeDropdown {
  id: modeDropdown
  anchor.window: panel
  buttonItem: modeButton
  alignment: "right"
  alignmentOffset: 0
}
```

**Alignment Options:**

- **`"left"`** - Dropdown's left edge aligns with button's left edge
  ```
  [Button]
  [Dropdown========]
  ```

- **`"center"`** - Dropdown centers on the button
  ```
     [Button]
  [Dropdown========]
  ```

- **`"right"`** - Dropdown's right edge aligns with button's right edge
  ```
           [Button]
  [Dropdown========]
  ```

**Alignment Offset:**

Fine-tune position after alignment:
- Positive values: Move right
- Negative values: Move left

```qml
alignment: "right"
alignmentOffset: -10  // Shift 10px to the left
```

##### Mode 2: Manual Positioning (Legacy)

Set `offsetX` >= 0 to manually specify position.

```qml
ModeDropdown {
  id: modeDropdown
  anchor.window: panel
  offsetX: panel.width - 300
  offsetY: panel.height + 5
}
```

---

## Creating a New Dropdown

### Step 1: Create the Button Widget

Create a new file: `widgets/YourButton.qml`

```qml
import QtQuick
import ".." as Root

DropdownButton {
  id: root
  
  label: "Your Label"
  icon: "󰐾"      // Icon when closed
  iconOpen: "󰐽"  // Icon when open
}
```

### Step 2: Create the Dropdown Widget

Create a new file: `widgets/YourDropdown.qml`

```qml
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "Your Dropdown Title"
  dropdownWidth: 280
  dropdownHeight: 300
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingLarge
    
    // Your custom content here
    Text {
      text: "Hello from dropdown!"
      color: Root.Theme.foreground
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
    }
    
    Item { Layout.fillHeight: true }
  }
}
```

### Step 3: Add to Panel

Edit `shell.qml`:

```qml
// Inside the RowLayout in PanelWindow
YourButton {
  id: yourButton
  dropdownWindow: yourDropdown
  
  onToggleDropdown: {
    yourDropdown.visible = !yourDropdown.visible
  }
  
  YourDropdown {
    id: yourDropdown
    anchor.window: panel
    buttonItem: yourButton
    alignment: "center"
  }
}
```

---

## Complete Examples

### Example 1: Simple Dropdown with Text

```qml
// Button
DropdownButton {
  id: infoButton
  label: "Info"
  icon: "󰋼"
  iconOpen: "󰋽"
}

// Dropdown
DropdownMenu {
  id: infoDropdown
  anchor.window: panel
  buttonItem: infoButton
  alignment: "center"
  
  title: "Information"
  dropdownWidth: 300
  dropdownHeight: 200
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    Text {
      text: "System: Arch Linux"
      color: Root.Theme.foreground
      font.family: Root.Theme.fontFamily
    }
    
    Text {
      text: "Uptime: 2 days"
      color: Root.Theme.foreground
      font.family: Root.Theme.fontFamily
    }
    
    Item { Layout.fillHeight: true }
  }
}
```

### Example 2: Dropdown with Buttons

```qml
// Dropdown with interactive buttons
DropdownMenu {
  id: actionsDropdown
  anchor.window: panel
  buttonItem: actionsButton
  alignment: "right"
  
  title: "Quick Actions"
  dropdownWidth: 250
  dropdownHeight: 300
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    // Lock button
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 40
      color: Root.Theme.background
      border.color: Root.Theme.borderColor
      border.width: Root.Theme.borderWidth
      radius: Root.Theme.borderRadius
      
      Text {
        anchors.centerIn: parent
        text: "🔒 Lock Screen"
        color: Root.Theme.foreground
        font.family: Root.Theme.fontFamily
      }
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          // Execute lock command
          lockProcess.running = true
        }
      }
    }
    
    // Logout button
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 40
      color: Root.Theme.background
      border.color: Root.Theme.borderColor
      border.width: Root.Theme.borderWidth
      radius: Root.Theme.borderRadius
      
      Text {
        anchors.centerIn: parent
        text: "🚪 Logout"
        color: Root.Theme.red
        font.family: Root.Theme.fontFamily
      }
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          // Execute logout command
          logoutProcess.running = true
        }
      }
    }
    
    Item { Layout.fillHeight: true }
  }
  
  Process {
    id: lockProcess
    command: ["loginctl", "lock-session"]
  }
  
  Process {
    id: logoutProcess
    command: ["loginctl", "terminate-session", "self"]
  }
}
```

### Example 3: Dropdown with Dynamic Data

```qml
import Quickshell.Io

DropdownMenu {
  id: processDropdown
  anchor.window: panel
  buttonItem: processButton
  alignment: "left"
  
  title: "Top Processes"
  dropdownWidth: 350
  dropdownHeight: 400
  
  property string processData: ""
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingSmall
    
    Text {
      text: processData || "Loading..."
      color: Root.Theme.foreground
      font.family: "monospace"
      font.pixelSize: Root.Theme.fontSizeSmall
      Layout.fillWidth: true
      wrapMode: Text.Wrap
    }
    
    Item { Layout.fillHeight: true }
  }
  
  Process {
    id: topProc
    command: ["sh", "-c", "ps aux --sort=-%mem | head -10"]
    stdout: SplitParser {
      onRead: data => {
        if (data) processData = data
      }
    }
    Component.onCompleted: running = true
  }
  
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: topProc.running = true
  }
}
```

---

## Styling

All styling is controlled through the `Theme` singleton (`Theme.qml`).

### Relevant Theme Properties

```qml
// Colors
readonly property color background: "#1a1b26"
readonly property color foreground: "#a9b1d6"
readonly property color cyan: "#0db9d7"
readonly property color borderColor: "#444b6a"

// Borders
readonly property int borderWidth: 2
readonly property int borderRadius: 8

// Spacing
readonly property int spacingSmall: 4
readonly property int spacingMedium: 8
readonly property int spacingLarge: 12

// Dropdown specific
readonly property int dropdownWidth: 280
readonly property int dropdownHeight: 300
readonly property int dropdownMargins: 16
```

To customize the appearance, edit `Theme.qml`.

---

## Best Practices

### 1. Use Button-Relative Positioning

✅ **Good:**
```qml
buttonItem: modeButton
alignment: "right"
```

❌ **Avoid:**
```qml
offsetX: panel.width - 300  // Hard to maintain
```

### 2. Use Theme Properties

✅ **Good:**
```qml
color: Root.Theme.foreground
spacing: Root.Theme.spacingMedium
```

❌ **Avoid:**
```qml
color: "#a9b1d6"  // Hard-coded color
spacing: 8        // Hard-coded spacing
```

### 3. Make Content Responsive

✅ **Good:**
```qml
content: ColumnLayout {
  anchors.fill: parent
  spacing: Root.Theme.spacingMedium
  
  // Your content
  
  Item { Layout.fillHeight: true }  // Spacer
}
```

### 4. Use Descriptive IDs

✅ **Good:**
```qml
ModeButton { id: modeButton }
ModeDropdown { id: modeDropdown }
```

❌ **Avoid:**
```qml
ModeButton { id: btn1 }
ModeDropdown { id: dd1 }
```

### 5. Close Other Dropdowns

When opening a dropdown, close others:

```qml
onToggleDropdown: {
  // Close other dropdowns
  statsDropdown.visible = false
  
  // Toggle this dropdown
  modeDropdown.visible = !modeDropdown.visible
}
```

---

## Troubleshooting

### Dropdown Not Appearing

1. Check `anchor.window: panel` is set
2. Verify `buttonItem` reference is correct
3. Check `visible` property is being toggled

### Dropdown in Wrong Position

1. Verify `buttonItem` is set correctly
2. Check `alignment` value ("left", "center", "right")
3. Try adjusting `alignmentOffset`

### Content Not Showing

1. Ensure content has proper anchors: `anchors.fill: parent`
2. Check Layout properties are set correctly
3. Verify Theme imports: `import ".." as Root`

### Styling Not Applied

1. Check Theme import: `import ".." as Root`
2. Use `Root.Theme.property` not `Theme.property`
3. Verify `qmldir` exists in root directory

---

## File Structure

```
quickshell/
├── qmldir                          # Module definition
├── Theme.qml                       # Theme singleton
├── shell.qml                       # Main panel file
└── widgets/
    ├── DropdownButton.qml          # Reusable button
    ├── DropdownMenu.qml            # Reusable dropdown
    ├── ModeButton.qml              # Mode selector button
    ├── ModeDropdown.qml            # Mode selector dropdown
    ├── StatsGroup.qml              # Stats button
    └── StatsDropdown.qml           # Stats dropdown
```

---

## API Reference

### DropdownButton API

```qml
DropdownButton {
  // Properties
  property string label: "Menu"
  property string icon: "󰅂"
  property string iconOpen: "󰅀"
  property var dropdownWindow: null
  
  // Read-only properties
  readonly property int buttonX: (calculated)
  readonly property int buttonWidth: width
  readonly property int buttonHeight: height
  
  // Signals
  signal toggleDropdown()
}
```

### DropdownMenu API

```qml
DropdownMenu {
  // Required
  anchor.window: panel
  
  // Content
  property string title: "Menu"
  property alias content: contentContainer.children
  
  // Dimensions
  property int dropdownWidth: Theme.dropdownWidth
  property int dropdownHeight: Theme.dropdownHeight
  
  // Button-relative positioning
  property var buttonItem: null
  property string alignment: "right"  // "left", "center", "right"
  property int alignmentOffset: 0
  
  // Manual positioning (legacy)
  property int offsetX: -1
  property int offsetY: panel.height - Theme.borderWidth
  
  // State
  visible: false
}
```

---

## Version History

- **v1.0** - Initial dropdown system
- **v1.1** - Added button-relative positioning
- **v1.2** - Added alignment options and offset support

---

## Contributing

When creating new dropdown widgets:

1. Extend `DropdownButton` for the button
2. Extend `DropdownMenu` for the dropdown
3. Use Theme properties for styling
4. Document your widget's specific properties
5. Add usage examples

---

## License

This dropdown system is part of the Quickshell configuration.

