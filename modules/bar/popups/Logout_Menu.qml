import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets

PopupMenu {
    id: logout_popup
    implicitHeight: 120
    Rectangle {
        ColumnLayout {
            Button {
                id: poweroff
                text: "Power off"
                onClicked: {
                    poweroff_cmd.running = true;
                }
            }
            Button {
                id: logout
                text: "Logout"
                onClicked: {
                    logout_cmd.running = true;
                }
            }
            Button {
                id: lock
                text: "Lock"
                onClicked: {
                    lock_cmd.running = true;
                }
            }
            Button {
                id: restart
                text: "Restart"
                onClicked: {
                    restart_cmd.running = true;
                }
            }
        }
        Process {
            id: poweroff_cmd
            running: false
            command: ["systemctl", "poweroff"] 
        }
        Process {
            id: logout_cmd
            running: false
            command: ["hyprctl", "dispatch", "exit"] 
        }
        Process {
            id: lock_cmd
            running: false
            command: ["hyprlock"] 
        }
        Process {
            id: restart_cmd
            running: false
            command: ["systemctl", "reboot"] 
        }
    }
}
