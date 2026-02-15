import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "Mode Selection"
  dropdownWidth: 280
  dropdownHeight: 200
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingLarge
    
    // Current mode display
    Text {
      text: "Current Mode: " + (currentMode === "work" ? "Work" : "Game")
      color: Root.Theme.foreground
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
      Layout.alignment: Qt.AlignHCenter
    }
    
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Root.Theme.muted
    }
    
    // Mode buttons
    ColumnLayout {
      Layout.fillWidth: true
      spacing: Root.Theme.spacingMedium
      
      // Work Mode Button
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        color: currentMode === "work" ? Root.Theme.blue : Root.Theme.background
        border.color: Root.Theme.borderColor
        border.width: Root.Theme.borderWidth
        radius: Root.Theme.borderRadius
        
        RowLayout {
          anchors.fill: parent
          anchors.margins: Root.Theme.spacingMedium
          spacing: Root.Theme.spacingMedium
          
          Text {
            text: "" // Font Awesome/FiraCode "linux" or use "󰆍" for a generic code icon
            color: currentMode === "work" ? Root.Theme.background : Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeLarge; bold: true }
          }
          
          Text {
            text: "Work Mode"
            color: currentMode === "work" ? Root.Theme.background : Root.Theme.foreground
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
            Layout.fillWidth: true
          }
        }
        
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            currentMode = "work"
            workModeProcess.running = true
          }
        }
      }
      
      // Game Mode Button
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        color: currentMode === "game" ? Root.Theme.green : Root.Theme.background
        border.color: Root.Theme.borderColor
        border.width: Root.Theme.borderWidth
        radius: Root.Theme.borderRadius
        
        RowLayout {
          anchors.fill: parent
          anchors.margins: Root.Theme.spacingMedium
          spacing: Root.Theme.spacingMedium
          
          Text {
            text: "󰊴"
            color: currentMode === "game" ? Root.Theme.background : Root.Theme.green
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeLarge; bold: true }
          }
          
          Text {
            text: "Game Mode"
            color: currentMode === "game" ? Root.Theme.background : Root.Theme.foreground
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
            Layout.fillWidth: true
          }
        }
        
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            currentMode = "game"
            gameModeProcess.running = true
          }
        }
      }
    }
    
    Item { Layout.fillHeight: true }
  }
  
  // State management
  property string currentMode: "work"
  
  // Work mode commands
  Process {
    id: workModeProcess
    command: ["sh", "-c", "echo 'Switching to Work Mode' && notify-send 'Mode Switch' 'Switched to Work Mode'"]
  }
  
  // Game mode commands
  Process {
    id: gameModeProcess
    command: ["sh", "-c", "echo 'Switching to Game Mode' && notify-send 'Mode Switch' 'Switched to Game Mode'"]
  }
}

