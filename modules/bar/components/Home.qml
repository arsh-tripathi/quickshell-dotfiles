import QtQuick.Controls
import QtQuick

Button {
    id: home
    text: "󰣇 "
    background: Rectangle {
        color: "#C44658"
        anchors.fill: parent
        radius: 15
    }
    contentItem: Text {
        text: home.text
        color: "white"
        font {
            pointSize: 15
            family: "FiraCodeNerdFont"
            bold: false
        }
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenterOffset: 3.5
    }
    implicitHeight: 30
    implicitWidth: 30
}
