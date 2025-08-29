import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    required property string timeZone
    width: 20
    height: 20
    property alias running: clock.running
    readonly property string day: clock.day
    readonly property string monthName: clock.monthName
    readonly property int date: clock.date
    readonly property int month: clock.month
    readonly property int year: clock.year
    readonly property int hours: clock.hours
    readonly property int minutes: clock.minutes
    readonly property int seconds: clock.seconds

    Process {
        id: clock
        running: false
        command: [ "tz-date", "-t", root.timeZone, "-f", "+%A:%B:%d:%m:%Y:%H:%M:%S"]
        property string day: ""
        property string monthName: ""
        property int date: -1
        property int month: -1
        property int year: -1
        property int hours: -1
        property int minutes: -1
        property int seconds: -1
        stdout: SplitParser {
            splitMarker: ":"
            onRead: (data) => {
                if (clock.day == "") clock.day = data.trim();
                else if (clock.monthName == "") clock.monthName = data.trim();
                else if (clock.date == -1) clock.date = parseInt(data);
                else if (clock.month == -1) clock.month = parseInt(data);
                else if (clock.year == -1) clock.year = parseInt(data);
                else if (clock.hours == -1) clock.hours = parseInt(data);
                else if (clock.minutes == -1) clock.minutes = parseInt(data);
                else if (clock.seconds == -1) clock.seconds = parseInt(data);
            }
        }
    }
}
