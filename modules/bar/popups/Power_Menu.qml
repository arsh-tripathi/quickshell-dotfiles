import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets
import qs.utils
import qs.services

PopupMenu {
    id: power_popup
    implicitHeight: 60
    implicitWidth: 150
    readonly property int charging: 0
    readonly property int plugged: 1
    readonly property int discharging: 2
    property int charge: UPower.displayDevice.percentage * 100
    property int state: {
        const changeRate = UPower.displayDevice.changeRate;
        if (changeRate > 0) return charging;
        else if (changeRate === 0) return plugged
        else return discharging;
    }
    onVisibleChanged: Profiles.getProfile()
    ColumnLayout {
        Text {
            text: {
                if (power_popup.state === power_popup.charging) 
                    return power_popup.charge + 
                    "%: Charging (" + 
                    Utils.getTimeStr(UPower.displayDevice.timeToFull) + 
                    " left)";
                else if (power_popup.state === power_popup.plugged && power_popup.charge === 100)
                    return power_popup.charge + "%: Plugged";
                else if (power_popup.state === power_popup.plugged && power_popup.charge !== 100)
                    return power_popup.charge + "%: Not Charging";
                else 
                    return power_popup.charge + 
                    "%: Discharging (" + 
                    Utils.getTimeStr(UPower.displayDevice.timeToFull) + 
                    " left)";
            }
        }
        RowLayout {
            id: power_profiles
            property string curr: Profiles.current
            ButtonGroup {
                buttons: power_profiles.children
                onClicked: button => {
                    Profiles.current = button.profile;
                    Profiles.setProfile();
                }
            }
            Button {
                id: performance
                property string profile: Profiles.performance
                text: "󱓞 "
                implicitHeight: 30
                implicitWidth: 30
                background: Rectangle {
                    color: power_profiles.curr === performance.profile ? "green" : "white"
                }
            }
            Button {
                id: balanced
                property string profile: Profiles.balanced
                text: " "
                implicitHeight: 30
                implicitWidth: 30
                background: Rectangle {
                    color: power_profiles.curr === balanced.profile ? "green" : "white"
                }
            }
            Button {
                id: power_saving
                property string profile: Profiles.power_saving
                text: "󰌪 "
                implicitHeight: 30
                implicitWidth: 30
                background: Rectangle {
                    color: power_profiles.curr === power_saving.profile ? "green" : "white"
                }
            }
        }
    }
}
