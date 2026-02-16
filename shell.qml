// shell.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "widgets"

ShellRoot {
  Variants {
    model: Quickshell.screens
    
    PanelWindow {
      property var modelData
      id: panel
      
      // Assign this panel to the current screen
      screen: modelData

      anchors.top: true
      anchors.left: true
      anchors.right: true
      implicitHeight: Theme.panelHeight
      color: "transparent"
      
      // Main panel container with rounded corners
      Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.borderWidth
        color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.panelOpacity)
        
        // radius: Theme.panelBorderRadius
        // border.width: Theme.borderWidth
        // border.color: Theme.borderColor
        // // Top border
        // Rectangle {
        //   anchors.top: parent.top
        //   anchors.left: parent.left
        //   anchors.right: parent.right
        //   height: Theme.borderWidth
        //   color: Theme.borderColor
        //   radius: Theme.panelBorderRadius
        // }

        // // Bottom border
        // Rectangle {
        //   anchors.bottom: parent.bottom
        //   anchors.left: parent.left
        //   anchors.right: parent.right
        //   height: Theme.borderWidth
        //   color: Theme.borderColor
        //   radius: Theme.panelBorderRadius
        // }
        
        // // Left border
        // Rectangle {
        //   anchors.left: parent.left
        //   anchors.top: parent.top
        //   anchors.bottom: parent.bottom
        //   width: Theme.borderWidth
        //   color: Theme.borderColor
        // }
        
        // // Right border
        // Rectangle {
        //   anchors.right: parent.right
        //   anchors.top: parent.top
        //   anchors.bottom: parent.bottom
        //   width: Theme.borderWidth
        //   color: Theme.borderColor
        // }

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

        // Spotify Player
        SpotifyButton {
          id: spotifyButton
          dropdownWindow: spotifyDropdown
          triggerMode: "click"  // "click" or "hover"
          hoverDelay: 200  // Delay in ms before showing on hover
          
          onToggleDropdown: {
            spotifyDropdown.visible = !spotifyDropdown.visible
          }
          
          onShowDropdown: {
            spotifyDropdown.visible = true
          }
          
          onHideDropdown: {
            spotifyDropdown.visible = false
          }
          
          SpotifyDropdown {
            id: spotifyDropdown
            anchor.window: panel
            
            // Button-relative positioning (new method)
            buttonItem: spotifyButton
            alignment: "center"  // "left", "center", or "right"
            alignmentOffset: 0  // Additional offset in pixels
            
            // Dimensions
            dropdownWidth: 350
            dropdownHeight: 400
            
            // Manual positioning (legacy, comment out when using buttonItem)
            // offsetX: panel.width - 600
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
      
         // Clock with calendar dropdown
        ClockWidget {
          id: clockWidget
          dropdownWindow: calendarDropdown
          triggerMode: "hover"  // "click" or "hover"
          hoverDelay: 200  // Delay in ms before showing on hover
          
          onToggleDropdown: {
            calendarDropdown.visible = !calendarDropdown.visible
          }
          
          onShowDropdown: {
            calendarDropdown.visible = true
          }
          
          onHideDropdown: {
            calendarDropdown.visible = false
          }
          
          CalendarDropdown {
            id: calendarDropdown
            anchor.window: panel
            
            // Button-relative positioning
            buttonItem: clockWidget
            alignment: "center"  // "left", "center", or "right"
            alignmentOffset: 0  // Additional offset in pixels
            
            // Dimensions
            dropdownWidth: 350
            dropdownHeight: 380
          }
        }

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
  }
}
