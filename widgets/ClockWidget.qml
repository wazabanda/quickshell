import Quickshell.Io
import QtQuick
import ".." as Root

Item {
  id: root

  Text {
    id: clock
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: Root.Theme.blue
    font {family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true}
    text: Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm:ss")

    Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: {
        clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm:ss")
      }
    }
  }

  Process {
    id: openCalendar
    command: ["sh", "-c", "which gnome-calendar >/dev/null 2>&1 && gnome-calendar || which khal >/dev/null 2>&1 && khal interactive || which cal >/dev/null 2>&1 && (alacritty -e cal || kitty -e cal || xterm -e cal || cal) || echo Calendar not found"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      openCalendar.running = true
    }
  }
  
  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight
}

