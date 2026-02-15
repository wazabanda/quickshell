import Quickshell.Io
import QtQuick
import ".." as Root

Item {
  id: root
  
  property int memUsage: 0

  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem"]
    stdout: SplitParser {
        onRead: data => {
            if (!data) return
            var parts = data.trim().split(/\s+/)
            var total = parseInt(parts[1]) || 1
            var used = parseInt(parts[2]) || 0
            memUsage = Math.round(100 * used / total)
        }
    }
    Component.onCompleted: running = true
  }

  Timer {
    id: procTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      memProc.running = true
    }
  }

  Text {
    id: memText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: "Memory: " + root.memUsage + "%"
    color: Root.Theme.foreground
    font { pixelSize: Root.Theme.fontSize }
  }
  
  implicitWidth: memText.implicitWidth
  implicitHeight: memText.implicitHeight
}

