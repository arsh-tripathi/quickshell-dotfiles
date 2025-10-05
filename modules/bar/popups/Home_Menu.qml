import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.widgets
import qs.services
import qs.utils

PopupMenu {
    id: home_popup
    required property var screen
    backgroundColor: "#1E1E1E"
    implicitHeight: 500
    implicitWidth: 400
    onVisibleChanged: {
        calendar.refreshTasks()
        Utils.refreshLapBri = true;
        Utils.refreshScreenBri = true;
        Utils.refreshVolume = true;
        Utils.refresh = visible;
        SystemUsage.refCount += (visible) ? 1 : -1
    }
    ColumnLayout {
        RowLayout {
            Layout.margins: 10
            SysInfoPie {
                usage: SystemUsage.cpuPerc
                total: 1
                symbol: ""
            }
            SysInfoPie {
                usage: SystemUsage.memUsed
                total: SystemUsage.memTotal
                symbol: ""
            }
            SysInfoPie {
                usage: SystemUsage.storageUsed
                total: SystemUsage.storageTotal
                symbol: ""
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Text {
                text: "󰃟"
                color: "white"
                Layout.preferredWidth: 30
                font {
                    pointSize: 15
                    family: "FiraCodeNerdFont"
                }
                horizontalAlignment: Text.AlignHCenter
            }
            StyledSlider {
                Layout.fillWidth: true
                id: brightnessSlider
                from: 1
                to: 100
                value: home_popup.screen.name === "eDP-1" ? Utils.laptopBrigtness : Utils.screenBrightness
                stepSize: 1.0
                onMoved: if (pressed) Utils.setBrightness(home_popup.screen.name, value)
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Button {
                id: muteControl
                text: (Utils.muted || Utils.volume === 0) ? " " : " "
                implicitHeight: 30
                implicitWidth: 30
                onClicked: Utils.toggleMute()
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Text {
                    text: muteControl.text
                    color: "white"
                    font {
                        pointSize: 15
                        family: "FiraCodeNerdFont"
                    }
                }
            }
            StyledSlider {
                Layout.fillWidth: true
                id: volume
                from: 0
                to: 100
                value: Utils.volume
                stepSize: 1.0
                onMoved: {
                    if (pressed) {
                        if (Utils.muted) Utils.toggleMute()
                        Utils.setVolume(value)
                    }
                }
            }
        }
        CalendarWidget {
            id: calendar
        }
    }
}
