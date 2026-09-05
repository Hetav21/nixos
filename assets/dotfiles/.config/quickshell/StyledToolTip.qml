import QtQuick
import Quickshell

PopupWindow {
  id: root

  // Target window and item for positioning
  property var anchorWindow: null
  property var anchorItem: null

  // Theme properties - set by parent
  property string text: ""
  property color bgColor: "transparent"
  property color borderColor: "transparent"
  property color textColor: "white"
  property string fontFamily: "Ubuntu, sans-serif"
  property int delay: 750

  // Public control property
  property bool active: false
  property bool showContent: false

  anchor.window: root.anchorWindow
  anchor.item: root.anchorItem
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.margins.top: 38

  mask: Region {}
  color: "transparent"
  visible: active && text !== ""

  implicitWidth: bg.width
  implicitHeight: bg.height

  Timer {
    id: hoverTimer
    interval: root.delay
    repeat: false
    onTriggered: {
      if (root.active && root.text !== "") {
        root.showContent = true;
      }
    }
  }

  onActiveChanged: {
    if (active && text !== "") {
      hoverTimer.restart();
    } else {
      hoverTimer.stop();
      root.showContent = false;
    }
  }

  onTextChanged: {
    if (text === "") {
      hoverTimer.stop();
      root.showContent = false;
    }
  }

  function show() {
    active = true;
  }

  function hide() {
    active = false;
    hoverTimer.stop();
    root.showContent = false;
  }

  Rectangle {
    id: bg
    color: root.bgColor
    radius: 6
    border.color: root.borderColor
    border.width: 2
    width: label.implicitWidth + 18
    height: label.implicitHeight + 10

    opacity: (root.active && root.showContent && root.text !== "") ? 1.0 : 0.0
    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.OutQuad
      }
    }

    Text {
      id: label
      anchors.centerIn: parent
      text: root.text
      color: root.textColor
      font.family: root.fontFamily
      font.pixelSize: 12
      font.weight: Font.Medium
      renderType: Text.NativeRendering
    }
  }
}

