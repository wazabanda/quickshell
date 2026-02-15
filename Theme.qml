pragma Singleton
import QtQuick

QtObject {
  id: theme
  
  // Color Palette - Tokyo Night
  readonly property color background: "#1a1b26"
  readonly property color foreground: "#a9b1d6"
  readonly property color muted: "#444b6a"
  readonly property color cyan: "#0db9d7"
  readonly property color blue: "#7aa2f7"
  readonly property color yellow: "#e0af68"
  readonly property color red: "#f7768e"
  readonly property color green: "#9ece6a"
  readonly property color orange: "#ff9e64"
  readonly property color purple: "#bb9af7"
  
  // Border Properties
  readonly property int borderWidth: 2
  readonly property color borderColor: muted
  readonly property int borderRadius: 2
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
  readonly property int panelHeight: 32
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
  readonly property real radialBarBorderGap: 0.03
  
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
}

