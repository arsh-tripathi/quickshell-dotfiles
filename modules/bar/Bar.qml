import Quickshell
import QtQuick
import QtQuick.Layouts
import "components"
import "popups"
import qs.config
import qs.widgets


Variants {
    model: Quickshell.screens
    delegate: Component {
        PanelWindow {
            required property var modelData

            screen: modelData

            id: bar
            implicitWidth: 30

            anchors {
                left: true
                top: true
                bottom: true
            }
            ColumnLayout {
                id: topList
                anchors.top: parent.top
                Home {
                    id: home
                    Home_Menu {
                        id: home_menu
                        screen: bar.modelData
                        anchor.window: bar
                        anchor.rect.x: home.width
                        anchor.rect.y: topList.y + home.y
                    }
                    HoverButtonHandler {
                        menu_id: home_menu
                    }
                }
                Tray {
                    id: systemTray
                    parentWindow: bar
                    trayWidth: 30
                    trayYoffset: systemTray.y
                }
            }
            Workspaces {
                id: workspaces
                screen: bar.modelData
                anchors.centerIn: parent
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

    }
}
