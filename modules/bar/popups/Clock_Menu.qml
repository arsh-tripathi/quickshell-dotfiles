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
    implicitHeight: 500
    implicitWidth: 450
    backgroundColor: "#1E1E1E"
    ScrollView {
        height: 500
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
                    totalHours: tInfo.currTimerInfo ? tInfo.currTimerInfo.timerHours : 0
                    totalMinutes: tInfo.currTimerInfo ? tInfo.currTimerInfo.timerMinutes : 0
                    totalSeconds: tInfo.currTimerInfo ? tInfo.currTimerInfo.timerSeconds : 0
                    hours: tInfo.currTimerInfo ? tInfo.currTimerInfo.hours : 0
                    minutes: tInfo.currTimerInfo ? tInfo.currTimerInfo.minutes : 0
                    seconds: tInfo.currTimerInfo ? tInfo.currTimerInfo.seconds : 0
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
                    property var currTimerInfo: times.currTimer !== -1 ? times.timers[times.currTimer] : null
                    Loader {
                        id: nameInfo
                        Layout.fillWidth: true
                        active: times.currTimer !== -1
                        property bool editing: false
                        readonly property Component title: Label {
                            id: timerName
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            text: tInfo.currTimerInfo ? tInfo.currTimerInfo.name : ""
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
                            Button {
                                anchors.right: timerName.right
                                anchors.rightMargin: height
                                text: ""
                                implicitHeight: timerName.height
                                implicitWidth: height
                                font {
                                    pointSize: 12
                                    family: "FiraCodeNerdFont"
                                }
                                background: Rectangle {
                                    color: "transparent"
                                    radius: timerName.height / 2
                                }
                                onClicked: {
                                    tInfo.currTimerInfo.editing += 1;
                                    nameInfo.editing = true;
                                }
                            }
                        }
                        readonly property Component edit: TextField {
                            id: timerEdit
                            text: tInfo.currTimerInfo.name
                            horizontalAlignment: Text.AlignHCenter
                            background: Rectangle {
                                color: "white"
                                radius: timerEdit.height / 2
                            }
                            activeFocusOnPress: true
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                            Button {
                                anchors.right: timerEdit.right
                                anchors.rightMargin: height
                                text: ""
                                implicitHeight: timerEdit.height
                                implicitWidth: height
                                font {
                                    pointSize: 12
                                    family: "FiraCodeNerdFont"
                                }
                                background: Rectangle {
                                    color: "transparent"
                                    radius: timerEdit.height / 2
                                }
                                onClicked: {
                                    tInfo.currTimerInfo.editing -= 1;
                                    tInfo.currTimerInfo.name = timerEdit.text
                                    nameInfo.editing = false;
                                }
                            }
                        }
                        sourceComponent: editing ? edit : title
                    }
                    Loader {
                        id: timeInfo
                        Layout.fillWidth: true
                        active: times.currTimer !== -1
                        property bool editing: false
                        readonly property Component title: Text {
                            id: timeDisplay
                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            text: {
                                if (!tInfo.currTimerInfo) return "00:00:00";
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
                            Button {
                                id: editTime
                                anchors.right: timeDisplay.right
                                anchors.rightMargin: height
                                text: ""
                                implicitHeight: timeDisplay.height
                                implicitWidth: height
                                contentItem: Text {
                                    text: editTime.text
                                    color: "white"
                                    font {
                                        pointSize: 12
                                        family: "FiraCodeNerdFont"
                                    }
                                }
                                background: Rectangle {
                                    color: "transparent"
                                    radius: timeDisplay.height / 2
                                }
                                onClicked: {
                                    tInfo.currTimerInfo.editing += 1;
                                    timeInfo.editing = true;
                                }
                            }
                        }
                        readonly property Component edit: RowLayout {
                            id: timeEdit
                            implicitHeight: timerClock.height / 2
                            spacing: 10
                            StyledTumbler {
                                id: hours
                                model: 60
                                visibleItemCount: 3
                                Component.onCompleted: {
                                    positionViewAtIndex(tInfo.currTimerInfo.timerHours, Tumbler.Center)
                                }
                            }
                            StyledTumbler {
                                id: minutes
                                model: 60
                                visibleItemCount: 3
                                Component.onCompleted: {
                                    positionViewAtIndex(tInfo.currTimerInfo.timerMinutes, Tumbler.Center)
                                }
                            }
                            StyledTumbler {
                                id: seconds
                                model: 60
                                visibleItemCount: 3
                                Component.onCompleted: {
                                    positionViewAtIndex(tInfo.currTimerInfo.timerSeconds, Tumbler.Center)
                                }
                            }
                            Button {
                                id: saveTime
                                text: ""
                                implicitWidth: height
                                Layout.alignment: Qt.AlignVCenter
                                contentItem: Text {
                                    text: saveTime.text
                                    color: "white"
                                    font {
                                        pointSize: 12
                                        family: "FiraCodeNerdFont"
                                    }
                                    verticalAlignment: Text.AlignHCenter
                                }
                                background: Rectangle {
                                    color: "transparent"
                                    radius: timeEdit.height / 2
                                }
                                onClicked: {
                                    tInfo.currTimerInfo.totalSeconds = hours.currentIndex * 3600 + minutes.currentIndex * 60 + seconds.currentIndex;
                                    tInfo.currTimerInfo.secondsLeft = tInfo.currTimerInfo.totalSeconds;
                                    tInfo.currTimerInfo.editing -= 1;
                                    timeInfo.editing = false;
                                }
                            }
                        }
                        sourceComponent: editing ? edit : title
                    }
                    Loader {
                        Layout.alignment: Qt.AlignHCenter
                        active: times.currTimer !== -1
                        sourceComponent: RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Button {
                                id: control
                                text: (tInfo.currTimerInfo && tInfo.currTimerInfo.running) ? "" : ""
                                contentItem: Text {
                                    text: control.text
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font {
                                        pointSize: 12
                                        family: "FiraCodeNerdFont"
                                    }
                                }
                                background: Rectangle {
                                    implicitWidth: 40
                                    radius: control.height / 2
                                }
                                onClicked: tInfo.currTimerInfo.running = !tInfo.currTimerInfo.running
                            }
                            Button {
                                id: reset
                                text: ""
                                contentItem: Text {
                                    text: reset.text
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font {
                                        pointSize: 12
                                        family: "FiraCodeNerdFont"
                                    }
                                }
                                background: Rectangle {
                                    implicitWidth: 40
                                    radius: reset.height / 2
                                }
                                onClicked: tInfo.currTimerInfo.secondsLeft = tInfo.currTimerInfo.totalSeconds
                            }
                        }
                    }
                }
            }
            Repeater {
                model: times.timers
                Rectangle {
                    id: background
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: timer.width + 2 * timer.height
                    implicitHeight: timer.height
                    radius: timer.height
                    required property TimerInfo modelData
                    required property int index
                    property bool isCurrent: times.currTimer === index
                    color: isCurrent ? "white": "transparent"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: times.currTimer = background.index;
                    }
                    RowLayout {
                        id: timer
                        anchors.centerIn: parent
                        property TimerInfo modelData: background.modelData
                        property int index: background.index
                        Text {
                            text: timer.modelData.name
                            color: background.isCurrent ? "#1E1E1E" : "white"
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                        }
                        Item {
                            implicitWidth: 20
                        }
                        Text {
                            text: {
                                const hoursText = ((timer.modelData.hours < 10) ? "0" : "") + timer.modelData.hours;
                                const minutesText = ((timer.modelData.minutes < 10) ? "0" : "") + timer.modelData.minutes;
                                const secondsText = ((timer.modelData.seconds < 10) ? "0" : "") + timer.modelData.seconds;
                                return hoursText + ":" + minutesText + ":" + secondsText;
                            }
                            color: background.isCurrent ? "#1E1E1E" : "white"
                            font {
                                pointSize: 12
                                family: "FiraCodeNerdFont"
                            }
                        }
                        Item {
                            implicitWidth: 20
                        }
                        Button {
                            id: playTimer
                            text: timer.modelData.running ? "" : ""
                            implicitWidth: playTimer.height
                            onClicked: timer.modelData.running = !timer.modelData.running;
                            contentItem: Text {
                                text: playTimer.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    pointSize: 12
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            background: Rectangle {
                                radius: playTimer.height / 2
                            }
                        }
                        Button {
                            id: resetTimer
                            text: ""
                            implicitWidth: resetTimer.height
                            contentItem: Text {
                                text: resetTimer.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.horizontalCenterOffset: -1.5
                                font {
                                    pointSize: 12
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            background: Rectangle {
                                implicitWidth: 40
                                radius: resetTimer.height / 2
                            }
                            onClicked: timer.modelData.secondsLeft = timer.modelData.totalSeconds
                        }
                        Button {
                            id: deleteTimer
                            text: ""
                            implicitWidth: deleteTimer.height
                            contentItem: Text {
                                text: deleteTimer.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    pointSize: 12
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            background: Rectangle {
                                implicitWidth: 40
                                radius: deleteTimer.height / 2
                            }
                            onClicked: {
                                var timers = times.timers
                                timers.splice(timer.index, 1)
                                if (timers.length === 0) {
                                    times.currTimer = -1;
                                } else if (times.currTimer > timer.index) {
                                    times.currTimer -= 1;
                                } else if (times.currTimer === timer.index) {
                                    times.currTimer = 0;
                                }
                            }
                        }
                        function handleConnection() {
                            if (!timer || timer.modelData.secondsLeft === 0) timer.modelData.running = false;
                            if (timer && timer.modelData.running) timer.modelData.secondsLeft -= 1
                        }
                        Component.onCompleted: {
                            Time.tick.connect(handleConnection)
                        }
                        Component.onDestruction: Time.tick.disconnect(handleConnection)
                    }
                }
            }
        }
    }
    component TimerInfo: QtObject {
        property int totalSeconds: 0
        readonly property int timerHours: Math.floor(totalSeconds / 3600)
        readonly property int timerMinutes: Math.floor((totalSeconds % 3600) / 60)
        readonly property int timerSeconds: totalSeconds % 60
        property int secondsLeft: 0
        readonly property int hours: Math.floor(secondsLeft / 3600)
        readonly property int minutes: Math.floor((secondsLeft % 3600) / 60)
        readonly property int seconds: secondsLeft % 60
        property bool running: false
        property int editing: 0
        property string name: "Timer"
    }

    Component {
        id: timerInfo
        TimerInfo {}
    }

    onVisibleChanged: if (visible) Time.updateOffsets()
}
