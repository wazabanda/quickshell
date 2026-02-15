import Quickshell.Io
import QtQuick

Item {
  id: root
  
  property int batteryPercent: 0
  property string batteryStatus: "Unknown"
  property bool isCharging: false
  property color colFg: "#a9b1d6"
  property color colCyan: "#0db9d7"
  property color colYellow: "#e0af68"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  Process {
    id: batteryProc
    command: ["sh", "-c", "if [ -f /sys/class/power_supply/BAT0/capacity ]; then cat /sys/class/power_supply/BAT0/capacity; else echo '0'; fi"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        batteryPercent = parseInt(data.trim()) || 0
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: batteryStatusProc
    command: ["sh", "-c", "if [ -f /sys/class/power_supply/BAT0/status ]; then cat /sys/class/power_supply/BAT0/status; else echo 'Unknown'; fi"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        batteryStatus = data.trim()
        isCharging = (batteryStatus === "Charging")
      }
    }
    Component.onCompleted: running = true
  }

  function getBatteryIcon(percent, charging) {
    if (charging) {
      if (percent >= 90) return "󰂅"
      if (percent >= 80) return "󰂋"
      if (percent >= 60) return "󰂊"
      if (percent >= 40) return "󰂉"
      if (percent >= 20) return "󰂈"
      return "󰂇"
    } else {
      if (percent >= 90) return "󰂄"
      if (percent >= 80) return "󰂃"
      if (percent >= 60) return "󰂂"
      if (percent >= 40) return "󰂁"
      if (percent >= 20) return "󰂀"
      if (percent >= 10) return "󰁿"
      return "󰁺"
    }
  }

  Timer {
    id: procTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      batteryProc.running = true
      batteryStatusProc.running = true
    }
  }

  Text {
    id: batteryText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: getBatteryIcon(root.batteryPercent, root.isCharging) + " " + root.batteryPercent + "%"
    color: root.batteryPercent < 20 ? root.colYellow : (root.isCharging ? root.colCyan : root.colFg)
    font { family: root.fontFamily; pixelSize: root.fontSize }
  }
  
  implicitWidth: batteryText.implicitWidth
  implicitHeight: batteryText.implicitHeight
}

