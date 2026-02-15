import Quickshell.Io
import QtQuick

Item {
  id: root
  
  property int volumePercent: 0
  property bool isMuted: false
  property string volumeIcon: "󰕾"
  property color colFg: "#a9b1d6"
  property color colYellow: "#e0af68"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  Process {
    id: volumeProc
    command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1 | sed 's/%//'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        volumePercent = parseInt(data.trim()) || 0
        updateIcon()
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: muteProc
    command: ["sh", "-c", "pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'Mute: \\K\\w+'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        isMuted = (data.trim() === "yes")
        updateIcon()
      }
    }
    Component.onCompleted: running = true
  }

  function updateIcon() {
    if (isMuted) {
      volumeIcon = "󰝟"
    } else if (volumePercent === 0) {
      volumeIcon = "󰝟"
    } else if (volumePercent < 30) {
      volumeIcon = "󰕿"
    } else if (volumePercent < 70) {
      volumeIcon = "󰖀"
    } else {
      volumeIcon = "󰕾"
    }
  }

  Timer {
    id: procTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      volumeProc.running = true
      muteProc.running = true
    }
  }

  Text {
    id: volumeText
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: root.volumeIcon + " " + root.volumePercent + "%"
    color: root.isMuted ? root.colYellow : root.colFg
    font { family: root.fontFamily; pixelSize: root.fontSize }
  }

  Process {
    id: openPavucontrol
    command: ["pavucontrol"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      openPavucontrol.running = true
    }
  }
  
  implicitWidth: volumeText.implicitWidth
  implicitHeight: volumeText.implicitHeight
}

