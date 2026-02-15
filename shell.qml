// shell.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "widgets"

ShellRoot {
  PanelWindow {
    id: panel
    
    // Theme properties
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14
    property int borderWidth: 2
    property color borderColor: panel.colMuted

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 32
    color: panel.colBg

    // Bottom border
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: panel.borderWidth
      color: panel.borderColor
    }

    RowLayout {
      anchors.fill: parent
      anchors.margins: 8
      spacing: 12

      // Workspaces
      WorkspacesWidget {}

      Item { Layout.fillWidth: true}

      Separator { separatorColor: panel.colMuted }

      // Network
      NetworkWidget {
        colFg: panel.colFg
        colCyan: panel.colCyan
        fontFamily: panel.fontFamily
        fontSize: panel.fontSize
      }

      Separator { separatorColor: panel.colMuted }

      // Volume
      VolumeWidget {
        colFg: panel.colFg
        colYellow: panel.colYellow
        fontFamily: panel.fontFamily
        fontSize: panel.fontSize
      }

      Separator { separatorColor: panel.colMuted }
    
      // Battery
      BatteryWidget {
        colFg: panel.colFg
        colCyan: panel.colCyan
        colYellow: panel.colYellow
        fontFamily: panel.fontFamily
        fontSize: panel.fontSize
      }

      Separator { separatorColor: panel.colMuted }
    
      // Clock 
      ClockWidget {
        colBlue: panel.colBlue
        fontFamily: panel.fontFamily
        fontSize: panel.fontSize
      }

      Separator { separatorColor: panel.colMuted }
      
      // Stats Group (CPU, Temp, Memory)
      StatsGroup {
        id: statsGroup
        colFg: panel.colFg
        colCyan: panel.colCyan
        colYellow: panel.colYellow
        colMuted: panel.colMuted
        colBg: panel.colBg
        fontFamily: panel.fontFamily
        fontSize: panel.fontSize
        dropdownWindow: statsDropdown
        
        onToggleDropdown: {
          statsDropdown.visible = !statsDropdown.visible
        }
        
        // Stats dropdown window (child of StatsGroup)
        StatsDropdown {
          id: statsDropdown
          anchor.window: panel
          colFg: panel.colFg
          colCyan: panel.colCyan
          colYellow: panel.colYellow
          colMuted: panel.colMuted
          colBg: panel.colBg
          fontFamily: panel.fontFamily
          fontSize: panel.fontSize
          borderWidth: panel.borderWidth
          borderColor: panel.borderColor
        }
      }
      
      Separator { separatorColor: panel.colMuted }
    }
  }
}
