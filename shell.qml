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

        // Separator {}
        
        // Mode selector (Work/Game)
        Rectangle {
          color: Qt.rgba(Theme.widgetModeBackground.r, Theme.widgetModeBackground.g, Theme.widgetModeBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: modeButton.implicitWidth + Theme.spacingMedium * 2
          
          ModeButton {
            id: modeButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
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
        }

        // Separator {}

        // Spotify Player
        Rectangle {
          color: Qt.rgba(Theme.widgetSpotifyBackground.r, Theme.widgetSpotifyBackground.g, Theme.widgetSpotifyBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: spotifyButton.implicitWidth + Theme.spacingMedium * 2
          
          SpotifyButton {
            id: spotifyButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
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
        }

        // Separator {}

        // Network
        Rectangle {
          color: Qt.rgba(Theme.widgetNetworkBackground.r, Theme.widgetNetworkBackground.g, Theme.widgetNetworkBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: networkWidget.implicitWidth + Theme.spacingMedium * 2
          
          NetworkWidget {
            id: networkWidget
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
          }
        }

        // Separator {}

        // Volume
        Rectangle {
          color: Qt.rgba(Theme.widgetVolumeBackground.r, Theme.widgetVolumeBackground.g, Theme.widgetVolumeBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: volumeWidget.implicitWidth + Theme.spacingMedium * 2
          
          VolumeWidget {
            id: volumeWidget
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
          }
        }

        // Separator {}
      
        // Battery
        Rectangle {
          color: Qt.rgba(Theme.widgetBatteryBackground.r, Theme.widgetBatteryBackground.g, Theme.widgetBatteryBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: batteryWidget.implicitWidth + Theme.spacingMedium * 2
          
          BatteryWidget {
            id: batteryWidget
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
          }
        }

        // Separator {}
      
         // Clock with calendar dropdown
        Rectangle {
          color: Qt.rgba(Theme.widgetClockBackground.r, Theme.widgetClockBackground.g, Theme.widgetClockBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: clockWidget.implicitWidth + Theme.spacingMedium * 2
          
          ClockWidget {
            id: clockWidget
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
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
              dropdownWidth: 400
              dropdownHeight: 600
            }
          }
        }

        // Separator {}
        
        // Stats Group (CPU, Temp, Memory)
        Rectangle {
          color: Qt.rgba(Theme.widgetStatsBackground.r, Theme.widgetStatsBackground.g, Theme.widgetStatsBackground.b, Theme.widgetBackgroundOpacity)
          // radius: 4
          Layout.preferredHeight: parent.height
          Layout.preferredWidth: statsGroup.implicitWidth + Theme.spacingMedium * 2
          
          StatsGroup {
            id: statsGroup
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.spacingMedium
            anchors.rightMargin: Theme.spacingMedium
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
        }
        
        Separator {}
      }
    }
    }
  }
}
