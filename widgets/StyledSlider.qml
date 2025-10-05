import QtQuick
import QtQuick.Controls

Slider {
    id: control
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 20
        width: control.availableWidth
        height: implicitHeight
        radius: 10
        color: "white"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#C44658"
            topLeftRadius: 10
            bottomLeftRadius: 10
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }
}
