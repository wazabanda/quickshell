import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".." as Root

RowLayout {
  spacing: Root.Theme.spacingMedium
  // Layout.bottomMargin: 20
  // Layout.topMargin: 0

  // Access the focused monitor and workspace
  property var focusedMonitor: Hyprland.focusedMonitor
  property var activeWorkspace: Hyprland.focusedWorkspace
  
  // Find the activated window within that workspace
  property var focusedWindow: {
    // Try getting from focused monitor first
    if (focusedMonitor && focusedMonitor.activeWindow) {
      return focusedMonitor.activeWindow;
    }
    
    // Fallback: iterate through workspace toplevels
    if (!activeWorkspace) return null;
    for (var i = 0; i < activeWorkspace.toplevels.count; i++) {
      var tl = activeWorkspace.toplevels.get(i);
      if (tl.activated) return tl;
    }
    return null;
  }

  // Workspace indicators
  Repeater {
    model: 10
    Rectangle {
      property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      property int activeWorkspaceId: Hyprland.focusedWorkspace?.id || 1
      property int currentWorkspaceId: index + 1
      property int baseRotation: 20  // Base rotation for active workspace
      property int rotationStep: 8   // Degrees per workspace step
      
      width: 24
      height: 24
      // rotation: {
      //   var diff = currentWorkspaceId - activeWorkspaceId
      //   return baseRotation + (diff * rotationStep)
      // }
      color: "transparent"
      border.color: isActive ? Root.Theme.cyan : (ws ? Root.Theme.blue : Root.Theme.muted)
      border.width: 1
      radius: isActive ? 45 : 0
      scale: 1.0
      Layout.alignment: Qt.AlignVCenter
      Layout.bottomMargin: 8
      
      // Bounce animation when workspace becomes active
      SequentialAnimation on scale {
        id: bounceAnimation
        running: false
        NumberAnimation {
          to: 1.5
          duration: 200
          easing.type: Easing.OutQuad
        }
        NumberAnimation {
          to: 1.0
          duration: 300
          easing.type: Easing.OutBounce
        }
      }
      
      // Trigger bounce when workspace becomes active
      onIsActiveChanged: {
        if (isActive) {
          bounceAnimation.start()
        }
      }
      
      // Animation for rotation
      Behavior on rotation {
        NumberAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }
      
      // Animation for border radius
      Behavior on radius {
        NumberAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }
      
      // Animation for border color
      Behavior on border.color {
        ColorAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }
      
      Text {
        anchors.centerIn: parent
        // text: isActive ? "X" : (index + 1)
        text: (index + 1)
        color: isActive ? Root.Theme.cyan : (ws ? Root.Theme.blue : Root.Theme.muted)
        font { pixelSize: Root.Theme.fontSize; bold: true}
        
        // Animation for text color
        Behavior on color {
          ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
          }
        }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
  }

  // Separator
  Text {
    text: "|"
    color: Root.Theme.muted
    font { pixelSize: Root.Theme.fontSize; bold: true}
    Layout.alignment: Qt.AlignVCenter
  }

  // Current window title
  Text {
    id: windowTitle
    text: focusedWindow ? focusedWindow.title : ""
    color: Root.Theme.foreground
    font { pixelSize: Root.Theme.fontSize }
    Layout.alignment: Qt.AlignVCenter
    
    // Limit the width to prevent the title from being too long
    Layout.maximumWidth: 400
    elide: Text.ElideRight
  }
}

