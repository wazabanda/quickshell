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
  implicitHeight: 30
  color: root.colBg

  RowLayout {
    anchors.fill: parent
    anchors.margins: 8
    spacing: 12

    // Workspaces
    WorkspacesWidget {}

    Item { Layout.fillWidth: true}

    // CPU
    CpuWidget {
      colFg: root.colFg
      fontSize: root.fontSize
    }

    Separator { separatorColor: root.colMuted }

    // Memory
    MemoryWidget {
      colFg: root.colFg
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
  }
}
