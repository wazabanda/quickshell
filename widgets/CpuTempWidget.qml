import Quickshell.Io
import QtQuick

Item {
  id: root
  
  property int cpuTemp: 0
  property color colFg: "#a9b1d6"
  property color colYellow: "#e0af68"
  property color colCyan: "#0db9d7"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

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
    if (cpuTemp >= 80) return root.colYellow
    if (cpuTemp >= 60) return root.colCyan
    return root.colFg
  }

  Text {
    id: tempText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: "󰏈 " + root.cpuTemp + "°C"
    color: getTempColor()
    font { family: root.fontFamily; pixelSize: root.fontSize }
  }
  
  implicitWidth: tempText.implicitWidth
  implicitHeight: tempText.implicitHeight
}

