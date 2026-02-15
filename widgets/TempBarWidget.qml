import QtQuick
import QtQuick.Layouts
import ".." as Root

Item {
  id: root
  
  property int value: 0
  property int maxValue: 100
  
  function getSegmentColor(segmentIndex) {
    // Get color for a specific segment (0-19, each representing 5%)
    // Use a squared curve to make color differences more obvious
    var normalized = segmentIndex / 19
    var squared = normalized * normalized  // Non-linear curve for more dramatic transitions
    var r = squared * 255
    var g = (1 - squared) * 255
    var b = 0
    return Qt.rgba(r / 255, g / 255, b / 255, 1)
  }
  
  function getValueColor() {
    // Get color for current value based on which segment it's in
    var percent = Math.max(0, Math.min(100, (value / maxValue) * 100))
    var segment = Math.floor(percent / 5)  // 0-19
    return getSegmentColor(segment)
  }
  
  implicitWidth: 250
  implicitHeight: 40
  
  ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingSmall
    
    // Label and value
    RowLayout {
      Layout.fillWidth: true
      
      Text {
        text: "TEMP"
        color: Root.Theme.foreground
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall; bold: true }
      }
      
      Item { Layout.fillWidth: true }
      
      Text {
        text: root.value + "°C"
        color: root.getValueColor()
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall; bold: true }
      }
    }
    
    // Bar with 5% segments
    Rectangle {
      Layout.fillWidth: true
      height: Root.Theme.tempBarHeight
      color: Root.Theme.foreground
      opacity: Root.Theme.opacityDisabled
      radius: Root.Theme.tempBarRadius
      clip: true
      
      Row {
        anchors.fill: parent
        spacing: Root.Theme.tempBarSegmentSpacing  // Border between segments
        
        Repeater {
          model: 20  // 20 segments of 5% each
          
          Rectangle {
            width: (parent.parent.width - (19 * Root.Theme.tempBarSegmentSpacing)) / 20  // Account for spacing
            height: parent.height
            color: {
              var segmentValue = (index + 1) * 5  // 5, 10, 15, ..., 100
              var percent = (root.value / root.maxValue) * 100
              if (percent >= segmentValue - 5) {
                return root.getSegmentColor(index)
              } else {
                return "transparent"
              }
            }
            radius: 0  // No radius on individual segments, parent handles rounding
            Behavior on color {
              ColorAnimation { duration: Root.Theme.animationDuration }
            }
          }
        }
      }
    }
  }
  
}

