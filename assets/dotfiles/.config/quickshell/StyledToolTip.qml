import QtQuick
import QtQuick.Controls

ToolTip {
  id: root

  // Theme properties - set by parent
  property color bgColor: "transparent"
  property color borderColor: "transparent"
  property color textColor: "white"
  property string fontFamily: "monospace"

  visible: false
  delay: 500
  x: 0

  background: Rectangle {
    color: root.bgColor
    radius: 8
    border.color: root.borderColor
    border.width: 2
  }

  contentItem: Text {
    text: root.text
    color: root.textColor
    font.family: root.fontFamily
    font.pixelSize: 13
  }
}
