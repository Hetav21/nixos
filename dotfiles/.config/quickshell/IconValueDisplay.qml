import QtQuick
import QtQuick.Controls

Item {
  id: root

  property string iconText: ""
  property string valueText: ""
  property color iconColor: "white"
  property color valueColor: iconColor
  property int iconSize: 24
  property int valueSize: 16
  property string tooltipText: ""
  property bool clickable: false
  property string fontFamily: "monospace"

  // Theme properties for tooltip
  property color tooltipBgColor: "transparent"
  property color tooltipBorderColor: "transparent"
  property color tooltipTextColor: "white"

  signal itemClicked()

  width: iconItem.width + spacing + valueItem.width
  height: parent.height

  property int spacing: 4

  Text {
    id: iconItem
    text: root.iconText
    color: root.iconColor
    font.family: root.fontFamily
    font.pixelSize: root.iconSize
    font.bold: true
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: valueItem
    text: root.valueText
    color: root.valueColor
    font.family: root.fontFamily
    font.pixelSize: root.valueSize
    font.bold: true
    anchors.left: iconItem.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    hoverEnabled: root.tooltipText !== ""
    onClicked: if (root.clickable) root.itemClicked()
    onEntered: if (root.tooltipText !== "") tooltip.visible = true
    onExited: tooltip.visible = false
  }

  StyledToolTip {
    id: tooltip
    text: root.tooltipText
    bgColor: root.tooltipBgColor
    borderColor: root.tooltipBorderColor
    textColor: root.tooltipTextColor
    fontFamily: root.fontFamily
  }
}
