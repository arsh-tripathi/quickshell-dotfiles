import QtQuick
import QtQuick.Controls

Switch {
    id: root
    contentItem: Text {
        text: root.text
        opacity: enabled ? 1.0 : 0.3
        color: "white"
        font {
            pointSize: 12
            family: "FiraCodeNerdFont"
        }
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        rightPadding: root.indicator.width + root.spacing
    }
    indicator: Rectangle {
        implicitWidth: 40
        implicitHeight: 20
        x: root.width - width - root.rightPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: root.checked ? "#C44658" : "#ffffff"
        border.color: root.checked ? "#C44658" : "#cccccc"

        Rectangle {
            x: root.checked ? parent.width - width : 0
            width: 20
            height: 20
            radius: 10
            color: root.down ? "#cccccc" : "#ffffff"
            border.color: root.checked ? "#C44658" : "#999999"
        }
    }

}
