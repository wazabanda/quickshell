# Dropdown System - Quick Reference

## TL;DR - Create a Dropdown in 3 Steps

### 1. Create Button Widget
```qml
// widgets/MyButton.qml
import QtQuick
import ".." as Root

DropdownButton {
  label: "My Menu"
  icon: "󰐾"
  iconOpen: "󰐽"
}
```

### 2. Create Dropdown Widget
```qml
// widgets/MyDropdown.qml
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  title: "My Dropdown"
  dropdownWidth: 280
  dropdownHeight: 300
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingLarge
    
    Text {
      text: "Your content here"
      color: Root.Theme.foreground
      font.family: Root.Theme.fontFamily
    }
    
    Item { Layout.fillHeight: true }
  }
}
```

### 3. Add to Panel
```qml
// shell.qml
MyButton {
  id: myButton
  dropdownWindow: myDropdown
  onToggleDropdown: { myDropdown.visible = !myDropdown.visible }
  
  MyDropdown {
    id: myDropdown
    anchor.window: panel
    buttonItem: myButton
    alignment: "right"
  }
}
```

---

## Positioning Cheat Sheet

### Alignment Options

```qml
alignment: "left"    // ⬅️ Left edge aligned
alignment: "center"  // ⬅️➡️ Centered
alignment: "right"   // ➡️ Right edge aligned (default)
```

### Visual Guide

```
Button: [====]

"left":
[Dropdown====]
[====]

"center":
  [Dropdown====]
  [====]

"right":
      [Dropdown====]
      [====]
```

### Fine-Tuning Position

```qml
alignmentOffset: 10   // Move 10px right ➡️
alignmentOffset: -10  // Move 10px left ⬅️
alignmentOffset: 0    // No offset (default)
```

---

## Common Patterns

### Pattern 1: Simple Text Dropdown
```qml
content: ColumnLayout {
  anchors.fill: parent
  spacing: Root.Theme.spacingMedium
  
  Text {
    text: "Line 1"
    color: Root.Theme.foreground
    font.family: Root.Theme.fontFamily
  }
  
  Text {
    text: "Line 2"
    color: Root.Theme.foreground
    font.family: Root.Theme.fontFamily
  }
  
  Item { Layout.fillHeight: true }
}
```

### Pattern 2: Button List
```qml
content: ColumnLayout {
  anchors.fill: parent
  spacing: Root.Theme.spacingMedium
  
  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    color: Root.Theme.background
    border.color: Root.Theme.borderColor
    border.width: Root.Theme.borderWidth
    radius: Root.Theme.borderRadius
    
    Text {
      anchors.centerIn: parent
      text: "Button 1"
      color: Root.Theme.foreground
    }
    
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: { /* action */ }
    }
  }
  
  Item { Layout.fillHeight: true }
}
```

### Pattern 3: Toggle Buttons (Mode Selector)
```qml
content: ColumnLayout {
  anchors.fill: parent
  spacing: Root.Theme.spacingMedium
  
  property string currentMode: "mode1"
  
  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    color: currentMode === "mode1" ? Root.Theme.blue : Root.Theme.background
    border.color: Root.Theme.borderColor
    border.width: Root.Theme.borderWidth
    radius: Root.Theme.borderRadius
    
    Text {
      anchors.centerIn: parent
      text: "Mode 1"
      color: currentMode === "mode1" ? Root.Theme.background : Root.Theme.foreground
    }
    
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: { currentMode = "mode1" }
    }
  }
  
  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    color: currentMode === "mode2" ? Root.Theme.green : Root.Theme.background
    border.color: Root.Theme.borderColor
    border.width: Root.Theme.borderWidth
    radius: Root.Theme.borderRadius
    
    Text {
      anchors.centerIn: parent
      text: "Mode 2"
      color: currentMode === "mode2" ? Root.Theme.background : Root.Theme.foreground
    }
    
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: { currentMode = "mode2" }
    }
  }
  
  Item { Layout.fillHeight: true }
}
```

### Pattern 4: With Process Execution
```qml
import Quickshell.Io

DropdownMenu {
  // ... other properties ...
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 40
      color: Root.Theme.background
      border.color: Root.Theme.borderColor
      border.width: Root.Theme.borderWidth
      radius: Root.Theme.borderRadius
      
      Text {
        anchors.centerIn: parent
        text: "Run Command"
        color: Root.Theme.foreground
      }
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: { myProcess.running = true }
      }
    }
    
    Item { Layout.fillHeight: true }
  }
  
  Process {
    id: myProcess
    command: ["sh", "-c", "notify-send 'Hello' 'World'"]
  }
}
```

### Pattern 5: With Dynamic Data
```qml
import Quickshell.Io

DropdownMenu {
  // ... other properties ...
  
  property string dynamicData: "Loading..."
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    Text {
      text: dynamicData
      color: Root.Theme.foreground
      font.family: Root.Theme.fontFamily
      Layout.fillWidth: true
    }
    
    Item { Layout.fillHeight: true }
  }
  
  Process {
    id: dataProc
    command: ["sh", "-c", "date"]
    stdout: SplitParser {
      onRead: data => {
        if (data) dynamicData = data
      }
    }
    Component.onCompleted: running = true
  }
  
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dataProc.running = true
  }
}
```

---

## Property Quick Reference

### DropdownButton
```qml
DropdownButton {
  label: "Text"              // Button label
  icon: "󰐾"                  // Icon when closed
  iconOpen: "󰐽"              // Icon when open
  dropdownWindow: dropdown   // Reference to dropdown
}
```

### DropdownMenu
```qml
DropdownMenu {
  // Required
  anchor.window: panel
  
  // Positioning
  buttonItem: button         // Button reference
  alignment: "right"         // "left", "center", "right"
  alignmentOffset: 0         // Additional offset (px)
  
  // Dimensions
  dropdownWidth: 280
  dropdownHeight: 300
  
  // Content
  title: "Title"
  content: ColumnLayout { }
}
```

---

## Theme Properties

```qml
// Colors
Root.Theme.background      // #1a1b26
Root.Theme.foreground      // #a9b1d6
Root.Theme.cyan           // #0db9d7
Root.Theme.blue           // #7aa2f7
Root.Theme.green          // #9ece6a
Root.Theme.yellow         // #e0af68
Root.Theme.red            // #f7768e
Root.Theme.orange         // #ff9e64
Root.Theme.muted          // #444b6a

// Borders
Root.Theme.borderWidth    // 2
Root.Theme.borderColor    // #444b6a
Root.Theme.borderRadius   // 8

// Spacing
Root.Theme.spacingSmall   // 4
Root.Theme.spacingMedium  // 8
Root.Theme.spacingLarge   // 12
Root.Theme.spacingXLarge  // 16

// Typography
Root.Theme.fontFamily     // "JetBrainsMono Nerd Font"
Root.Theme.fontSize       // 14
Root.Theme.fontSizeSmall  // 12
Root.Theme.fontSizeLarge  // 16
```

---

## Common Icons (Nerd Fonts)

```
󰐾 󰐽  Settings/Config
󰅂 󰅀  Chevron down/up
󰖳    Briefcase (Work)
󰊴    Game controller
󰋼 󰋽  Info
🔒    Lock
🚪    Door/Logout
⚙️    Gear
📊    Chart/Stats
🎮    Game
💼    Work
🌐    Network
🔊    Volume
🔋    Battery
🕐    Clock
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Dropdown not appearing | Check `anchor.window: panel` and `buttonItem` |
| Wrong position | Verify `alignment` and try adjusting `alignmentOffset` |
| Content not showing | Ensure `anchors.fill: parent` on content |
| Styling not working | Import Theme: `import ".." as Root` |
| Button not clickable | Check `onToggleDropdown` handler exists |

---

## Example: Complete Dropdown

```qml
// widgets/QuickActionsButton.qml
import QtQuick
import ".." as Root

DropdownButton {
  label: "Actions"
  icon: "⚙️"
  iconOpen: "⚙️"
}

// widgets/QuickActionsDropdown.qml
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  title: "Quick Actions"
  dropdownWidth: 250
  dropdownHeight: 200
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 40
      color: Root.Theme.background
      border.color: Root.Theme.borderColor
      border.width: Root.Theme.borderWidth
      radius: Root.Theme.borderRadius
      
      Text {
        anchors.centerIn: parent
        text: "🔒 Lock"
        color: Root.Theme.foreground
        font.family: Root.Theme.fontFamily
      }
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: lockProc.running = true
      }
    }
    
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
        onClicked: logoutProc.running = true
      }
    }
    
    Item { Layout.fillHeight: true }
  }
  
  Process {
    id: lockProc
    command: ["loginctl", "lock-session"]
  }
  
  Process {
    id: logoutProc
    command: ["loginctl", "terminate-session", "self"]
  }
}

// shell.qml
QuickActionsButton {
  id: actionsButton
  dropdownWindow: actionsDropdown
  onToggleDropdown: { actionsDropdown.visible = !actionsDropdown.visible }
  
  QuickActionsDropdown {
    id: actionsDropdown
    anchor.window: panel
    buttonItem: actionsButton
    alignment: "center"
  }
}
```

---

For full documentation, see `DROPDOWN_SYSTEM.md`

