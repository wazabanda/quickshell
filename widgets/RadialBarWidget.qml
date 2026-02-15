import QtQuick
import ".." as Root

Item {
  id: root
  
  property int value: 0
  property string label: ""
  
  function getSegmentColor(segmentIndex) {
    // Get color for a specific segment (0-19, each representing 5%)
    // Transition: green (0-25%) → yellow (25-50%) → orange (50-75%) → red (75-100%)
    var normalized = segmentIndex / 19
    
    var r, g, b
    
    if (normalized <= 0.25) {
      // Green to Yellow (0-25%)
      var t = normalized / 0.25  // 0 to 1
      r = Math.round(t * 255)
      g = 255
      b = 0
    } else if (normalized <= 0.5) {
      // Yellow to Orange (25-50%)
      var t = (normalized - 0.25) / 0.25  // 0 to 1
      r = 255
      g = Math.round(255 - (t * 128))  // 255 to 127
      b = 0
    } else if (normalized <= 0.75) {
      // Orange stays orange (50-75%)
      r = 255
      g = 127
      b = 0
    } else {
      // Orange to Red (75-100%)
      var t = (normalized - 0.75) / 0.25  // 0 to 1
      r = 255
      g = Math.round(127 - (t * 127))  // 127 to 0
      b = 0
    }
    
    return "rgb(" + r + "," + g + "," + b + ")"
  }
  
  implicitWidth: Root.Theme.radialBarSize
  implicitHeight: Root.Theme.radialBarSize + 20
  
  Column {
    anchors.centerIn: parent
    spacing: Root.Theme.spacingMedium
    
    // Radial bar
    Item {
      anchors.horizontalCenter: parent.horizontalCenter
      width: Root.Theme.radialBarSize
      height: Root.Theme.radialBarSize
      
      Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        
        onPaint: {
          var ctx = getContext("2d")
          var centerX = width / 2
          var centerY = height / 2
          var radius = Math.min(width, height) / 2 - Root.Theme.radialBarStrokeWidth
          var totalSegments = 20
          var segmentAngle = (2 * Math.PI) / totalSegments
          var borderGap = Root.Theme.radialBarBorderGap  // Gap between segments (in radians)
          var startAngle = -Math.PI / 2
          
          ctx.clearRect(0, 0, width, height)
          
          // Draw background arc first
          ctx.beginPath()
          ctx.arc(centerX, centerY, radius, -Math.PI / 2, 3 * Math.PI / 2)
          ctx.strokeStyle = Root.Theme.muted
          ctx.lineWidth = Root.Theme.radialBarStrokeWidth
          ctx.lineCap = "round"
          ctx.stroke()
          
          // Draw each 5% segment individually with borders (gaps create borders)
          for (var i = 0; i < totalSegments; i++) {
            var segmentStartAngle = startAngle + (i * segmentAngle) + borderGap / 2
            var segmentEndAngle = startAngle + ((i + 1) * segmentAngle) - borderGap / 2
            var segmentValue = (i + 1) * 5  // 5, 10, 15, ..., 100
            
            // Determine if this segment should be filled
            var isFilled = root.value >= segmentValue - 5
            
            if (isFilled) {
              ctx.beginPath()
              ctx.arc(centerX, centerY, radius, segmentStartAngle, segmentEndAngle)
              ctx.strokeStyle = root.getSegmentColor(i)
              ctx.lineWidth = Root.Theme.radialBarStrokeWidth
              ctx.lineCap = "round"
              ctx.stroke()
            } else {
              // Draw unfilled segment in muted color
              ctx.beginPath()
              ctx.arc(centerX, centerY, radius, segmentStartAngle, segmentEndAngle)
              ctx.strokeStyle = Root.Theme.muted
              ctx.lineWidth = Root.Theme.radialBarStrokeWidth
              ctx.lineCap = "round"
              ctx.stroke()
            }
          }
        }
      }
      
      Text {
        anchors.centerIn: parent
        text: root.value + "%"
        color: Root.Theme.foreground
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall; bold: true }
      }
      
      Connections {
        target: root
        function onValueChanged() {
          canvas.requestPaint()
        }
      }
      
      Component.onCompleted: canvas.requestPaint()
    }
    
    // Label
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.label
      color: Root.Theme.foreground
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
    }
  }
}

