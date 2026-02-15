import Quickshell.Io
import QtQuick
import ".." as Root

Item {
  id: root
  
  property string networkStatus: "Disconnected"
  property string networkIcon: "󰤭"

  Process {
    id: networkProc
    command: ["sh", "-c", "ip route | grep default >/dev/null 2>&1 && (ip link show | grep -q 'state UP' && echo 'Connected' || echo 'Disconnected') || echo 'Disconnected'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var status = data.trim()
        networkStatus = status
        if (status === "Connected") {
          networkIcon = "󰤨"
        } else {
          networkIcon = "󰤭"
        }
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    id: procTimer
    interval: 3000
    running: true
    repeat: true
    onTriggered: {
      networkProc.running = true
    }
  }

  Text {
    id: networkText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: root.networkIcon + " " + root.networkStatus
    color: root.networkStatus === "Connected" ? Root.Theme.cyan : Root.Theme.foreground
    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
  }

  Process {
    id: openNetworkManager
    command: ["nmrs"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      openNetworkManager.running = true
    }
  }
  
  implicitWidth: networkText.implicitWidth
  implicitHeight: networkText.implicitHeight
}

