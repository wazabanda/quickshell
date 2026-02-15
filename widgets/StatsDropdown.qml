import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import ".." as Root

PopupWindow {
  id: dropdown
  
  visible: false
  color: "transparent"
  
  implicitWidth: Root.Theme.dropdownWidth
  implicitHeight: Root.Theme.dropdownHeight
  
  anchor {
    rect.x: panel.width - 30
    rect.y: panel.height - Root.Theme.borderWidth
    rect.width: 0
    rect.height: 0
    
  }
  
  Rectangle {
    anchors.fill: parent
    color: Root.Theme.background
    radius: Root.Theme.borderRadius
    
    // Left border
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: Root.Theme.borderWidth
      color: Root.Theme.borderColor
    }
    
    // Right border
    Rectangle {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: Root.Theme.borderWidth
      color: Root.Theme.borderColor
    }
    
    // Bottom border
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: Root.Theme.borderWidth
      color: Root.Theme.borderColor
    }
    
    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Root.Theme.dropdownMargins
      spacing: Root.Theme.spacingXLarge
      
      // Title
      Text {
        text: "System Statistics"
        color: Root.Theme.cyan
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeLarge; bold: true }
        Layout.alignment: Qt.AlignHCenter
      }
      
      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Root.Theme.muted
      }
      
      // Stats
      ColumnLayout {
        spacing: Root.Theme.spacingXLarge
        Layout.fillWidth: true
        
        // CPU and MEM side by side
        RowLayout {
          Layout.fillWidth: true
          spacing: 60
          
          RadialBarWidget {
            id: cpuBar
            value: cpuData.cpuUsage
            label: "CPU"
          }
          
          RadialBarWidget {
            id: memBar
            value: memData.memUsage
            label: "MEM"
          }
        }
        
        // TEMP bar below
        TempBarWidget {
          id: tempBar
          value: tempData.cpuTemp
          maxValue: 100
        }
      }
      
      // Hidden widgets to get data
      CpuWidget {
        id: cpuData
        visible: false
      }
      
      MemoryWidget {
        id: memData
        visible: false
      }
      
      CpuTempWidget {
        id: tempData
        visible: false
      }
      
      Item { Layout.fillHeight: true }
    }
  }
}


