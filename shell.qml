// shell.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "widgets"

ShellRoot {
  PanelWindow {
    id: panel

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: Theme.panelHeight
    color: Theme.background

    // Bottom border
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: Theme.borderWidth
      color: Theme.borderColor
    }

    RowLayout {
      anchors.fill: parent
      anchors.margins: Theme.panelMargins
      spacing: Theme.spacingLarge

      // Workspaces
      WorkspacesWidget {}

      Item { Layout.fillWidth: true}

      Separator {}

      // Network
      NetworkWidget {}

      Separator {}

      // Volume
      VolumeWidget {}

      Separator {}
    
      // Battery
      BatteryWidget {}

      Separator {}
    
      // Clock 
      ClockWidget {}

      Separator {}
      
      // Stats Group (CPU, Temp, Memory)
      StatsGroup {
        id: statsGroup
        dropdownWindow: statsDropdown
        
        onToggleDropdown: {
          statsDropdown.visible = !statsDropdown.visible
        }
        
        // Stats dropdown window (child of StatsGroup)
        StatsDropdown {
          id: statsDropdown
          anchor.window: panel
        }
      }
      
      Separator {}
    }
  }
}
