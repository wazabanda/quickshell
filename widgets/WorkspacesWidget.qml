import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".." as Root

RowLayout {
  spacing: Root.Theme.spacingMedium

  // Access the focused monitor and workspace
  property var focusedMonitor: Hyprland.focusedMonitor
  property var activeWorkspace: Hyprland.focusedWorkspace
  
  // Find the activated window within that workspace
  property var focusedWindow: {
    // Try getting from focused monitor first
    if (focusedMonitor && focusedMonitor.activeWindow) {
      return focusedMonitor.activeWindow;
    }
    
    // Fallback: iterate through workspace toplevels
    if (!activeWorkspace) return null;
    for (var i = 0; i < activeWorkspace.toplevels.count; i++) {
      var tl = activeWorkspace.toplevels.get(i);
      if (tl.activated) return tl;
    }
    return null;
  }

  // Workspace indicators
  Repeater {
    model: 10
    Text {
      property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      text: isActive ? "X" : (index + 1)
      color: isActive ? Root.Theme.cyan : (ws ? Root.Theme.blue : Root.Theme.muted)
      font { pixelSize: Root.Theme.fontSize; bold: true}

      MouseArea {
        anchors.fill: parent
        onClicked: {
          Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
  }

  // Separator
  Text {
    text: "|"
    color: Root.Theme.muted
    font { pixelSize: Root.Theme.fontSize; bold: true}
  }

  // Current window title
  Text {
    id: windowTitle
    text: focusedWindow ? focusedWindow.title : ""
    color: Root.Theme.foreground
    font { pixelSize: Root.Theme.fontSize }
    
    // Limit the width to prevent the title from being too long
    Layout.maximumWidth: 400
    elide: Text.ElideRight
  }
}

