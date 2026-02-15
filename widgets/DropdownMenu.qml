import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import ".." as Root

PopupWindow {
  id: dropdown
  
  property string title: "Menu"
  property int dropdownWidth: Root.Theme.dropdownWidth
  property int dropdownHeight: Root.Theme.dropdownHeight
  
  // Manual offset mode (legacy)
  property int offsetX: -1
  property int offsetY: panel.height - Root.Theme.borderWidth
  
  // Button-relative positioning (new)
  property var buttonItem: null
  property string alignment: "right"  // "left", "center", "right"
  property int alignmentOffset: 0  // Additional offset after alignment
  
  property alias content: contentContainer.children
  
  // Hover tracking for hover mode
  property bool isHovered: false
  
  visible: false
  color: "transparent"
  
  implicitWidth: dropdownWidth
  implicitHeight: dropdownHeight
  
  // Calculate final X position
  readonly property int finalX: {
    if (offsetX >= 0) {
      // Manual mode
      return offsetX
    } else if (buttonItem) {
      // Button-relative mode
      var buttonX = buttonItem.buttonX
      var buttonWidth = buttonItem.buttonWidth
      
      if (alignment === "left") {
        return buttonX + alignmentOffset
      } else if (alignment === "center") {
        return buttonX + (buttonWidth / 2) - (dropdownWidth / 2) + alignmentOffset
      } else { // "right"
        return buttonX + buttonWidth - dropdownWidth + alignmentOffset
      }
    } else {
      // Fallback to right side of panel
      return panel.width - 30
    }
  }
  
  anchor {
    rect.x: finalX
    rect.y: offsetY
    rect.width: 0
    rect.height: 0
  }
  
  Rectangle {
    anchors.fill: parent
    color: Root.Theme.background
    radius: Root.Theme.borderRadius
    
    // Track hover state for hover mode
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      propagateComposedEvents: true
      
      onEntered: {
        dropdown.isHovered = true
      }
      
      onExited: {
        dropdown.isHovered = false
      }
      
      onClicked: mouse.accepted = false
      onPressed: mouse.accepted = false
      onReleased: mouse.accepted = false
    }
    
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
        text: dropdown.title
        color: Root.Theme.cyan
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeLarge; bold: true }
        Layout.alignment: Qt.AlignHCenter
      }
      
      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Root.Theme.muted
      }
      
      // Content container for custom children
      Item {
        id: contentContainer
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }
}

