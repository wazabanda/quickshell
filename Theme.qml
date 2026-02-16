pragma Singleton
import QtQuick

QtObject {
  id: theme
  
  // Color Palette - Catppuccin Mocha
  readonly property color background: "#1e1e2e"    // Base
  readonly property color foreground: "#cdd6f4"    // Text
  readonly property color muted: "#45475a"         // Surface1
  readonly property color cyan: "#89dceb"          // Sky
  readonly property color blue: "#89b4fa"          // Blue
  readonly property color yellow: "#f9e2af"        // Yellow
  readonly property color red: "#f38ba8"           // Red
  readonly property color green: "#a6e3a1"         // Green
  readonly property color orange: "#fab387"        // Peach
  readonly property color purple: "#cba6f7"        // Mauve
  readonly property color pink: "#f5c2e7"          // Pink
  readonly property color teal: "#94e2d5"          // Teal
  readonly property color lavender: "#b4befe"      // Lavender
  readonly property color surface0: "#313244"      // Surface0
  readonly property color surface1: "#45475a"      // Surface1
  readonly property color surface2: "#585b70"      // Surface2
  
  // Border Properties
  readonly property int borderWidth: 0
  readonly property color borderColor: surface1
  readonly property int borderRadius: 0
  readonly property int panelBorderRadius: 0
  
  // Typography
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int fontSize: 14
  readonly property int fontSizeSmall: 12
  readonly property int fontSizeLarge: 16
  
  // Spacing
  readonly property int spacingSmall: 4
  readonly property int spacingMedium: 8
  readonly property int spacingLarge: 12
  readonly property int spacingXLarge: 16
  
  // Panel Properties
  readonly property int panelHeight: 46
  readonly property int panelMargins: 8
  
  // Widget Properties
  readonly property int separatorWidth: 1
  readonly property int separatorHeight: 16
  
  // Dropdown Properties
  readonly property int dropdownWidth: 280
  readonly property int dropdownHeight: 300
  readonly property int dropdownMargins: 16
  
  // Radial Bar Properties
  readonly property int radialBarSize: 80
  readonly property int radialBarStrokeWidth: 6
  readonly property real radialBarBorderGap: 0.25
  
  // Temperature Bar Properties
  readonly property int tempBarHeight: 8
  readonly property int tempBarRadius: 4
  readonly property int tempBarSegmentSpacing: 1
  
  // Animation Properties
  readonly property int animationDuration: 200
  readonly property int animationDurationSlow: 300
  
  // Opacity Values
  readonly property real opacityDisabled: 0.2
  readonly property real opacityHover: 0.8
  readonly property real opacityPressed: 0.6
  readonly property real panelOpacity: 0.8
  readonly property real dropdownOpacity: 0.8
}

