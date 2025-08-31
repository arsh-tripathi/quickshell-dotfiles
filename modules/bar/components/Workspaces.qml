import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services

ColumnLayout {
    id: workspaces
    Repeater {
        model: Hyprland.workspaces
        Button {
            required property var modelData;
            text: ((modelData.focused) ? "F:" : (modelData.active) ? "A:" : (modelData.urgent) ? "U:" : "") + modelData.id
            implicitHeight: 30
            implicitWidth: 30
            onClicked: modelData.activate()
        }
    }
}
