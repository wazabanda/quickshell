import QtQuick
import QtQuick.Layouts
import ".." as Root

Item {
  id: root
  
  property var dropdownWindow: null
  
  signal toggleDropdown()
  
  implicitWidth: statsLayout.implicitWidth
  implicitHeight: statsLayout.implicitHeight

  // Toggle button and label in the panel
  RowLayout {
    id: statsLayout
    anchors.fill: parent
    spacing: Root.Theme.spacingLarge

    // Toggle button
    Text {
      id: toggleButton
      text: (root.dropdownWindow && root.dropdownWindow.visible) ? "󰅀" : "󰅂"
      color: Root.Theme.cyan
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
    }

    // Label
    Text {
      id: statsLabel
      text: "Stats"
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
      // Allow events to pass through to underlying items for hover and cursor feedback
      hoverEnabled: true
    }
  }
}

