pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.utils

ColumnLayout {
    id: root
    property int date: parseInt(Time.format("d"))
    property int month: parseInt(Time.format("M"))
    property int year: parseInt(Time.format("yyyy"))
    property int startDay: {
        const k = 1
        var m = month - 2
        var y = year
        if (m <= 0) {
            m += 12
            y -= 1
        }
        const C = Math.floor(y / 100);
        const Y = y % 100
        return (k + Math.floor(2.6 * m - 0.2) - 2*C + Y + Math.floor(Y / 4) + Math.floor(C / 4)) % 7;
    }
    RowLayout {
        Button {
            text: " "
            implicitWidth: 30
            onClicked: {
                if (root.month > 0) root.month -= 1;
                else {
                    root.month = 12;
                    root.year -= 1;
                }
            }
        }
        Text {
            text: Utils.getCalenderHeader(root.month, root.year)
            Layout.alignment: Qt.AlignHCenter
        }
        Button {
            text: " "
            implicitWidth: 30
            onClicked: {
                if (root.month < 12) root.month += 1;
                else {
                    root.month = 1;
                    root.year += 1;
                }
            }
        }
        Layout.preferredWidth: calendar.width
        Layout.alignment: Qt.AlignCenter
    }
    GridLayout {
        id: calendar
        columns: 7
        property int selectedDate: root.date
        Repeater {
            model: ["S", "M", "T", "W", "T", "F", "S"]
            Text {
                required property string modelData
                text: {
                    return modelData;
                }
                Layout.alignment: Qt.AlignCenter
            }
        }
        Repeater {
            model: Utils.getMonthNumDays(root.month, root.year)
            Button {
                id: day
                implicitWidth: 25
                implicitHeight: 25
                required property int index;
                text: index + 1
                Layout.row: Math.floor((root.startDay + index) / 7) + 1
                Layout.column: (root.startDay + index) % 7
                background: Rectangle {
                    color: (day.index + 1 === root.date &&
                            root.month === parseInt(Time.format("M")) &&
                            root.year === parseInt(Time.format("yyyy"))) ? "aqua" : 
                            (calendar.selectedDate === day.index + 1) ? "yellow" :"white"
                }
                onClicked: calendar.selectedDate = index + 1
            }
        }
    }
}
