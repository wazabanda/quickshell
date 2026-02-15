import QtQuick
import QtQuick.Layouts

Item {
  id: root
  
  property color colFg: "#a9b1d6"
  property color colCyan: "#0db9d7"
  property color colYellow: "#e0af68"
  property color colMuted: "#444b6a"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14
  property bool expanded: false
  
  implicitWidth: statsLayout.implicitWidth
  implicitHeight: statsLayout.implicitHeight
  
  RowLayout {
    id: statsLayout
    anchors.fill: parent
    spacing: 12
    
    // Toggle button
    Text {
      id: toggleButton
      text: root.expanded ? "󰅀" : "󰅂"
      color: root.colCyan
      font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
      
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          root.expanded = !root.expanded
        }
      }
    }
    
    // Label when collapsed
    Text {
      visible: !root.expanded
      text: "Stats"
      color: root.colFg
      font { family: root.fontFamily; pixelSize: root.fontSize }
    }
    
    // Expanded content
    RowLayout {
      visible: root.expanded
      spacing: 12
      
      CpuWidget {
        colFg: root.colFg
        fontSize: root.fontSize
      }
      
      Separator { separatorColor: root.colMuted }
      
      CpuTempWidget {
        colFg: root.colFg
        colCyan: root.colCyan
        colYellow: root.colYellow
        fontFamily: root.fontFamily
        fontSize: root.fontSize
      }
      
      Separator { separatorColor: root.colMuted }
      
      MemoryWidget {
        colFg: root.colFg
        fontSize: root.fontSize
      }
    }
  }
}

