import Quickshell.Io
import QtQuick
import ".." as Root

Item {
  id: root
  
  property int cpuTemp: 0

  Process {
    id: tempProc
    command: ["sh", "-c", "for zone in /sys/class/thermal/thermal_zone*/temp; do if [ -f \"$zone\" ]; then cat \"$zone\"; break; fi; done"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        // Temperature is in millidegrees, convert to Celsius
        cpuTemp = Math.round(parseInt(data.trim()) / 1000)
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
      tempProc.running = true
    }
  }

  function getTempColor() {
    if (cpuTemp >= 80) return Root.Theme.yellow
    if (cpuTemp >= 60) return Root.Theme.cyan
    return Root.Theme.foreground
  }

  Text {
    id: tempText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: "󰏈 " + root.cpuTemp + "°C"
    color: getTempColor()
    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
  }
  
  implicitWidth: tempText.implicitWidth
  implicitHeight: tempText.implicitHeight
}

