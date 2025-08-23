import QtQuick

MouseArea {
    id: hover
    hoverEnabled: true
    required property var menu_id
    anchors.fill: parent
    onEntered: menu_id.hoveringButton = true
    onExited: menu_id.hoveringButton = false
    onClicked: menu_id.clickedButton = !menu_id.clickedButton
}
