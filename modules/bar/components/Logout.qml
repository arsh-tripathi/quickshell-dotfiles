import QtQuick.Controls
import QtQuick

Button {
    id: logout
    text: "⏻"
    background: Rectangle {
        color: "#C44658"
        anchors.fill: parent
        radius: 15
    }
    contentItem: Text {
        text: logout.text
        color: "white"
        font {
            pointSize: 10
            family: "FiraCodeNerdFont"
            bold: false
        }
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenterOffset: -1.5
        anchors.verticalCenterOffset: -1
    }
    implicitHeight: 30
    implicitWidth: 30
}
