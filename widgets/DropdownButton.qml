import QtQuick
import QtQuick.Layouts
import ".." as Root

Item {
  id: root
  
  property string label: "Menu"
  property string icon: "󰅂"
  property string iconOpen: "󰅀"
  property var dropdownWindow: null
  
  signal toggleDropdown()
  
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

    // Make whole row clickable
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        root.toggleDropdown()
      }
      hoverEnabled: true
    }
  }
}

