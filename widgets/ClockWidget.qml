import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".." as Root

Item {
  id: root
  
  property var dropdownWindow: null
  property string triggerMode: "hover"  // "click" or "hover"
  property int hoverDelay: 200
  
  signal toggleDropdown()
  signal showDropdown()
  signal hideDropdown()
  
  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight
  
  // Expose position for dropdown positioning
  readonly property int buttonX: {
    var item = root
    var x = 0
    while (item && item.parent) {
      x += item.x
      item = item.parent
      if (item.objectName === "panel") break
    }
    return x
  }
  
  readonly property int buttonWidth: width
  readonly property int buttonHeight: height

  Text {
    id: clock
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: Root.Theme.widgetClockText
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

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    
    onClicked: {
      if (root.triggerMode === "click") {
        root.toggleDropdown()
      }
    }
    
    onEntered: {
      if (root.triggerMode === "hover") {
        checkAndHide.stop()
        hoverTimer.start()
      }
    }
    
    onExited: {
      if (root.triggerMode === "hover") {
        hoverTimer.stop()
        checkAndHide.start()
      }
    }
  }
  
  // Timer for hover delay
  Timer {
    id: hoverTimer
    interval: root.hoverDelay
    onTriggered: {
      root.showDropdown()
    }
  }
  
  // Timer for checking if we should hide
  Timer {
    id: checkAndHide
    interval: 100
    repeat: true
    onTriggered: {
      if (root.dropdownWindow && root.dropdownWindow.visible) {
        if (!mouseArea.containsMouse && !root.dropdownWindow.isHovered) {
          stop()
          root.hideDropdown()
        }
      } else {
        stop()
      }
    }
  }
}

