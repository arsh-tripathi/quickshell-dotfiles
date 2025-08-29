import Quickshell
import QtQuick.Layouts
import "components"
import "popups"
import qs.config
import qs.widgets

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
        Clock {
            id: clock
            Clock_Menu {
                id: clock_menu
                anchor.window: bar
                anchor.rect.x: clock.width
                anchor.rect.y: list.y + clock.y
            }
            HoverButtonHandler {
                menu_id: clock_menu
            }
        }
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
        Power {
            id: power
            Power_Menu {
                id: power_menu
                anchor.window: bar
                anchor.rect.x: power.width
                anchor.rect.y: list.y + power.y
            }
            HoverButtonHandler {
                menu_id: power_menu
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
