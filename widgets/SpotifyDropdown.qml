import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".." as Root

DropdownMenu {
  id: dropdown
  
  title: "Spotify Player"
  dropdownWidth: 350
  dropdownHeight: 420
  
  // State properties
  property string trackTitle: "No Track Playing"
  property string trackArtist: "Unknown Artist"
  property string trackAlbum: "Unknown Album"
  property string albumArtUrl: ""
  property bool isPlaying: false
  property bool spotifyRunning: false
  property int position: 0  // in seconds
  property int duration: 0  // in seconds
  property real volume: 0.5  // 0.0 to 1.0
  property bool shuffle: false
  property string loopStatus: "None"  // "None", "Track", "Playlist"
  
  content: Item {
    anchors.fill: parent
    
    // Spotify status message (when not running)
    Item {
      visible: !dropdown.spotifyRunning
      anchors.fill: parent
      
      Column {
        anchors.centerIn: parent
        spacing: Root.Theme.spacingLarge
        
        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "Spotify Not Running"
          color: Root.Theme.muted
          font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; italic: true }
        }
        
        // Open Spotify button
        Rectangle {
          width: 200
          height: 50
          anchors.horizontalCenter: parent.horizontalCenter
          color: openSpotifyMouse.containsMouse ? Root.Theme.green : Root.Theme.surface0
          border.color: Root.Theme.green
          border.width: Root.Theme.borderWidth
          radius: Root.Theme.borderRadius
          
          Row {
            anchors.centerIn: parent
            spacing: Root.Theme.spacingMedium
            
            Text {
              text: "󰓇"
              color: openSpotifyMouse.containsMouse ? Root.Theme.background : Root.Theme.green
              font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeLarge; bold: true }
            }
            
            Text {
              text: "Open Spotify"
              color: openSpotifyMouse.containsMouse ? Root.Theme.background : Root.Theme.green
              font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
            }
          }
          
          MouseArea {
            id: openSpotifyMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
              openSpotifyProcess.running = true
            }
          }
        }
      }
    }
    
    // Main player content (when Spotify is running)
    Column {
      visible: dropdown.spotifyRunning
      anchors.fill: parent
      spacing: Root.Theme.spacingMedium
      
      // Album Art and Track Info Row
      Row {
        width: parent.width
        spacing: Root.Theme.spacingLarge
        
        // Album Art
        Rectangle {
          width: 120
          height: 120
          color: Root.Theme.surface0
          radius: Root.Theme.borderRadius
          
          Image {
            id: albumArt
            anchors.fill: parent
            anchors.margins: 2
            source: dropdown.albumArtUrl
            fillMode: Image.PreserveAspectFit
            smooth: true
            
            // Fallback icon when no album art
            Text {
              visible: albumArt.status !== Image.Ready
              anchors.centerIn: parent
              text: "󰓇"
              color: Root.Theme.cyan
              font { family: Root.Theme.fontFamily; pixelSize: 48 }
            }
          }
        }
        
        // Track Info
        Column {
          width: parent.width - 120 - Root.Theme.spacingLarge
          spacing: Root.Theme.spacingSmall
          anchors.verticalCenter: parent.verticalCenter
          
          Text {
            text: dropdown.trackTitle
            color: Root.Theme.foreground
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize; bold: true }
            width: parent.width
            elide: Text.ElideRight
          }
          
          Text {
            text: dropdown.trackArtist
            color: Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
            width: parent.width
            elide: Text.ElideRight
          }
          
          Text {
            text: dropdown.trackAlbum
            color: Root.Theme.muted
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
            width: parent.width
            elide: Text.ElideRight
          }
        }
      }
      
      Rectangle {
        width: parent.width
        height: 1
        color: Root.Theme.muted
      }
      
      // Progress Bar Section
      Column {
        width: parent.width
        spacing: Root.Theme.spacingSmall
        
        // Progress slider
        Rectangle {
          width: parent.width
          height: 6
          color: Root.Theme.surface0
          radius: 3
          
          Rectangle {
            width: dropdown.duration > 0 ? (dropdown.position / dropdown.duration) * parent.width : 0
            height: parent.height
            color: Root.Theme.green
            radius: parent.radius
          }
          
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: function(mouse) {
              if (dropdown.duration > 0) {
                var newPosition = (mouse.x / width) * dropdown.duration
                var pos = Math.floor(newPosition * 1000000)
                simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.SetPosition objpath:/org/mpris/MediaPlayer2 int64:" + pos]
                simpleCommandProc.running = true
                dropdown.position = Math.floor(newPosition)
              }
            }
          }
        }
        
        // Time labels
        Row {
          width: parent.width
          
          Text {
            text: formatTime(dropdown.position)
            color: Root.Theme.foreground
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
          }
          
          Item { width: parent.width - 80 }
          
          Text {
            text: formatTime(dropdown.duration)
            color: Root.Theme.foreground
            font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
          }
        }
      }
      
      // All Controls in One Row
      Row {
        width: parent.width
        spacing: Root.Theme.spacingMedium
        
        // Shuffle button
        Rectangle {
          width: 35
          height: 35
          color: dropdown.shuffle ? Root.Theme.green : (shuffleMouse.containsMouse ? Root.Theme.surface1 : Root.Theme.surface0)
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: "󰒝"
            color: dropdown.shuffle ? Root.Theme.background : Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: 16 }
          }
          
          MouseArea {
            id: shuffleMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
              console.log("Shuffle clicked!")
              var newShuffle = !dropdown.shuffle
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:org.mpris.MediaPlayer2.Player string:Shuffle variant:boolean:" + newShuffle]
              simpleCommandProc.running = true
              dropdown.shuffle = newShuffle
            }
          }
        }
        
        // Previous button
        Rectangle {
          width: 40
          height: 40
          color: previousMouse.containsMouse ? Root.Theme.surface1 : Root.Theme.surface0
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: "󰒮"
            color: Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: 20 }
          }
          
          MouseArea {
            id: previousMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
              console.log("Previous clicked!")
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"]
              simpleCommandProc.running = true
              metadataProc.running = true
              statusProc.running = true
            }
          }
        }
        
        // Play/Pause button
        Rectangle {
          width: 50
          height: 50
          color: playPauseMouse.containsMouse ? Root.Theme.green : Root.Theme.surface0
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: dropdown.isPlaying ? "󰏤" : "󰐊"
            color: playPauseMouse.containsMouse ? Root.Theme.background : Root.Theme.green
            font { family: Root.Theme.fontFamily; pixelSize: 28 }
          }
          
          MouseArea {
            id: playPauseMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
              console.log("Play/Pause clicked!")
              // Use a simple shell command process
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"]
              simpleCommandProc.running = true
              console.log("Process started, running:", simpleCommandProc.running)
              // Trigger immediate state update
              statusProc.running = true
            }
          }
        }
        
        // Next button
        Rectangle {
          width: 40
          height: 40
          color: nextMouse.containsMouse ? Root.Theme.surface1 : Root.Theme.surface0
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: "󰒭"
            color: Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: 20 }
          }
          
          MouseArea {
            id: nextMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
              console.log("Next clicked!")
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"]
              simpleCommandProc.running = true
              metadataProc.running = true
              statusProc.running = true
            }
          }
        }
        
        // Repeat button
        Rectangle {
          width: 35
          height: 35
          color: dropdown.loopStatus !== "None" ? Root.Theme.green : (repeatMouse.containsMouse ? Root.Theme.surface1 : Root.Theme.surface0)
          radius: Root.Theme.borderRadius
          
          Text {
            anchors.centerIn: parent
            text: dropdown.loopStatus === "Track" ? "󰑘" : "󰑖"
            color: dropdown.loopStatus !== "None" ? Root.Theme.background : Root.Theme.cyan
            font { family: Root.Theme.fontFamily; pixelSize: 16 }
          }
          
          MouseArea {
            id: repeatMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
              console.log("Repeat clicked!")
              var newStatus = "None"
              if (dropdown.loopStatus === "None") {
                newStatus = "Playlist"
              } else if (dropdown.loopStatus === "Playlist") {
                newStatus = "Track"
              }
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:org.mpris.MediaPlayer2.Player string:LoopStatus variant:string:" + newStatus]
              simpleCommandProc.running = true
              dropdown.loopStatus = newStatus
            }
          }
        }
      }
      
      Rectangle {
        width: parent.width
        height: 1
        color: Root.Theme.muted
      }
      
      // Volume Section
      Row {
        width: parent.width
        spacing: Root.Theme.spacingMedium
        
        Text {
          text: dropdown.volume === 0 ? "󰝟" : (dropdown.volume < 0.3 ? "󰕿" : (dropdown.volume < 0.7 ? "󰖀" : "󰕾"))
          color: Root.Theme.cyan
          font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSize }
          anchors.verticalCenter: parent.verticalCenter
        }
        
        Rectangle {
          width: parent.width - 70
          height: 6
          anchors.verticalCenter: parent.verticalCenter
          color: Root.Theme.surface0
          radius: 3
          
          Rectangle {
            width: dropdown.volume * parent.width
            height: parent.height
            color: Root.Theme.cyan
            radius: parent.radius
          }
          
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: function(mouse) {
              var newVolume = mouse.x / width
              dropdown.volume = Math.max(0, Math.min(1, newVolume))
              simpleCommandProc.command = ["sh", "-c", "dbus-send --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:org.mpris.MediaPlayer2.Player string:Volume variant:double:" + dropdown.volume]
              simpleCommandProc.running = true
            }
          }
        }
        
        Text {
          text: Math.round(dropdown.volume * 100) + "%"
          color: Root.Theme.foreground
          font { family: Root.Theme.fontFamily; pixelSize: Root.Theme.fontSizeSmall }
          width: 35
          anchors.verticalCenter: parent.verticalCenter
        }
      }
    }
  }
  
  // Helper function to format time
  function formatTime(seconds) {
    var mins = Math.floor(seconds / 60)
    var secs = Math.floor(seconds % 60)
    return mins + ":" + (secs < 10 ? "0" : "") + secs
  }
  
  // ===== D-Bus Process Components =====
  
  // Check if Spotify is running
  Process {
    id: checkSpotifyProc
    command: ["sh", "-c", "dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify' && echo 'running' || echo 'not running'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        dropdown.spotifyRunning = (data.trim() === "running")
      }
    }
  }
  
  // Get all metadata at once
  Process {
    id: metadataProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        metadata=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata 2>/dev/null)
        title=$(echo "$metadata" | grep -A 2 'xesam:title' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        artist=$(echo "$metadata" | grep -A 3 'xesam:artist' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        album=$(echo "$metadata" | grep -A 2 'xesam:album"' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        art=$(echo "$metadata" | grep -A 2 'mpris:artUrl' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        len=$(echo "$metadata" | grep -A 1 'mpris:length' | tail -1 | sed 's/.*uint64 \\([0-9]*\\).*/\\1/')
        echo "$title|||$artist|||$album|||$art|||$len"
      else
        echo "||||0"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split("|||")
        if (parts.length >= 5) {
          dropdown.trackTitle = parts[0] || "Unknown Track"
          dropdown.trackArtist = parts[1] || "Unknown Artist"
          dropdown.trackAlbum = parts[2] || "Unknown Album"
          dropdown.albumArtUrl = parts[3] || ""
          dropdown.duration = Math.floor(parseInt(parts[4] || "0") / 1000000)
        }
      }
    }
  }
  
  // Get playback status and position
  Process {
    id: statusProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        STATUS=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus 2>/dev/null | grep -oP '(?<=string ").*(?=")')
        POSITION=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Position 2>/dev/null | grep -oP '(?<=int64 ).*')
        echo "$STATUS|||$POSITION"
      else
        echo "Stopped|||0"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split("|||")
        if (parts.length >= 2) {
          dropdown.isPlaying = (parts[0] === "Playing")
          dropdown.position = Math.floor(parseInt(parts[1] || "0") / 1000000)
        }
      }
    }
  }
  
  // Get volume
  Process {
    id: volumeProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Volume 2>/dev/null | grep -oP '(?<=double ).*'
      else
        echo "0.5"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var vol = parseFloat(data.trim())
        if (!isNaN(vol)) {
          dropdown.volume = Math.max(0, Math.min(1, vol))
        }
      }
    }
  }
  
  // Get shuffle and loop status
  Process {
    id: shuffleLoopProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        SHUFFLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Shuffle 2>/dev/null | grep -oP '(?<=boolean ).*')
        LOOP=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:LoopStatus 2>/dev/null | grep -oP '(?<=string ").*(?=")')
        echo "$SHUFFLE|||$LOOP"
      else
        echo "false|||None"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split("|||")
        if (parts.length >= 2) {
          dropdown.shuffle = (parts[0] === "true")
          dropdown.loopStatus = parts[1] || "None"
        }
      }
    }
  }
  
  // Simple reusable command process
  Process {
    id: simpleCommandProc
    command: []
    
    onRunningChanged: {
      console.log("Command process running changed:", running)
      if (!running) {
        console.log("Command completed")
      }
    }
  }
  
  // Open Spotify on workspace 8
  Process {
    id: openSpotifyProcess
    command: ["sh", "-c", "hyprctl dispatch workspace 8 && spotify &"]
  }
  
  // Main update timer
  Timer {
    id: mainUpdateTimer
    interval: 2000
    running: dropdown.visible
    repeat: true
    onTriggered: {
      checkSpotifyProc.running = true
      if (dropdown.spotifyRunning) {
        metadataProc.running = true
        statusProc.running = true
        volumeProc.running = true
        shuffleLoopProc.running = true
      }
    }
  }
  
  // Position update timer (faster when playing)
  Timer {
    id: positionTimer
    interval: 1000
    running: dropdown.visible && dropdown.isPlaying
    repeat: true
    onTriggered: {
      if (dropdown.isPlaying) {
        dropdown.position = Math.min(dropdown.position + 1, dropdown.duration)
      }
    }
  }
  
  // Initial update when dropdown becomes visible
  onVisibleChanged: {
    if (visible) {
      checkSpotifyProc.running = true
      metadataProc.running = true
      statusProc.running = true
      volumeProc.running = true
      shuffleLoopProc.running = true
    }
  }
  
  // Initial load
  Component.onCompleted: {
    if (visible) {
      checkSpotifyProc.running = true
      metadataProc.running = true
      statusProc.running = true
      volumeProc.running = true
      shuffleLoopProc.running = true
    }
  }
}
