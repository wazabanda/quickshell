import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import ".." as Root

RowLayout {
  spacing: Root.Theme.spacingMedium
  // Layout.bottomMargin: 20
  // Layout.topMargin: 0

  // Get focused workspace
  property var focusedWorkspace: Hyprland.focusedWorkspace
  
  // Find focused window from toplevels in the focused workspace
  property var focusedWindow: null
  
  // Function to update focused window from toplevels
  function updateFocusedWindow() {
    var newFocusedWindow = null;
    
    if (focusedWorkspace && focusedWorkspace.toplevels) {
      // Iterate through toplevels to find the activated one
      for (var i = 0; i < focusedWorkspace.toplevels.count; i++) {
        var tl = focusedWorkspace.toplevels.get(i);
        if (tl && tl.activated) {
          newFocusedWindow = tl;
          break;
        }
      }
    }
    
    focusedWindow = newFocusedWindow;
  }
  
  // Update when focused workspace changes
  onFocusedWorkspaceChanged: updateFocusedWindow()
  Component.onCompleted: updateFocusedWindow()
  
  // Monitor toplevels changes in focused workspace
  Connections {
    target: focusedWorkspace
    enabled: focusedWorkspace !== null
    
    function onToplevelsChanged() {
      updateFocusedWindow();
    }
  }
  
  // Monitor individual toplevel activation and title changes
  Repeater {
    model: focusedWorkspace ? focusedWorkspace.toplevels : null
    
    Connections {
      target: modelData
      enabled: modelData !== null
      
      function onActivatedChanged() {
        updateFocusedWindow();
      }
      
      function onTitleChanged() {
        // Update when title changes for activated window
        if (modelData && modelData.activated) {
          updateFocusedWindow();
        }
      }
    }
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
      property int windowCount: ws ? ws.toplevels.count : 0
      property bool shouldFlash: false
      
      width: 24
      height: 24
      // rotation: {
      //   var diff = currentWorkspaceId - activeWorkspaceId
      //   return baseRotation + (diff * rotationStep)
      // }
      color: shouldFlash ? Root.Theme.cyan : "transparent"
      border.color: isActive ? Root.Theme.cyan : (ws ? Root.Theme.blue : Root.Theme.muted)
      border.width: 1
      radius: isActive ? 45 : 0
      scale: 1.0
      Layout.alignment: Qt.AlignVCenter
      Layout.bottomMargin: 8
      
      // Monitor window count changes in non-active workspaces
      onWindowCountChanged: {
        if (!isActive && ws && windowCount > 0) {
          shouldFlash = true
          flashAnimation.start()
        }
      }
      
      // Monitor workspace for any changes (window titles, focus, etc.)
      Connections {
        target: ws
        enabled: ws !== null
        
        function onTopleveChanged() {
          if (!isActive && ws) {
            shouldFlash = true
            flashAnimation.start()
          }
        }
      }
      
      // Monitor all windows in this workspace for title changes
      Repeater {
        model: ws ? ws.toplevels : null
        
        Connections {
          target: modelData
          
          function onTitleChanged() {
            if (!isActive) {
              shouldFlash = true
              flashAnimation.start()
            }
          }
          
          function onFullscreenChanged() {
            if (!isActive) {
              shouldFlash = true
              flashAnimation.start()
            }
          }
        }
      }
      
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
      
      // Flash animation for activity in non-active workspace
      SequentialAnimation {
        id: flashAnimation
        running: false
        loops: 3
        SequentialAnimation {
          NumberAnimation {
            target: parent
            property: "opacity"
            to: 0.3
            duration: 150
            easing.type: Easing.InOutQuad
          }
          NumberAnimation {
            target: parent
            property: "opacity"
            to: 1.0
            duration: 150
            easing.type: Easing.InOutQuad
          }
        }
        onFinished: {
          shouldFlash = false
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
      
      // Animation for background color
      Behavior on color {
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

