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
        Bluetooth {
            id: bluetooth
            // onClicked: bluetooth_menu.clickedButton = !bluetooth_menu.clickedButton
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
            onClicked: logout_popup.visible = !logout_popup.visible
            Logout_Menu {
                id: logout_popup
                anchor.window: bar
                anchor.rect.x: logout.width
                anchor.rect.y: list.y + logout.y
            }
        }
    }

    color: BarConfig.barColor
}
