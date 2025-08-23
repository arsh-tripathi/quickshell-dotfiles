import Quickshell
import QtQuick

PopupWindow {
    id: root
    property bool hoveringButton: false
    property bool clickedButton: false
    visible: ((hover.hovered || hoveringButton) || clickedButton)
    HoverHandler {
        id: hover
    }
}
