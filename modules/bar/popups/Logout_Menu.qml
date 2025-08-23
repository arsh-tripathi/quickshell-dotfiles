import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PopupWindow {
    id: logout_popup
    implicitHeight: 120
    visible: false
    Rectangle {
        ColumnLayout {
            Button {
                id: poweroff
                text: "Power off"
                onClicked: {
                    logout_popup.visible = false;
                    poweroff_cmd.running = true;
                }
            }
            Button {
                id: logout
                text: "Logout"
                onClicked: {
                    logout_popup.visible = false;
                    logout_cmd.running = true;
                }
            }
            Button {
                id: lock
                text: "Lock"
                onClicked: {
                    logout_popup.visible = false;
                    lock_cmd.running = true;
                }
            }
            Button {
                id: restart
                text: "Restart"
                onClicked: {
                    logout_popup.visible = false;
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
