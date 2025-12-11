//@ pragma UseQApplication
//@ pragma IconTheme @iconTheme@
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.DBusMenu
import Quickshell.Widgets

ShellRoot {
  id: root

  // Layout constants
  readonly property int barHeight: 42
  readonly property int moduleHeight: barHeight - 8
  readonly property int moduleRadius: 22
  readonly property int workspaceItemHeight: moduleHeight - 6
  readonly property int fontSize: 16
  readonly property int fontSizeIcon: 24
  readonly property int fontSizeSmall: fontSize - 1

  // Individual icon font sizes (left module)
  readonly property int fontSizeLauncherIcon: 26
  readonly property int fontSizeBacklightIcon: 25
  readonly property int fontSizeVolumeIcon: 28
  readonly property int fontSizeMicActiveIcon: 18
  readonly property int fontSizeMicMutedIcon: 22

  // Clock font sizes (right module)
  readonly property int fontSizeClockIcon: 24
  readonly property int fontSizeClockText: 16

  // Icons
  readonly property var backlightIcons: ["󰃞", "󰃟", "󰃠", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󰛨"]
  readonly property var volumeIcons: ["", "", ""]
  readonly property string volumeMutedIcon: ""
  readonly property string micActiveIcon: "󰍬"
  readonly property string micMutedIcon: "󰍭"
  readonly property var batteryIcons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
  readonly property string batteryChargingIcon: "󰂄"
  readonly property string launcherIcon: ""
  readonly property string clockIcon: "󰥔"

  // Icon helper functions
  function getBacklightIcon(percent) {
    var idx = Math.min(9, Math.floor(percent / 10));
    return backlightIcons[idx];
  }

  function getVolumeIcon(percent, muted) {
    if (muted) return volumeMutedIcon;
    if (percent <= 33) return volumeIcons[0];
    if (percent <= 66) return volumeIcons[1];
    return volumeIcons[2];
  }

  function getBatteryIcon(percent, charging) {
    if (charging) return batteryChargingIcon;
    var idx = Math.min(10, Math.floor(percent / 10));
    return batteryIcons[idx];
  }

  // State grouped by domain
  QtObject {
    id: audio
    property int volumePercent: 0
    property bool volumeMuted: false
    property bool micMuted: false
  }

  QtObject {
    id: battery
    property int percent: 0
    property bool charging: false
  }

  QtObject {
    id: backlight
    property int percent: 0
  }

  property string clockText: "--:--"

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: root.barHeight
      color: "transparent"

      Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Left Module
        Item {
          id: leftModule
          anchors.left: parent.left
          anchors.leftMargin: 12
          anchors.verticalCenter: parent.verticalCenter
          height: root.moduleHeight
          width: leftRow.width + 24

          RoundedModuleBackground {
            anchors.fill: parent
            radius: root.moduleRadius
            bgColor: "@baseColor@"
          }

          Row {
            id: leftRow
            anchors.centerIn: parent
            spacing: 0

            // Launcher icon
            Text {
              text: root.launcherIcon
              color: "@love@"
              font.family: "@fontFamily@"
              font.pixelSize: root.fontSizeLauncherIcon
              font.bold: true
              rightPadding: 18
            }

            // Backlight
            IconValueDisplay {
              id: backlightDisplay
              height: root.moduleHeight
              iconText: root.getBacklightIcon(backlight.percent)
              valueText: backlight.percent + "%"
              iconColor: "@gold@"
              iconSize: root.fontSizeBacklightIcon
              valueSize: root.fontSize
              tooltipText: "Brightness: " + backlight.percent + "%"
              fontFamily: "@fontFamily@"
              tooltipBgColor: "@baseColor@"
              tooltipBorderColor: "@overlay@"
              tooltipTextColor: "@textColor@"
            }

            Item { width: 20; height: 1 }

            // Volume
            IconValueDisplay {
              id: volumeDisplay
              height: root.moduleHeight
              iconText: root.getVolumeIcon(audio.volumePercent, audio.volumeMuted)
              valueText: audio.volumePercent.toString()
              iconColor: "@iris@"
              iconSize: root.fontSizeVolumeIcon
              valueSize: root.fontSize
              tooltipText: audio.volumeMuted ? "Volume: Muted" : ("Volume: " + audio.volumePercent + "%")
              clickable: true
              onItemClicked: pavuProc.running = true
              fontFamily: "@fontFamily@"
              tooltipBgColor: "@baseColor@"
              tooltipBorderColor: "@overlay@"
              tooltipTextColor: "@textColor@"
            }

            Item { width: 20; height: 1 }

            // Microphone
            Item {
              id: micItem
              width: micText.width
              height: root.moduleHeight

              Text {
                id: micText
                text: audio.micMuted ? root.micMutedIcon : root.micActiveIcon
                color: "@rose@"
                font.family: "@fontFamily@"
                font.pixelSize: audio.micMuted ? root.fontSizeMicMutedIcon : root.fontSizeMicActiveIcon
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: pavuMicProc.running = true
                onEntered: micTooltip.visible = true
                onExited: micTooltip.visible = false
              }

              StyledToolTip {
                id: micTooltip
                text: audio.micMuted ? "Microphone: Muted" : "Microphone: Active"
                bgColor: "@baseColor@"
                borderColor: "@overlay@"
                textColor: "@textColor@"
                fontFamily: "@fontFamily@"
              }
            }

            Item { width: 20; height: 1 }

            // Battery
            IconValueDisplay {
              id: batteryDisplay
              height: root.moduleHeight
              iconText: root.getBatteryIcon(battery.percent, battery.charging)
              valueText: battery.percent + "%"
              iconColor: "@pine@"
              iconSize: root.fontSize
              valueSize: root.fontSize
              tooltipText: battery.charging ? ("Battery: " + battery.percent + "% (Charging)") : ("Battery: " + battery.percent + "%")
              fontFamily: "@fontFamily@"
              tooltipBgColor: "@baseColor@"
              tooltipBorderColor: "@overlay@"
              tooltipTextColor: "@textColor@"
            }
          }
        }

        // Center Module (Workspaces)
        Item {
          id: centerModule
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          height: root.moduleHeight
          width: workspaceRow.width + 24

          RoundedModuleBackground {
            anchors.fill: parent
            radius: root.moduleRadius
            bgColor: "@baseColor@"
          }

          property int currentActiveWs: Hyprland.focusedMonitor ? (Hyprland.focusedMonitor.activeWorkspace ? Hyprland.focusedMonitor.activeWorkspace.id : 0) : 0
          onCurrentActiveWsChanged: bounceAnim.start()

          transform: Scale {
            id: centerScale
            origin.x: centerModule.width / 2
            origin.y: centerModule.height / 2
            xScale: 1.0
          }

          SequentialAnimation {
            id: bounceAnim
            NumberAnimation { target: centerScale; property: "xScale"; to: 1.10; duration: 150; easing.type: Easing.OutQuad }
            NumberAnimation { target: centerScale; property: "xScale"; to: 1.0; duration: 100; easing.type: Easing.OutBounce }
          }

          Row {
            id: workspaceRow
            anchors.centerIn: parent
            spacing: 4
            leftPadding: 6
            rightPadding: 6

            Repeater {
              model: {
                var ws = Hyprland.workspaces.values;
                return ws.filter(function(w) { return w.id > 0; }).sort(function(a, b) { return a.id - b.id; });
              }

              Item {
                required property var modelData
                property int wsId: modelData.id
                property bool isActive: Hyprland.focusedMonitor ? (Hyprland.focusedMonitor.activeWorkspace ? Hyprland.focusedMonitor.activeWorkspace.id === wsId : false) : false
                property bool isHovered: false

                width: isActive ? (40 + 6) : 18
                height: root.workspaceItemHeight

                Behavior on width {
                  NumberAnimation { duration: 300; easing.type: Easing.OutBack; easing.overshoot: 1.682 }
                }

                Rectangle {
                  anchors.centerIn: parent
                  width: parent.isActive ? 40 : 18
                  height: parent.height
                  radius: 9
                  color: parent.isActive ? "@overlay@" : (parent.isHovered ? "@surface@" : "transparent")

                  Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutBack; easing.overshoot: 1.682 }
                  }

                  Text {
                    anchors.centerIn: parent
                    text: wsId.toString()
                    color: isActive ? "@iris@" : "@textColor@"
                    font.family: "@fontFamily@"
                    font.pixelSize: root.fontSizeSmall
                    font.bold: true

                    Behavior on color {
                      ColorAnimation { duration: 150 }
                    }
                  }

                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: isHovered = true
                    onExited: isHovered = false
                    onClicked: Hyprland.dispatch("workspace " + wsId)
                  }
                }
              }
            }
          }
        }

        // Right Module
        Item {
          id: rightModule
          anchors.right: parent.right
          anchors.rightMargin: 12
          anchors.verticalCenter: parent.verticalCenter
          height: root.moduleHeight
          width: rightRow.width + 24

          RoundedModuleBackground {
            anchors.fill: parent
            radius: root.moduleRadius
            bgColor: "@baseColor@"
          }

          Row {
            id: rightRow
            anchors.centerIn: parent
            spacing: 20

            // System Tray
            Row {
              spacing: 9
              anchors.verticalCenter: parent.verticalCenter

              Repeater {
                model: SystemTray.items

                Item {
                  id: trayIconContainer
                  required property SystemTrayItem modelData
                  implicitWidth: 20
                  implicitHeight: 20
                  anchors.verticalCenter: parent.verticalCenter

                  IconImage {
                    id: trayIcon
                    source: trayIconContainer.modelData.icon
                    anchors.fill: parent
                  }

                  QsMenuAnchor {
                    id: menuAnchor
                    menu: trayIconContainer.modelData.menu
                    anchor.window: trayIconContainer.QsWindow.window
                    anchor.edges: Edges.Bottom
                  }

                  MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: trayTooltip.visible = true
                    onExited: trayTooltip.visible = false
                    onClicked: function(mouse) {
                      if (mouse.button === Qt.LeftButton) {
                        trayIconContainer.modelData.activate();
                      } else if (mouse.button === Qt.RightButton) {
                        var mapped = trayIconContainer.mapToItem(null, trayIconContainer.width / 2, trayIconContainer.height);
                        menuAnchor.anchor.rect.x = mapped.x;
                        menuAnchor.anchor.rect.y = mapped.y;
                        menuAnchor.open();
                      } else if (mouse.button === Qt.MiddleButton) {
                        trayIconContainer.modelData.secondaryActivate();
                      }
                    }
                  }

                  StyledToolTip {
                    id: trayTooltip
                    text: trayIconContainer.modelData.title || trayIconContainer.modelData.id || "System Tray"
                    bgColor: "@baseColor@"
                    borderColor: "@overlay@"
                    textColor: "@textColor@"
                    fontFamily: "@fontFamily@"
                  }
                }
              }
            }

            // Clock
            IconValueDisplay {
              id: clockDisplay
              height: root.moduleHeight
              iconText: root.clockIcon
              valueText: root.clockText
              iconColor: "@rose@"
              iconSize: root.fontSizeClockIcon
              valueSize: root.fontSizeClockText
              fontFamily: "@fontFamily@"
            }
          }
        }
      }
    }
  }

  // === PROCESSES AND TIMERS ===

  // Clock
  Process {
    id: clockProc
    command: ["date", "+%H:%M"]
    stdout: SplitParser {
      onRead: data => root.clockText = data.trim()
    }
  }
  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: clockProc.running = true
  }

  // Battery
  Process {
    id: batteryProc
    command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1"]
    stdout: SplitParser {
      onRead: data => {
        var val = parseInt(data.trim());
        if (!isNaN(val)) battery.percent = val;
      }
    }
  }

  Process {
    id: batteryStatusProc
    command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1"]
    stdout: SplitParser {
      onRead: data => battery.charging = (data.trim() === "Charging")
    }
  }

  function refreshBattery() {
    batteryProc.running = true;
    batteryStatusProc.running = true;
  }

  Process {
    id: powerEventListener
    running: true
    command: ["upower", "--monitor"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("battery") || data.includes("line-power") || data.includes("changed")) {
          root.refreshBattery();
        }
      }
    }
    onRunningChanged: if (!running) restartPowerListener.start()
  }

  Timer {
    id: restartPowerListener
    interval: 1000
    repeat: false
    onTriggered: powerEventListener.running = true
  }

  Timer {
    interval: 100
    running: true
    repeat: false
    onTriggered: root.refreshBattery()
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: root.refreshBattery()
  }

  // Audio
  Process {
    id: volumeProc
    command: ["sh", "-c", "wpctl get-volume " + "@" + "DEFAULT_AUDIO_SINK" + "@" + " | awk \"{print int(\\$2*100)}\""]
    stdout: SplitParser {
      onRead: data => {
        var val = parseInt(data.trim());
        if (!isNaN(val)) audio.volumePercent = val;
      }
    }
  }

  Process {
    id: volumeMutedProc
    command: ["sh", "-c", "wpctl get-volume " + "@" + "DEFAULT_AUDIO_SINK" + "@" + " | grep -q MUTED && echo 1 || echo 0"]
    stdout: SplitParser {
      onRead: data => audio.volumeMuted = (data.trim() === "1")
    }
  }

  Process {
    id: micMutedProc
    command: ["sh", "-c", "wpctl get-volume " + "@" + "DEFAULT_AUDIO_SOURCE" + "@" + " | grep -q MUTED && echo 1 || echo 0"]
    stdout: SplitParser {
      onRead: data => audio.micMuted = (data.trim() === "1")
    }
  }

  function refreshAudio() {
    volumeProc.running = true;
    volumeMutedProc.running = true;
    micMutedProc.running = true;
  }

  Process {
    id: audioEventListener
    running: true
    command: ["pactl", "subscribe"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("sink") || data.includes("source")) {
          root.refreshAudio();
        }
      }
    }
    onRunningChanged: if (!running) restartAudioListener.start()
  }

  Timer {
    id: restartAudioListener
    interval: 1000
    repeat: false
    onTriggered: audioEventListener.running = true
  }

  Timer {
    interval: 100
    running: true
    repeat: false
    onTriggered: root.refreshAudio()
  }

  // Backlight - event-driven with inotifywait
  Process {
    id: backlightProc
    command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d %"]
    stdout: SplitParser {
      onRead: data => {
        var val = parseInt(data.trim());
        if (!isNaN(val)) backlight.percent = val;
      }
    }
  }

  Process {
    id: backlightEventListener
    running: true
    command: ["sh", "-c", "inotifywait -m -e modify /sys/class/backlight/*/brightness 2>/dev/null || while true; do sleep 2; brightnessctl -m | cut -d, -f4 | tr -d %; done"]
    stdout: SplitParser {
      onRead: data => backlightProc.running = true
    }
    onRunningChanged: if (!running) restartBacklightListener.start()
  }

  Timer {
    id: restartBacklightListener
    interval: 1000
    repeat: false
    onTriggered: backlightEventListener.running = true
  }

  Timer {
    interval: 100
    running: true
    repeat: false
    onTriggered: backlightProc.running = true
  }

  // Application launchers
  Process {
    id: rofiProc
    command: ["rofi", "-show", "drun"]
    running: false
  }
  Process {
    id: pavuProc
    command: ["pavucontrol", "-t", "3"]
    running: false
  }
  Process {
    id: pavuMicProc
    command: ["pavucontrol", "-t", "4"]
    running: false
  }
}
