import Quickshell
import QtQuick
import QtQuick.Layouts
import "./components"
import "./popups"
import "../../config"
import "../../widgets"

PanelWindow {
    id: bar
    implicitWidth: 30

    anchors {
        left: true
        top: true
        bottom: true
    }
    ColumnLayout {
        id: list
        anchors.bottom: parent.bottom
        Network {
            id: network
            Network_Menu {
                id: network_menu
                anchor.window: bar
                anchor.rect.x: network.width
                anchor.rect.y: list.y + bluetooth.y
            }
            HoverButtonHandler {
                menu_id: network_menu
            }
        }
        Bluetooth {
            id: bluetooth
            Bluetooth_Menu {
                id: bluetooth_menu
                anchor.window: bar
                anchor.rect.x: bluetooth.width
                anchor.rect.y: list.y + bluetooth.y
            }
            HoverButtonHandler {
                menu_id: bluetooth_menu
            }
        }
        Logout {
            id: logout
            Logout_Menu {
                id: logout_menu
                anchor.window: bar
                anchor.rect.x: logout.width
                anchor.rect.y: list.y + logout.y
            }
            HoverButtonHandler {
                menu_id: logout_menu
            }
        }
    }

    color: BarConfig.barColor
}
