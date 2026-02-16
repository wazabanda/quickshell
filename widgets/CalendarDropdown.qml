import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "Calendar"
  dropdownWidth: 320
  dropdownHeight: 380
  
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
  }
}

