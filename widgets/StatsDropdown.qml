import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "System Statistics"
  dropdownWidth: 280
  dropdownHeight: 300
  
  content: ColumnLayout {
    anchors.fill: parent
    spacing: Root.Theme.spacingXLarge
    
    // CPU and MEM side by side
    RowLayout {
      Layout.fillWidth: true
      spacing: 60
      
      RadialBarWidget {
        id: cpuBar
        value: cpuData.cpuUsage
        label: "CPU"
      }
      
      RadialBarWidget {
        id: memBar
        value: memData.memUsage
        label: "MEM"
      }
    }
    
    // TEMP bar below
    TempBarWidget {
      id: tempBar
      value: tempData.cpuTemp
      maxValue: 100
    }
    
    // Hidden widgets to get data
    CpuWidget {
      id: cpuData
      visible: false
    }
    
    MemoryWidget {
      id: memData
      visible: false
    }
    
    CpuTempWidget {
      id: tempData
      visible: false
    }
    
    Item { Layout.fillHeight: true }
  }
}
