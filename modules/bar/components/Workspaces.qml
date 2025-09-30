pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Hyprland
import qs.services
import qs.config

ColumnLayout {
    id: workspaces
    required property var screen
    Repeater {
        model: Hyprland.workspaces
        Button {
            id: workspace
            required property var modelData
            text: modelData.id
            visible: {
                if (!modelData.monitor) {
                    Hyprland.refreshMonitors();
                    Hyprland.refreshToplevels();
                    Hyprland.refreshWorkspaces();
                    return false;
                }
                return modelData.monitor.name === workspaces.screen.name
            }
            background: Rectangle {
                color: (workspace.modelData.focused) ? "white" :
                       (workspace.modelData.urgent)  ? "#C44658" : "transparent"
                anchors.fill: parent
                radius: 15
                border.color: (workspace.modelData.active || workspace.modelData.urgent) && !(workspace.modelData.focused) ? "#C44658" : "white"
            }
            contentItem: Text {
                text: workspace.text
                color: (workspace.modelData.focused) ? BarConfig.barColor : "white"
                font {
                    pointSize: 10
                    family: "FiraCodeNerdFont"
                    bold: false
                }
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            implicitHeight: 20
            implicitWidth: 20
            onClicked: modelData.activate()
        }
    }
}
