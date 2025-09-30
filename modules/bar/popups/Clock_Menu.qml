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
    implicitHeight: 150
    implicitWidth: 450
    ScrollView {
        height: 150
        width: 450
        ColumnLayout {
            id: times
            property int numTimers: 0
            property list<TimerInfo> timers
            ClockWidget {
                hours: Time.hours
                minutes: Time.minutes
                seconds: Time.seconds
            }
            Repeater {
                model: [
                    ["America/Toronto", "EDT"],
                    ["Asia/Kolkata", "IST"],
                    ["UTC", "UTC"]
                ]
                Text {
                    required property var modelData
                    text: "[" + modelData[1] + "] " + Time.offsetAndFormat(modelData[0], "hh:mm:ss ddd MMM dd yyyy")
                    font.family: "FiraCodeNerdFont"
                }
            }
            RowLayout {
                id: stopwatch
                property bool running: false
                property int seconds: 0
                Text {
                    text: "Stopwatch"
                }
                Text {
                    text: {
                        const hours = Math.floor(stopwatch.seconds / 3600);
                        const minutes = Math.floor((stopwatch.seconds % 3600) / 60);
                        const seconds = stopwatch.seconds % 60;
                        const hoursText = ((hours < 10) ? "0" : "") + hours;
                        const minutesText = ((minutes < 10) ? "0" : "") + minutes;
                        const secondsText = ((seconds < 10) ? "0" : "") + seconds;
                        return hoursText + ":" + minutesText + ":" + secondsText;
                    }
                }
                Button {
                    text: "Start"
                    implicitWidth: 50
                    onClicked: stopwatch.running = true;
                }
                Button {
                    text: "Stop"
                    implicitWidth: 50
                    onClicked: stopwatch.running = false;
                }
                Button {
                    text: "Reset"
                    implicitWidth: 50
                    onClicked: stopwatch.seconds = 0;
                }
                Component.onCompleted: {
                    Time.tick.connect(() => {
                        if (stopwatch.running) stopwatch.seconds += 1;
                    })
                }
            }
            Button {
                text: "Add Timer"
                onClicked: times.timers.push(timerInfo.createObject(times, {}))
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
