import QtQuick
import QtQuick.Controls
import qs.services
import qs.utils

Button {
    id: network
    text: Network.active ? Icons.getNetworkIcon(Network.active.strength) : "󰤫"
    background: Rectangle {
        color: "white"
        anchors.fill: parent
        topLeftRadius: 15
        topRightRadius: 15
    }
    contentItem: Text {
        text: network.text
        color: "#C44658"
        font {
            pointSize: 12
            family: "FiraCodeNerdFont"
            bold: false
        }
        anchors.centerIn: parent
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenterOffset: -2.5
    }
    implicitHeight: 40
    implicitWidth: 30
}
