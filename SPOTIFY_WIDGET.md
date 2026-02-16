# Spotify Widget Documentation

## Overview
The Spotify widget provides a full-featured music player interface for controlling Spotify through the system panel. It uses D-Bus/MPRIS2 to communicate with Spotify.

## Components

### 1. SpotifyButton.qml
The panel button that displays the Spotify icon and current track name.

**Features:**
- Shows Spotify icon (󰓇)
- Displays current track name (scrolls if too long)
- Updates every 2 seconds
- Checks if Spotify is running

### 2. SpotifyDropdown.qml
The dropdown menu with full player controls.

**Features:**
- Album artwork display (200x200px)
- Track information (title, artist, album)
- Progress bar with seek functionality
- Playback controls (Previous, Play/Pause, Next)
- Shuffle and Repeat toggles
- Volume slider
- Shows "Open Spotify" button when Spotify is not running
  - Clicking opens Spotify on workspace 8

## Controls

### Main Controls
- **Previous (󰒮)**: Skip to previous track
- **Play/Pause (󰐊/󰏤)**: Toggle playback
- **Next (󰒭)**: Skip to next track

### Secondary Controls
- **Shuffle (󰒝)**: Toggle shuffle mode (green when active)
- **Repeat (󰑖/󰑘)**: Cycle through repeat modes:
  - None → Playlist → Track → None
  - Shows 󰑖 for Playlist repeat
  - Shows 󰑘 for Track repeat

### Progress Bar
- Click anywhere on the progress bar to seek to that position
- Updates in real-time during playback

### Volume Control
- Click on the volume slider to adjust volume
- Shows volume icon and percentage
- Range: 0-100%

## Trigger Mode
The widget uses **hover mode** by default:
- Hover over the button to show the dropdown
- Dropdown stays open while hovering over button or dropdown
- Automatically hides when mouse leaves both areas

To change to click mode, edit `shell.qml`:
```qml
SpotifyButton {
  triggerMode: "click"  // Change from "hover" to "click"
  // ...
}
```

## Requirements

### System Requirements
- Spotify installed (will be launched automatically if not running)
- Hyprland window manager (for workspace management)
- D-Bus support (standard on most Linux systems)
- `dbus-send` command available
- `hyprctl` command available (comes with Hyprland)

### Testing D-Bus Connection
To verify Spotify is accessible via D-Bus:
```bash
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
  /org/mpris/MediaPlayer2 \
  org.freedesktop.DBus.Properties.Get \
  string:org.mpris.MediaPlayer2.Player string:PlaybackStatus
```

## Customization

### Positioning
The dropdown is positioned relative to the button. Adjust in `shell.qml`:
```qml
SpotifyDropdown {
  buttonItem: spotifyButton
  alignment: "right"  // "left", "center", or "right"
  alignmentOffset: 0  // Additional pixel offset
}
```

### Dimensions
Adjust dropdown size in `shell.qml`:
```qml
SpotifyDropdown {
  dropdownWidth: 350   // Width in pixels
  dropdownHeight: 500  // Height in pixels
}
```

### Update Intervals
Edit timers in `SpotifyButton.qml` and `SpotifyDropdown.qml`:
- **Button update**: 2000ms (2 seconds) - updates track info in panel
- **Dropdown update**: 2000ms (2 seconds) - updates all player state
- **Position update**: 1000ms (1 second) - updates progress bar when playing

## Opening Spotify

When Spotify is not running, the dropdown will show an "Open Spotify" button:
- Click the button to launch Spotify
- Spotify will open on workspace 8
- The widget will automatically detect when Spotify is ready

The button uses Hyprland's dispatch command:
```bash
hyprctl dispatch workspace 8 && spotify &
```

## Troubleshooting

### Spotify Not Detected
1. Ensure Spotify is running (or click "Open Spotify" button)
2. Check D-Bus connection with the test command above
3. Verify `org.mpris.MediaPlayer2.spotify` is in D-Bus names:
   ```bash
   dbus-send --print-reply --dest=org.freedesktop.DBus \
     /org/freedesktop/DBus org.freedesktop.DBus.ListNames | \
     grep spotify
   ```

### Album Art Not Showing
- Album art URLs are provided by Spotify via MPRIS
- Some tracks may not have album art
- Falls back to Spotify icon when unavailable

### Controls Not Working
- Ensure Spotify has MPRIS support enabled (default)
- Check D-Bus permissions
- Try restarting Spotify

### Volume Control Issues
- Some Spotify versions may not support volume control via MPRIS
- Use system volume controls as fallback

## Integration

The widget is integrated into `shell.qml` after the Mode selector:
```qml
Separator {}

// Spotify Player
SpotifyButton {
  id: spotifyButton
  dropdownWindow: spotifyDropdown
  // ... configuration
}

Separator {}
```

## Theme Integration
The widget uses the existing Theme colors:
- **Cyan** (`Theme.cyan`): Icons and accents
- **Green** (`Theme.green`): Play button, progress bar, active states
- **Foreground** (`Theme.foreground`): Text
- **Background** (`Theme.background`): Backgrounds
- **Surface0/1** (`Theme.surface0/1`): UI elements
- **Muted** (`Theme.muted`): Dividers and secondary text

## Future Enhancements
Possible improvements:
- Playlist browsing
- Search functionality
- Lyrics display
- Queue management
- Keyboard shortcuts
- Desktop notifications for track changes
- Like/Unlike track functionality

