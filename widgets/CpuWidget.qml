import Quickshell.Io
import QtQuick

Item {
  id: root
  
  property int cpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0
  property color colFg: "#a9b1d6"
  property int fontSize: 14

  Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser{
      onRead: data => {
        if(!data) return
        var p = data.trim().split(/\s+/)
        var idle = parseInt(p[4]) + parseInt(p[5])
        var total = p.slice(1,8).reduce((a, b) => a + parseInt(b), 0)
        if(lastCpuTotal > 0){
          cpuUsage = Math.round(100 * (1 - (idle -lastCpuIdle)/(total-lastCpuTotal)))
        }
        lastCpuIdle = idle
        lastCpuTotal = total
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
      cpuProc.running = true
    }
  }

  Text {
    id: cpuText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: "CPU: " + root.cpuUsage + "%"
    color: root.colFg
    font { pixelSize: root.fontSize }
  }
  
  implicitWidth: cpuText.implicitWidth
  implicitHeight: cpuText.implicitHeight
}

