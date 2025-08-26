import QtQuick
import QtQuick.Controls

Label {
    ToolTip.delay: 1000
    ToolTip.visible: hover.containsMouse
    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
    }
}

