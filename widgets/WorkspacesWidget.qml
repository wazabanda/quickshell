import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".." as Root

RowLayout {
  spacing: Root.Theme.spacingMedium

  Repeater {
    model: 10
    Text {
      property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      text: index + 1
      color: isActive ? Root.Theme.cyan : (ws ? Root.Theme.blue : Root.Theme.muted)
      font { pixelSize: Root.Theme.fontSize; bold: true}

      MouseArea {
        anchors.fill: parent
        onClicked: {
          Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
  }
}

