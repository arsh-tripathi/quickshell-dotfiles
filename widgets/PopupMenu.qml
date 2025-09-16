import Quickshell
import Quickshell.Hyprland
import QtQuick

PopupWindow {
    id: root
    property bool hoveringButton: false
    property bool clickedButton: false
    property bool hovered: hover.hovered
    visible: hover.hovered || hoveringButton || clickedButton
    property alias contentItem: content
    default property alias content: content.data
    Item {
        id: content
        anchors.fill: parent
        opacity: 1
        transformOrigin: Item.Left
        states: [
            State {
                name: "open"
                when: root.visible
                PropertyChanges { 
                    target: content;
                    opacity: 1;
                    scale: 1;
                }
            },
            State {
                name: "closed"
                when: !root.visible
                PropertyChanges { 
                    target: content;
                    opacity: 0;
                    scale: 0.6;
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    properties: "opacity,scale";
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        ]
        Rectangle {
            anchors.fill: parent
            color: "white"
        }
    }
    HoverHandler {
        id: hover
    }
    HyprlandFocusGrab {
        id: grab
        windows: [ root ]
        active: root.hovered
    }
    color: "transparent"
}
