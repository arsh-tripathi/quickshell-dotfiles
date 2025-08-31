pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: tray
    required property QtObject parentWindow
    required property int trayWidth
    required property int trayYoffset
    Repeater {
        model: SystemTray.items
        Button {
            id: item
            required property var modelData
            visible: modelData.status !== Status.Passive
            implicitHeight: 30
            implicitWidth: 30
            IconImage {
                source: item.modelData.icon
                implicitSize: 30
            }
            text: {
                console.log(modelData.icon)
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                hoverEnabled: true
                onClicked: (mouse) => {
                    if (item.modelData.onlyMenu)
                        item.modelData.display(tray.parentWindow, tray.trayWidth, tray.trayYoffset + item.y)
                    if (mouse.button === Qt.LeftButton)
                        item.modelData.activate()
                    else if (mouse.button === Qt.MiddleButton)
                        item.modelData.secondaryActivate()
                    else if (mouse.button === Qt.RightButton && item.modelData.hasMenu)
                        item.modelData.display(tray.parentWindow, tray.trayWidth, tray.trayYoffset + item.y)
                }
                ToolTip.text: item.modelData.title + "\n" + item.modelData.tooltipTitle + "\n" + 
                              item.modelData.tooltipDescription
                ToolTip.delay: 1000
                ToolTip.visible: item.hovered
            }
        }
    }
}
