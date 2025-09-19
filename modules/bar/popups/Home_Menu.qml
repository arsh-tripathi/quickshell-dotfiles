import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.widgets
import qs.services
import qs.utils

PopupMenu {
    id: home_popup
    required property var screen
    implicitHeight: 400
    implicitWidth: 400
    onVisibleChanged: {
        calendar.refreshTasks()
        Utils.refreshLapBri = true;
        Utils.refreshScreenBri = true;
        Utils.refreshVolume = true;
        Utils.refresh = visible;
    }
    ColumnLayout {
        RowLayout {
            Text {
                text: "󰃞 "
            }
            Slider {
                id: brightnessSlider
                from: 1
                to: 100
                value: home_popup.screen.name === "eDP-1" ? Utils.laptopBrigtness : Utils.screenBrightness
                stepSize: 1.0
                onMoved: if (pressed) Utils.setBrightness(home_popup.screen.name, value)
            }
        }
        RowLayout {
            Button {
                text: (Utils.muted || Utils.volume === 0) ? " " : " "
                implicitHeight: 30
                implicitWidth: 30
                onClicked: Utils.toggleMute()
            }
            Slider {
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
