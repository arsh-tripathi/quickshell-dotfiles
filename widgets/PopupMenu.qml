import Quickshell
import Quickshell.Hyprland
import QtQuick

PopupWindow {
    id: root
    property bool hoveringButton: false
    property bool clickedButton: false
    property bool hovered: hover.hovered
    visible: hover.hovered || hoveringButton || clickedButton
    HoverHandler {
        id: hover
    }
    HyprlandFocusGrab {
        id: grab
        windows: [ root ]
        active: root.hovered
    }
}
