pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services

ColumnLayout {
    id: workspaces
    required property var screen
    Repeater {
        model: Hyprland.workspaces
        Button {
            required property var modelData
            text: ((modelData.focused) ? "F:" : (modelData.active) ? "A:" : (modelData.urgent) ? "U:" : "") + modelData.id
            visible: {
                modelData.monitor === Hyprland.monitorFor(workspaces.screen)
            }
            implicitHeight: 30
            implicitWidth: 30
            onClicked: modelData.activate()
        }
    }
}
