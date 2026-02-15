import QtQuick
import QtQuick.Layouts
import ".." as Root

Item {
  id: root
  
  property string label: "Menu"
  property string icon: "󰅂"
  property string iconOpen: "󰅀"
  property var dropdownWindow: null
  property string triggerMode: "click"  // "click" or "hover"
  property int hoverDelay: 200  // Delay in ms before showing on hover
  
  signal toggleDropdown()
  signal showDropdown()
  signal hideDropdown()
  
  implicitWidth: buttonLayout.implicitWidth
  implicitHeight: buttonLayout.implicitHeight
  
  // Expose position for dropdown positioning
  readonly property int buttonX: {
    var item = root
    var x = 0
    while (item && item.parent) {
      x += item.x
      item = item.parent
      if (item.objectName === "panel") break
    }
    return x
  }
  
  readonly property int buttonWidth: width
  readonly property int buttonHeight: height

  // Toggle button and label in the panel
  RowLayout {
    id: buttonLayout
    anchors.fill: parent
    spacing: Root.Theme.spacingLarge

    // Toggle button
    Text {
      id: toggleButton
      text: (root.dropdownWindow && root.dropdownWindow.visible) ? root.iconOpen : root.icon
      color: Root.Theme.cyan
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
    }

    // Label
    Text {
      id: buttonLabel
      text: root.label
      color: Root.Theme.foreground
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
    }

    // Make whole row clickable/hoverable
    MouseArea {
      id: mouseArea
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      
      onClicked: {
        if (root.triggerMode === "click") {
          root.toggleDropdown()
        }
      }
      
      onEntered: {
        if (root.triggerMode === "hover") {
          checkAndHide.stop()
          hoverTimer.start()
        }
      }
      
      onExited: {
        if (root.triggerMode === "hover") {
          hoverTimer.stop()
          // Start checking if we should hide
          checkAndHide.start()
        }
      }
    }
    
    // Timer for hover delay
    Timer {
      id: hoverTimer
      interval: root.hoverDelay
      onTriggered: {
        root.showDropdown()
      }
    }
    
    // Timer for checking if we should hide
    Timer {
      id: checkAndHide
      interval: 100
      repeat: true
      onTriggered: {
        if (root.dropdownWindow && root.dropdownWindow.visible) {
          // Check if mouse is in button or dropdown
          if (!mouseArea.containsMouse && !root.dropdownWindow.isHovered) {
            stop()
            root.hideDropdown()
          }
        } else {
          stop()
        }
      }
    }
  }
}

