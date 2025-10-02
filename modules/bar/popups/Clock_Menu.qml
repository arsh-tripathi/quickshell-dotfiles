pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.utils
import qs.widgets
import qs.services

PopupMenu {
    id: clock_popup
    implicitHeight: 350
    implicitWidth: 450
    backgroundColor: "#1E1E1E"
    ScrollView {
        height: 350
        width: 450
        ColumnLayout {
            id: times
            property int numTimers: 0
            property int currTimer: -1
            property list<TimerInfo> timers
            RowLayout {
                id: timeRow
                property string currentTZ: "America/Toronto"
                ClockWidget {
                    id: clock
                    Layout.leftMargin: 10
                    hours: parseInt(Time.offsetAndFormat(timeRow.currentTZ, "hh"))
                    minutes: parseInt(Time.offsetAndFormat(timeRow.currentTZ, "mm"))
                    seconds: parseInt(Time.offsetAndFormat(timeRow.currentTZ, "ss"))
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Repeater {
                        model: [
                            ["America/Toronto", "EDT"],
                            ["Asia/Kolkata", "IST"],
                            ["UTC", "UTC"]
                        ]
                        TimeZoneInfo {
                            id: timeZone
                            currentTZ: timeRow.currentTZ
                            onClicked: timeRow.currentTZ = modelData[0];
                            
                        }
                    }
                }
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Stopwatch"
                leftPadding: 10
                rightPadding: 10
                background: Rectangle {
                    color: "white"
                    radius: 5
                }
                font {
                    pointSize: 12
                    family: "FiraCodeNerdFont"
                }
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                color: (stopwatch.running) ? "#C44658" : "white"
                text: {
                    const hours = Math.floor(stopwatch.seconds / 3600);
                    const minutes = Math.floor((stopwatch.seconds % 3600) / 60);
                    const seconds = stopwatch.seconds % 60;
                    const hoursText = ((hours < 10) ? "0" : "") + hours;
                    const minutesText = ((minutes < 10) ? "0" : "") + minutes;
                    const secondsText = ((seconds < 10) ? "0" : "") + seconds;
                    return hoursText + ":" + minutesText + ":" + secondsText;
                }
                font {
                    pointSize: 12
                    family: "FiraCodeNerdFont"
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                id: stopwatch
                property bool running: false
                property int seconds: 0
                Button {
                    id: pause
                    text: ""
                    implicitWidth: pause.height
                    onClicked: stopwatch.running = false;
                    contentItem: Text {
                        text: pause.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            pointSize: 12
                            family: "FiraCodeNerdFont"
                        }
                    }
                    background: Rectangle {
                        radius: pause.height / 2
                        color: "white"
                    }
                }
                Button {
                    id: play
                    text: ""
                    implicitWidth: play.height
                    onClicked: stopwatch.running = true;
                    contentItem: Text {
                        text: play.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            pointSize: 12
                            family: "FiraCodeNerdFont"
                        }
                    }
                    background: Rectangle {
                        radius: play.height / 2
                        color: "white"
                    }
                }
                Button {
                    id: replay
                    text: ""
                    implicitWidth: replay.height
                    onClicked: stopwatch.seconds = 0;
                    contentItem: Text {
                        text: replay.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            pointSize: 12
                            family: "FiraCodeNerdFont"
                        }
                    }
                    background: Rectangle {
                        radius: replay.height / 2
                        color: "white"
                    }
                }
                Component.onCompleted: {
                    Time.tick.connect(() => {
                        if (stopwatch.running) stopwatch.seconds += 1;
                    })
                }
            }
            RowLayout {
                Layout.preferredWidth: 400
                Layout.fillWidth: true
                spacing: 20
                TimerWidget {
                    id: timerClock
                    totalHours: 0
                    totalMinutes: 0
                    totalSeconds: 0
                    hours: 0
                    minutes: 0
                    seconds: 0
                }
                ColumnLayout {
                    id: tInfo
                    Layout.fillWidth: true
                    Button {
                        id: addTimer
                        Layout.fillWidth: true
                        text: "+ Add Timer"
                        onClicked: {
                            times.timers.push(timerInfo.createObject(times, {}))
                            times.currTimer = times.timers.length - 1
                        }
                        contentItem: Text {
                            text: addTimer.text
                            color: "white"
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: "transparent"
                            border.color: "white"
                            border.width: 1
                            radius: addTimer.height / 2
                        }
                    }
                    property TimerInfo currTimerInfo: times.currTimer !== -1 ? times.timers[times.currTimer] : null
                    Loader {
                        Layout.fillWidth: true
                        active: times.currTimer !== -1
                        sourceComponent: Label {
                            id: timerName
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            text: tInfo.currTimerInfo.name
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                            background: Rectangle {
                                color: "white"
                                radius: timerName.height / 2
                            }
                        }
                    }
                    Loader {
                        Layout.fillWidth: true
                        active: times.currTimer !== -1
                        sourceComponent: Text {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            text: {
                                const hoursText = ((tInfo.currTimerInfo.hours < 10) ? "0" : "") + tInfo.currTimerInfo.hours;
                                const minutesText = ((tInfo.currTimerInfo.minutes < 10) ? "0" : "") + tInfo.currTimerInfo.minutes;
                                const secondsText = ((tInfo.currTimerInfo.seconds < 10) ? "0" : "") + tInfo.currTimerInfo.seconds;
                                return hoursText + ":" + minutesText + ":" + secondsText;
                            }
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                        }
                    }
                    Loader {
                        active: times.currTimer !== -1
                        sourceComponent: RowLayout {
                        }
                    }
                }
            }
            Repeater {
                model: times.timers
                RowLayout {
                    id: timer
                    required property TimerInfo modelData
                    required property int index
                    Text {
                        visible: !timer.modelData.editing
                        text: Utils.fitString(timer.modelData.name, 20)
                    }
                    TextField {
                        id: nameField
                        visible: timer.modelData.editing
                        text: timer.modelData.name
                        Keys.onReturnPressed: timer.modelData.name = text
                    }
                    Text {
                        visible: !timer.modelData.editing
                        text: {
                            const hoursText = ((timer.modelData.hours < 10) ? "0" : "") + timer.modelData.hours;
                            const minutesText = ((timer.modelData.minutes < 10) ? "0" : "") + timer.modelData.minutes;
                            const secondsText = ((timer.modelData.seconds < 10) ? "0" : "") + timer.modelData.seconds;
                            return hoursText + ":" + minutesText + ":" + secondsText;
                        }
                        font.family: "FiraCodeNerdFont"
                    }
                    RowLayout {
                        visible: timer.modelData.editing
                        SpinBox {
                            id: hours
                            editable: true
                            implicitWidth: 50
                            from: 0
                            to: 99
                            value: timer.modelData.hours

                            validator: IntValidator { bottom: 0; top: 99 }

                            textFromValue: function(value) {
                                return value.toString().padStart(2, "0")
                            }

                            valueFromText: function(text) {
                                return parseInt(text)
                            }
                        }
                        SpinBox {
                            id: minutes
                            editable: true
                            from: 0
                            to: 59
                            value: timer.modelData.minutes
                            implicitWidth: 50

                            validator: IntValidator { bottom: 0; top: 59 }

                            textFromValue: function(value) {
                                return value.toString().padStart(2, "0")
                            }

                            valueFromText: function(text) {
                                return parseInt(text)
                            }
                        }
                        SpinBox {
                            id: seconds
                            editable: true
                            from: 0
                            to: 59
                            value: timer.modelData.seconds
                            implicitWidth: 50

                            validator: IntValidator { bottom: 0; top: 59 }

                            textFromValue: function(value) {
                                return value.toString().padStart(2, "0")
                            }

                            valueFromText: function(text) {
                                return parseInt(text)
                            }
                        }
                    }
                    Button {
                        visible: !timer.modelData.editing
                        text: "Start"
                        implicitWidth: 50
                        onClicked: timer.modelData.running = true;
                    }
                    Button {
                        visible: !timer.modelData.editing
                        text: "Stop"
                        implicitWidth: 50
                        onClicked: timer.modelData.running = false;
                    }
                    Button {
                        text: (timer.modelData.editing) ? "Save" : "Edit"
                        implicitWidth: 50
                        onClicked: {
                            timer.modelData.running = false;
                            timer.modelData.editing = !timer.modelData.editing;
                            if (!timer.modelData.editing) {
                                timer.modelData.name = nameField.text
                                timer.modelData.totalSeconds = hours.value * 3600 + minutes.value * 60 + seconds.value;
                                timer.modelData.secondsLeft = timer.modelData.totalSeconds;
                            }
                        }
                    }
                    Button {
                        visible: !timer.modelData.editing
                        text: "Reset"
                        implicitWidth: 50
                        onClicked: timer.modelData.secondsLeft = timer.modelData.totalSeconds;
                    }
                    Button {
                        text: "Delete"
                        implicitWidth: 50
                        onClicked: {
                            var timers = times.timers
                            timers.splice(timer.index, 1)
                        }
                    }
                    Component.onCompleted: {
                        Time.tick.connect(() => {
                            if (!timer || timer.modelData.secondsLeft === 0) timer.modelData.running = false;
                            if (timer && timer.modelData.running) timer.modelData.secondsLeft -= 1
                        })
                    }
                }
            }
        }
    }
    component TimerInfo: QtObject {
        property int totalSeconds: 0
        property int secondsLeft: 0
        readonly property int hours: Math.floor(secondsLeft / 3600)
        readonly property int minutes: Math.floor((secondsLeft % 3600) / 60)
        readonly property int seconds: secondsLeft % 60
        property bool running: false
        property bool editing: false
        property string name: "Timer"
    }

    Component {
        id: timerInfo
        TimerInfo {}
    }

    onVisibleChanged: if (visible) Time.updateOffsets()
}
