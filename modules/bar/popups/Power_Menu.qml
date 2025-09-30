import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets
import qs.utils
import qs.services

PopupMenu {
    id: power_popup
    implicitHeight: 200
    implicitWidth: 400
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
    backgroundColor: "#1E1E1E"
    onVisibleChanged: Profiles.getProfile()
    ColumnLayout {
        anchors.fill: parent
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "white"
            text: power_popup.charge + "%"
            font {
                pointSize: 18
                family: "FiraCodeNerdFont"
                bold: false
            }
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: "white"
            font {
                pointSize: 10
                family: "FiraCodeNerdFont"
                bold: false
            }
            text: {
                if (power_popup.state === power_popup.charging) 
                    return "Charging (" + 
                        Utils.getTimeStr(UPower.displayDevice.timeToFull) + 
                        " left)";
                else if (power_popup.state === power_popup.plugged && power_popup.charge === 100)
                    return "Plugged In";
                else if (power_popup.state === power_popup.plugged && power_popup.charge !== 100)
                    return "Not Charging";
                else 
                    return "Discharging (" + 
                        Utils.getTimeStr(UPower.displayDevice.timeToFull) + 
                        " left)";
            }
        }
        RowLayout {
            id: power_profiles
            Layout.alignment: Qt.AlignHCenter
            property string curr: Profiles.current
            spacing: 40
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
                background: Rectangle {
                    color: power_profiles.curr === performance.profile ? "#C44658" : "white"
                    anchors.fill: parent
                    radius: 15
                }
                contentItem: Text {
                    text: performance.text
                    color: power_profiles.curr === performance.profile ? "white" : "#1E1E1E"
                    font {
                        pointSize: 10
                        family: "FiraCodeNerdFont"
                        bold: false
                    }
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenterOffset: 2
                    // anchors.verticalCenterOffset: -1
                }
                ToolTip {
                    delay: 1000
                    visible: performance.hovered
                    text: "Performance"
                }
                implicitHeight: 30
                implicitWidth: 30
            }
            Button {
                id: balanced
                property string profile: Profiles.balanced
                text: " "
                implicitHeight: 30
                implicitWidth: 30
                ToolTip {
                    delay: 1000
                    visible: balanced.hovered
                    text: "Balanced"
                }
                background: Rectangle {
                    color: power_profiles.curr === balanced.profile ? "#C44658" : "white"
                    anchors.fill: parent
                    radius: 15
                }
                contentItem: Text {
                    text: balanced.text
                    color: power_profiles.curr === balanced.profile ? "white" : "#1E1E1E"
                    font {
                        pointSize: 10
                        family: "FiraCodeNerdFont"
                        bold: false
                    }
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    // anchors.horizontalCenterOffset: 2
                    // anchors.verticalCenterOffset: -1
                }
            }
            Button {
                id: power_saving
                property string profile: Profiles.power_saving
                text: "󰌪 "
                implicitHeight: 30
                implicitWidth: 30
                ToolTip {
                    delay: 1000
                    visible: power_saving.hovered
                    text: "Power Saving"
                }
                background: Rectangle {
                    color: power_profiles.curr === power_saving.profile ? "#C44658" : "white"
                    anchors.fill: parent
                    radius: 15
                }
                contentItem: Text {
                    text: power_saving.text
                    color: power_profiles.curr === power_saving.profile ? "white" : "#1E1E1E"
                    font {
                        pointSize: 10
                        family: "FiraCodeNerdFont"
                        bold: false
                    }
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenterOffset: 2
                    // anchors.verticalCenterOffset: -1
                }
            }
        }
    }
}
