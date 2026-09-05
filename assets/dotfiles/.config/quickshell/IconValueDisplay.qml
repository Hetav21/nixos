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
  property var anchorWindow: null
  property string tooltipFontFamily: "Ubuntu, sans-serif"
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
    onClicked: {
      tooltip.hide();
      if (root.clickable) root.itemClicked();
    }
    onEntered: if (root.tooltipText !== "") tooltip.show()
    onExited: tooltip.hide()
  }

  StyledToolTip {
    id: tooltip
    anchorWindow: root.anchorWindow
    anchorItem: root
    text: root.tooltipText
    bgColor: root.tooltipBgColor
    borderColor: root.tooltipBorderColor
    textColor: root.tooltipTextColor
    fontFamily: root.tooltipFontFamily
  }
}
