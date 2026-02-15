// shell.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "widgets"

PanelWindow {
  id: root
  
  // Theme properties
  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 32
  color: root.colBg


  RowLayout {
    anchors.fill: parent
    anchors.margins: 8
    spacing: 12

    // Workspaces
    WorkspacesWidget {}

    Item { Layout.fillWidth: true}



    Separator { separatorColor: root.colMuted }

    // Network
    NetworkWidget {
      colFg: root.colFg
      colCyan: root.colCyan
      fontFamily: root.fontFamily
      fontSize: root.fontSize
    }

    Separator { separatorColor: root.colMuted }

    // Volume
    VolumeWidget {
      colFg: root.colFg
      colYellow: root.colYellow
      fontFamily: root.fontFamily
      fontSize: root.fontSize
    }

    Separator { separatorColor: root.colMuted }
  
    // Battery
    BatteryWidget {
      colFg: root.colFg
      colCyan: root.colCyan
      colYellow: root.colYellow
      fontFamily: root.fontFamily
      fontSize: root.fontSize
    }

    Separator { separatorColor: root.colMuted }
  
    // Clock 
    ClockWidget {
      colBlue: root.colBlue
      fontFamily: root.fontFamily
      fontSize: root.fontSize
    }

    Separator { separatorColor: root.colMuted }
        // Stats Group (CPU, Temp, Memory)
    StatsGroup {
      colFg: root.colFg
      colCyan: root.colCyan
      colYellow: root.colYellow
      colMuted: root.colMuted
      fontFamily: root.fontFamily
      fontSize: root.fontSize
    }
       Separator { separatorColor: root.colMuted; separatorWidth: 5; separatorHeight: 16 }
  }
}
