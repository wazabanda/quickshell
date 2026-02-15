import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PopupWindow {
  id: dropdown
  
  property color colFg: "#a9b1d6"
  property color colCyan: "#0db9d7"
  property color colYellow: "#e0af68"
  property color colMuted: "#444b6a"
  property color colBg: "#1a1b26"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14
  property int borderWidth: 2
  property color borderColor: dropdown.colMuted
  
  visible: false
  color: "transparent"
  
  implicitWidth: 300
  implicitHeight: 200
  
  anchor {
    rect.x: panel.width - 30
    rect.y: panel.height - dropdown.borderWidth
    rect.width: 0
    rect.height: 0
    
  }
  
  Rectangle {
    anchors.fill: parent
    color: dropdown.colBg
    radius: 2
    // Left border
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: dropdown.borderWidth
      color: dropdown.borderColor
    }
    
    // Right border
    Rectangle {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: dropdown.borderWidth
      color: dropdown.borderColor
    }
    
    // Bottom border
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: dropdown.borderWidth
      color: dropdown.borderColor
    }
    
    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 16
      
      // Title
      Text {
        text: "System Statistics"
        color: dropdown.colCyan
        font { family: dropdown.fontFamily; pixelSize: dropdown.fontSize + 2; bold: true }
        Layout.alignment: Qt.AlignHCenter
      }
      
      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: dropdown.colMuted
      }
      
      // Stats
      ColumnLayout {
        spacing: 12
        Layout.fillWidth: true
        
        CpuWidget {
          colFg: dropdown.colFg
          fontSize: dropdown.fontSize
        }
        
        CpuTempWidget {
          colFg: dropdown.colFg
          colCyan: dropdown.colCyan
          colYellow: dropdown.colYellow
          fontFamily: dropdown.fontFamily
          fontSize: dropdown.fontSize
        }
        
        MemoryWidget {
          colFg: dropdown.colFg
          fontSize: dropdown.fontSize
        }
      }
      
      Item { Layout.fillHeight: true }
    }
  }
}


