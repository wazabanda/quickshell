import QtQuick
import QtQuick.Layouts

Item {
  id: root
  
  property color colFg: "#a9b1d6"
  property color colCyan: "#0db9d7"
  property color colYellow: "#e0af68"
  property color colMuted: "#444b6a"
  property color colBg: "#1a1b26"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14
  property var dropdownWindow: null
  
  signal toggleDropdown()
  
  implicitWidth: statsLayout.implicitWidth
  implicitHeight: statsLayout.implicitHeight

  // Toggle button and label in the panel
  RowLayout {
    id: statsLayout
    anchors.fill: parent
    spacing: 12

    // Toggle button
    Text {
      id: toggleButton
      text: (root.dropdownWindow && root.dropdownWindow.visible) ? "󰅀" : "󰅂"
      color: root.colCyan
      font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    }

    // Label
    Text {
      id: statsLabel
      text: "Stats"
      color: root.colFg
      font { family: root.fontFamily; pixelSize: root.fontSize }
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

