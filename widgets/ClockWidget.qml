import QtQuick

Item {
  id: root
  
  property color colBlue: "#7aa2f7"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  Text {
    id: clock
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: root.colBlue
    font {family: root.fontFamily; pixelSize: root.fontSize; bold: true}
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
  
  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight
}

