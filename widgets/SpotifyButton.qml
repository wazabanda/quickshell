import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".." as Root

DropdownButton {
  id: root
  
  label: trackName || "No Track"
  icon: "󰓇"  // Spotify icon
  iconOpen: "󰓇"
  widgetTextColor: Root.Theme.widgetSpotifyText
  
  // Track information
  property string trackName: "Spotify"
  property string artistName: ""
  property string albumName: ""
  property bool isPlaying: false
  property bool spotifyRunning: false
  
  // Check if Spotify is running
  Process {
    id: checkSpotifyProc
    command: ["sh", "-c", "dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify' && echo 'running' || echo 'not running'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        spotifyRunning = (data.trim() === "running")
        if (!spotifyRunning) {
          trackName = "Spotify"
          artistName = ""
          albumName = ""
          isPlaying = false
        }
      }
    }
  }
  
  // Get track metadata
  Process {
    id: metadataProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        metadata=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata 2>/dev/null)
        title=$(echo "$metadata" | grep -A 2 'xesam:title' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        artist=$(echo "$metadata" | grep -A 3 'xesam:artist' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        album=$(echo "$metadata" | grep -A 2 'xesam:album"' | grep 'string' | tail -1 | sed 's/.*string "\\(.*\\)".*/\\1/')
        echo "$title|||$artist|||$album"
      else
        echo "|||"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split("|||")
        if (parts.length >= 3) {
          trackName = parts[0] || "Unknown Track"
          artistName = parts[1] || "Unknown Artist"
          albumName = parts[2] || "Unknown Album"
        }
      }
    }
  }
  
  // Get playback status
  Process {
    id: playbackStatusProc
    command: ["sh", "-c", `
      if dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q 'org.mpris.MediaPlayer2.spotify'; then
        dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus 2>/dev/null | grep -oP '(?<=string ").*(?=")'
      else
        echo "Stopped"
      fi
    `]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var status = data.trim()
        isPlaying = (status === "Playing")
      }
    }
  }
  
  // Update timer
  Timer {
    id: updateTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      checkSpotifyProc.running = true
      if (spotifyRunning) {
        metadataProc.running = true
        playbackStatusProc.running = true
      }
    }
  }
  
  // Initial update
  Component.onCompleted: {
    checkSpotifyProc.running = true
    metadataProc.running = true
    playbackStatusProc.running = true
  }
}

