import QtQuick
import QtQuick.Controls
import qs.services

Button {
    id: clock
    text: Time.format("hh\nmm")
    background: Rectangle {
        color: "transparent"
    }
    contentItem: Text {
        text: clock.text
        color: "#ff3b57"
        font {
            pointSize: 14
            family: "FiraCodeNerdFont"
            bold: false
        }
        anchors.centerIn: parent
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 1.2
        // anchors.horizontalCenterOffset: -2.5
    }
    implicitHeight: 60
    implicitWidth: 30
}
