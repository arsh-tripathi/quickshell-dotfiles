import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets
import qs.services

PopupMenu {
    id: clock_popup
    implicitHeight: 120
    implicitWidth: 200
    ColumnLayout {
        id: times
        Instantiator {
            model: [
                ["America/Toronto", "EDT"],
                ["Asia/Kolkata", "IST"],
                ["UTC", "UTC"]
            ]
            ClockWidget {
                id: clock
                required property var modelData
                timeZone: modelData[0]
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.running = true
                }
                Text {
                    text: "[" + clock.modelData[1] + "]" + clock.hours + ":" + clock.minutes + ":" + clock.seconds + " " + 
                          clock.day + " " + clock.date + " " + clock.monthName + " " + clock.year
                }
            }
            onObjectAdded: (index, object) => object.parent = times
        }
    }
}
