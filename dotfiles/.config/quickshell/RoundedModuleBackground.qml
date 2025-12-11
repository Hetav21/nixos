import QtQuick

Item {
  id: root

  property color bgColor: "transparent"
  property int radius: 22
  property int radiusHalf: radius / 2

  // Left rounded cap
  Rectangle {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: root.radius
    radius: root.radius
    color: root.bgColor
  }

  // Center fill
  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.leftMargin: root.radiusHalf
    anchors.rightMargin: root.radiusHalf
    color: root.bgColor
  }

  // Right rounded cap
  Rectangle {
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: root.radius
    radius: root.radius
    color: root.bgColor
  }
}
