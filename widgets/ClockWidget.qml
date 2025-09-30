import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Item {
    width: 200
    height: 200
    id: clock
    required property int hours
    required property int minutes
    required property int seconds

    property real hourAngle: (hours % 12 + minutes  / 60.0) * 30
    property real minuteAngle: (minutes + seconds / 60.0) * 6
    property real secondAngle: seconds * 6
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.color: "#1E1E1E"
    }

    Rectangle {
        id: hour
        width: 6
        height: clock.height * 0.25
        radius: 3
        color: "black"
        anchors.centerIn: parent
        transform: [
            Rotation {
                angle: clock.hourAngle + 180
                origin.x: hour.width / 2
            },
            Translate {
                y: hour.height / 2
            }
        ]
    }

    // minute hand
    Rectangle {
        id: minute
        width: 4
        height: clock.height * 0.35
        radius: 2
        color: "darkblue"
        anchors.centerIn: parent
        transform: [
            Rotation {
                angle: clock.minuteAngle + 180
                origin.x: minute.width / 2
            },
            Translate {
                y: minute.height / 2
            }

        ]
    }

    // second hand
    Rectangle {
        id: second
        width: 2
        height: clock.height * 0.40
        color: "red"
        anchors.centerIn: parent
        transform: [
            Rotation {
                angle: clock.secondAngle + 180
                origin.x: second.width / 2
            },
            Translate {
                y: second.height / 2
            }
        ]
    }

    // center dot
    Rectangle {
        width: 10
        height: 10
        radius: 5
        color: "black"
        anchors.centerIn: parent
    }
}
