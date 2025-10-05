pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.utils
import qs.widgets

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
    function refreshTasks() {
        Tasks.refresh();
    }
    RowLayout {
        ColumnLayout {
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
                        Tasks.getTasks(calendar.selectedDate, root.month, root.year, 
                                       calendar.selectedDate, root.month, root.year)
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
                        Tasks.getTasks(calendar.selectedDate, root.month, root.year, 
                                       calendar.selectedDate, root.month, root.year)
                    }
                }
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: calendar.width
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
                        onClicked: {
                            calendar.selectedDate = index + 1;
                            Tasks.getTasks(calendar.selectedDate, root.month, root.year, 
                                           calendar.selectedDate, root.month, root.year)
                        }
                    }
                }
            }
        }
        ColumnLayout {
            Button {
                text: "Create Task"
                onClicked: {
                    Tasks.createTask(
                        newTitle.text, 
                        newDesc.text, 
                        hasDueCheck.checkState === Qt.Checked,
                        datePicker.date,
                        datePicker.month,
                        datePicker.year
                    );
                    newTitle.text = "";
                    newDesc.text = "";
                    hasDueCheck.checkState === Qt.Unchecked
                    datePicker.date = calendar.selectedDate;
                    datePicker.date = root.month;
                    datePicker.year = root.year;
                }
            }
            RowLayout {
                Text {
                    text: "Due Date:"
                }
                CheckBox {
                    id: hasDueCheck
                    checkState: Qt.Unchecked
                }
            }
            DatePickerWidget {
                id: datePicker
                visible: hasDueCheck.checkState === Qt.Checked
                date: calendar.selectedDate
                month: root.month
                year: root.year
            }
            TextField {
                id: newTitle
                placeholderText: "Title"
            }
            TextField {
                id: newDesc
                placeholderText: "Description"
            }
        }
    }

    Text {
        text: "No Due Date:"
        visible: Tasks.noDueDate.length > 0
    }
    ScrollView {
        implicitHeight: 50
        ColumnLayout {
            Repeater {
                id: noDueTasklist
                model: Tasks.noDueDate
                RowLayout {
                    id: task
                    required property Tasks.Task modelData
                    property bool editing: false;
                    CheckBox {
                        visible: !task.editing
                        Layout.alignment: Qt.AlignTop
                        id: checkbox
                        enabled: !Tasks.toggling
                        checkState: task.modelData.completed ? Qt.Checked : Qt.Unchecked
                        onClicked: Tasks.toggleStatus(task.modelData.id)
                    }
                    DatePickerWidget {
                        id: picker
                        visible: task.editing
                        date: task.modelData.day
                        month: task.modelData.month
                        year: task.modelData.year
                    }
                    ColumnLayout {
                        Text {
                            visible: !task.editing
                            text: task.modelData.title
                            Layout.preferredWidth: 200
                            font.strikeout: checkbox.checkState === Qt.Checked
                        }
                        TextField {
                            id: title
                            visible: task.editing
                            text: task.modelData.title
                            // Keys.onReturnPressed: console.log("Enter")
                        }
                        Text {
                            visible: !task.editing
                            text: task.modelData.notes
                            Layout.preferredWidth: 200
                            font.strikeout: checkbox.checkState === Qt.Checked
                            wrapMode: Text.Wrap
                        }
                        TextField {
                            id: desc
                            visible: task.editing
                            text: task.modelData.notes
                            // Keys.onReturnPressed: console.log("Enter")
                        }
                    }
                    Button {
                        text: (task.editing) ? "Save" : "Edit"
                        implicitWidth: 40
                        onClicked: {
                            if (task.editing && 
                                (title.text != task.modelData.title || 
                                 desc.text  != task.modelData.notes)) {
                                Tasks.setTitleAndDesc(task.modelData.id, title.text, desc.text);
                            } else if (
                                picker.date != task.modelData.day ||
                                picker.month != task.modelData.month ||
                                picker.year  != task.modelData.year) {
                                Tasks.setDueDate(task.modelData.id, picker.date, picker.month, picker.year)
                            }

                            task.editing = !task.editing
                        }
                    }
                    Button {
                        text: "Delete"
                        implicitWidth: 50
                        onClicked: {
                            task.visible = false;
                            Tasks.deleteTask(task.modelData.id)
                        }
                    }
                }
            }
        }
    }
    Text {
        text: "Due soon:"
        visible: Tasks.incomplete.length > 0
    }
    ScrollView {
        Layout.fillHeight: true
        implicitWidth: 400
        ColumnLayout {
            Repeater {
                id: tasklist
                model: Tasks.incomplete
                RowLayout {
                    id: task2
                    required property Tasks.Task modelData
                    property bool editing: false;
                    Text {
                        visible: !task2.editing
                        Layout.alignment: Qt.AlignTop
                        text: task2.modelData.day + "/" + task2.modelData.month + "/" + task2.modelData.year;
                    }
                    CheckBox {
                        visible: !task2.editing
                        Layout.alignment: Qt.AlignTop
                        id: checkbox2
                        enabled: !Tasks.toggling
                        checkState: task2.modelData.completed ? Qt.Checked : Qt.Unchecked
                        onClicked: Tasks.toggleStatus(task2.modelData.id)
                    }
                    DatePickerWidget {
                        id: picker2
                        visible: task2.editing
                        date: task2.modelData.day
                        month: task2.modelData.month
                        year: task2.modelData.year
                    }
                    ColumnLayout {
                        Text {
                            visible: !task2.editing
                            text: task2.modelData.title
                            Layout.preferredWidth: 200
                            font.strikeout: checkbox2.checkState === Qt.Checked
                        }
                        TextField {
                            id: title2
                            visible: task2.editing
                            text: task2.modelData.title
                            // Keys.onReturnPressed: console.log("Enter")
                        }
                        Text {
                            visible: !task2.editing
                            text: task2.modelData.notes
                            Layout.preferredWidth: 200
                            font.strikeout: checkbox2.checkState === Qt.Checked
                            wrapMode: Text.Wrap
                        }
                        TextField {
                            id: desc2
                            visible: task2.editing
                            text: task2.modelData.notes
                            // Keys.onReturnPressed: console.log("Enter")
                        }
                    }
                    Button {
                        text: (task2.editing) ? "Save" : "Edit"
                        implicitWidth: 40
                        onClicked: {
                            if (task2.editing) {
                                if (title2.text != task2.modelData.title || 
                                    desc2.text  != task2.modelData.notes) {
                                    Tasks.setTitleAndDesc(task2.modelData.id, title2.text, desc2.text);
                                } else if (
                                    picker2.date!= task2.modelData.day ||
                                    picker2.month != task2.modelData.month ||
                                    picker2.year  != task2.modelData.year) {
                                    Tasks.setDueDate(task2.modelData.id, picker2.date, picker2.month, picker2.year)
                                }
                            }
                            task2.editing = !task2.editing
                        }
                    }
                    Button {
                        text: "Delete"
                        implicitWidth: 50
                        onClicked: {
                            task2.visible = false;
                            Tasks.deleteTask(task2.modelData.id)
                        }
                    }
                }
            }
        }
    }
}
