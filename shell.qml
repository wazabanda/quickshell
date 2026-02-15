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
      
      // Mode selector (Work/Game)
      ModeButton {
        id: modeButton
        dropdownWindow: modeDropdown
        triggerMode: "hover"  // "click" or "hover"
        hoverDelay: 200  // Delay in ms before showing on hover
        
        onToggleDropdown: {
          modeDropdown.visible = !modeDropdown.visible
        }
        
        onShowDropdown: {
          modeDropdown.visible = true
        }
        
        onHideDropdown: {
          modeDropdown.visible = false
        }
        
        ModeDropdown {
          id: modeDropdown
          anchor.window: panel
          
          // Button-relative positioning (new method)
          buttonItem: modeButton
          alignment: "right"  // "left", "center", or "right"
          alignmentOffset: 0  // Additional offset in pixels
          
          // Dimensions
          dropdownWidth: 280
          dropdownHeight: 350
          
          // Manual positioning (legacy, comment out when using buttonItem)
          // offsetX: panel.width - 750
          // offsetY: panel.height - Theme.borderWidth
        }
      }

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
        triggerMode: "hover"  // "click" or "hover"
        hoverDelay: 200  // Delay in ms before showing on hover
        
        onToggleDropdown: {
          statsDropdown.visible = !statsDropdown.visible
        }
        
        onShowDropdown: {
          statsDropdown.visible = true
        }
        
        onHideDropdown: {
          statsDropdown.visible = false
        }
        
        // Stats dropdown window (child of StatsGroup)
        StatsDropdown {
          id: statsDropdown
          anchor.window: panel
          
          // Button-relative positioning (new method)
          buttonItem: statsGroup
          alignment: "right"  // "left", "center", or "right"
          alignmentOffset: 0  // Additional offset in pixels
          
          // Dimensions
          dropdownWidth: 280
          dropdownHeight: 300
          
          // Manual positioning (legacy, comment out when using buttonItem)
          // offsetX: panel.width - 30
          // offsetY: panel.height - Theme.borderWidth
        }
      }
      
      Separator {}
    }
  }
}
