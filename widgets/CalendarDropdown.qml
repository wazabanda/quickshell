import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "Calendar"
  dropdownWidth: 400
  dropdownHeight: 600
  
  // Process to fetch Google Calendar events
  Process {
    id: calendarProcess
    command: ["/home/wazab/.pyenv/versions/3.12.8/bin/python", "/home/wazab/.config/quickshell/scripts/google_calendar.py", "5", "7"]
    running: false
    
    property var events: []
    property string errorMessage: ""
    property string buffer: ""
    
    stdout: SplitParser {
      onRead: data => {
        calendarProcess.buffer += data
      }
    }
    
    onRunningChanged: {
      if (!running && buffer !== "") {
        try {
          var result = JSON.parse(buffer)
          if (result.error) {
            calendarProcess.errorMessage = result.error
            calendarProcess.events = []
          } else {
            calendarProcess.events = result.events || []
            calendarProcess.errorMessage = ""
          }
        } catch (e) {
          calendarProcess.errorMessage = "Failed to parse calendar data: " + e
          calendarProcess.events = []
        }
        buffer = ""
      }
    }
  }
  
  // Process to open URLs in browser
  Process {
    id: openUrlProcess
    running: false
  }
  
  // Fetch events when dropdown becomes visible
  onVisibleChanged: {
    if (visible) {
      calendarProcess.running = true
    }
  }
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingMedium
    
    // Month and Year header
    Text {
      id: monthYearText
      text: Qt.formatDateTime(new Date(), "MMMM yyyy")
      color: Root.Theme.cyan
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize + 4; bold: true }
      Layout.alignment: Qt.AlignHCenter
    }
    
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Root.Theme.borderColor
    }
    
    // Day names header
    GridLayout {
      Layout.fillWidth: true
      columns: 7
      rowSpacing: Root.Theme.spacingSmall
      columnSpacing: Root.Theme.spacingSmall
      
      Repeater {
        model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        Text {
          text: modelData
          color: Root.Theme.blue
          font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize - 1; bold: true }
          horizontalAlignment: Text.AlignHCenter
          Layout.preferredWidth: 42
        }
      }
    }
    
    // Calendar grid
    GridLayout {
      id: calendarGrid
      Layout.fillWidth: true
      Layout.fillHeight: true
      columns: 7
      rowSpacing: Root.Theme.spacingSmall
      columnSpacing: Root.Theme.spacingSmall
      
      property var currentDate: new Date()
      property int currentDay: currentDate.getDate()
      property int currentMonth: currentDate.getMonth()
      property int currentYear: currentDate.getFullYear()
      
      // Calculate first day of month and days in month
      property var firstDayOfMonth: new Date(currentYear, currentMonth, 1)
      property int startDayOfWeek: firstDayOfMonth.getDay()
      property int daysInMonth: new Date(currentYear, currentMonth + 1, 0).getDate()
      property int daysInPrevMonth: new Date(currentYear, currentMonth, 0).getDate()
      
      
      // Total cells (6 rows x 7 days)
      Repeater {
        model: 42
        
        Rectangle {
          Layout.preferredWidth: 42
          Layout.preferredHeight: 42
          
          property int dayNumber: {
            if (index < calendarGrid.startDayOfWeek) {
              // Previous month
              return calendarGrid.daysInPrevMonth - (calendarGrid.startDayOfWeek - index - 1)
            } else if (index < calendarGrid.startDayOfWeek + calendarGrid.daysInMonth) {
              // Current month
              return index - calendarGrid.startDayOfWeek + 1
            } else {
              // Next month
              return index - (calendarGrid.startDayOfWeek + calendarGrid.daysInMonth) + 1
            }
          }
          
          property bool isCurrentMonth: index >= calendarGrid.startDayOfWeek && 
                                       index < calendarGrid.startDayOfWeek + calendarGrid.daysInMonth
          property bool isToday: isCurrentMonth && dayNumber === calendarGrid.currentDay
          
          color: isToday ? Root.Theme.cyan : "transparent"
          border.color: isCurrentMonth ? Root.Theme.borderColor : "transparent"
          border.width: isCurrentMonth ? 1 : 0
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: dayNumber
            color: isToday ? Root.Theme.background : 
                   (isCurrentMonth ? Root.Theme.foreground : Qt.rgba(Root.Theme.muted.r, Root.Theme.muted.g, Root.Theme.muted.b, 0.4))
            font { 
              family: Root.Theme.fontFamily
              pixelSize: Root.Theme.fontSize
              bold: isToday
            }
          }
        }
      }
    }
    
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Root.Theme.borderColor
    }
    
    // Current date display
    Text {
      text: Qt.formatDateTime(new Date(), "dddd, MMMM dd, yyyy")
      color: Root.Theme.blue
      font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
      Layout.alignment: Qt.AlignHCenter
    }
    
    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: Root.Theme.borderColor
    }
    
    // Upcoming Events Section
    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: Root.Theme.spacingSmall
      
      // Events header
      Text {
        text: "Upcoming Events"
        color: Root.Theme.cyan
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize + 2; bold: true }
        Layout.alignment: Qt.AlignLeft
      }
      
      // Error message if any
      Text {
        visible: calendarProcess.errorMessage !== ""
        text: calendarProcess.errorMessage
        color: Root.Theme.red
        font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize - 2 }
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
      }
      
      // Events list or empty message
      ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        
        ColumnLayout {
          width: parent.width
          spacing: Root.Theme.spacingSmall
          
          // Show events or empty message
          Repeater {
            model: calendarProcess.events.length > 0 ? calendarProcess.events : 
                   (calendarProcess.errorMessage === "" ? [{"empty": true}] : [])
            
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: modelData.empty ? 60 : 70
              color: eventMouseArea.containsMouse ? Qt.rgba(Root.Theme.blue.r, Root.Theme.blue.g, Root.Theme.blue.b, 0.1) : "transparent"
              border.color: Root.Theme.borderColor
              border.width: 1
              radius: Root.Theme.borderRadius
              
              MouseArea {
                id: eventMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: modelData.empty ? Qt.ArrowCursor : Qt.PointingHandCursor
                
                onClicked: {
                  if (!modelData.empty && modelData.html_link) {
                    openUrlProcess.command = ["xdg-open", modelData.html_link]
                    openUrlProcess.running = true
                  }
                }
              }
              
              ColumnLayout {
                anchors.fill: parent
                anchors.margins: Root.Theme.spacingSmall
                spacing: 2
                
                // Empty state
                Text {
                  visible: modelData.empty === true
                  text: "No upcoming events"
                  color: Root.Theme.muted
                  font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
                  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
                
                // Event title with icon
                RowLayout {
                  visible: !modelData.empty
                  Layout.fillWidth: true
                  spacing: Root.Theme.spacingSmall
                  
                  Text {
                    text: {
                      if (modelData.event_type === 'birthday') return "󰔟"  // nf-md-cake_variant
                      if (modelData.event_type === 'task') return "󰄲"      // nf-md-checkbox_marked_circle_outline
                      return "󰃭"  // nf-md-calendar
                    }
                    color: {
                      if (modelData.event_type === 'birthday') return Root.Theme.pink
                      if (modelData.event_type === 'task') return Root.Theme.green
                      return Root.Theme.blue
                    }
                    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
                  }
                  
                  Text {
                    text: modelData.summary || ""
                    color: Root.Theme.foreground
                    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                  }
                }
                
                // Event time
                Text {
                  visible: !modelData.empty
                  text: modelData.start_formatted || ""
                  color: Root.Theme.blue
                  font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize - 2 }
                  Layout.fillWidth: true
                }
                
                // Event location (if available)
                RowLayout {
                  visible: !modelData.empty && modelData.location !== ""
                  Layout.fillWidth: true
                  spacing: 4
                  
                  Text {
                    text: "󰍎"  // nf-md-map_marker
                    color: Root.Theme.red
                    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize - 2 }
                  }
                  
                  Text {
                    text: modelData.location || ""
                    color: Root.Theme.muted
                    font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize - 2 }
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

