import QtQuick.Controls
import QtQuick
import Quickshell.Services.UPower
import qs.utils

Button {
    id: power
    text: Icons.getBatteryIcon(UPower.displayDevice.percentage)
    background: Rectangle {
        color: "white"
        anchors.fill: parent
        bottomLeftRadius: 15
        bottomRightRadius: 15
    }
    contentItem: Text {
        text: power.text
        color: "#C44658"
        font {
            pointSize: 12
            family: "FiraCodeNerdFont"
            bold: false
        }
        anchors.centerIn: parent
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
    }
    implicitHeight: 40
    implicitWidth: 30
}
