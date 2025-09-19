pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Setup cli for tasks and calendar first using google apis
Singleton {
    id: root
    readonly property list<Task> tasks: []
    readonly property list<Task> incomplete: {
        const ret = []
        for (var i = 0; i < tasks.length; ++i) {
            if (!tasks[i].completed && tasks[i].hasDueDate) 
                ret.push(tasks[i])
        }
        return ret;
    }
    readonly property list<Task> noDueDate: {
        const ret = []
        for (var i = 0; i < tasks.length; ++i) {
            if (!tasks[i].completed && !tasks[i].hasDueDate) 
                ret.push(tasks[i])
        }
        return ret;
    }
    readonly property bool running: refreshTasks.running
    readonly property bool toggling: toggleComplete.running
    readonly property bool updating: setTitle.running || setDesc.running
    property bool lock: false

    function refresh(): void {
        if (root.lock) return;
        refreshTasks.running = true;
        root.lock = true;
        unlock.start()
    }

    Timer {
        id: unlock
        interval: 10000
        onTriggered: root.lock = false;
    }

    function getTasks(startDay: int, startMonth: int, startYear: int, endDay: int, endMonth: int, endYear: int): list<Task> {
        const tasks = root.tasks
        const ret = []
        for (var i = 0; i < tasks.length; ++i) {
            const day = tasks[i].day;
            const month = tasks[i].month;
            const year = tasks[i].year;
            if (startDay <= day && day <= endDay &&
                startMonth <= month && month <= endMonth && 
                startYear <= year && year <= startYear) {
                ret.push(tasks[i])
            }
        }
    }

    function toggleStatus(taskId: string) {
        toggleComplete.taskId = taskId;
        toggleComplete.running = true;
    }

    function createTask(title: string, desc: string, hasDueDate: bool, date: int, month: int, year: int) {
        createTaskProc.title = title;
        createTaskProc.notes = desc;
        createTaskProc.dueDateString = (hasDueDate) ? date + "/" + month + "/" + year: "";
        createTaskProc.running = true;
    }

    function deleteTask(taskId: string) {
        deleteTaskProc.taskId = taskId
        deleteTaskProc.running = true;
    }

    function setTitleAndDesc(taskId: string, newTitle: string, newDesc: string) {
        setTitle.taskId = taskId;
        setTitle.newTitle = newTitle;
        setTitle.newDesc = newDesc;
        setTitle.running = true;
    }

    function setDueDate(taskId: string, day: int, month: int, year: int) {
        setDue.taskId = taskId;
        setDue.date = day + "/" + month + "/" + year;
        setDue.running = true;
    }

    Process {
        id: deleteTaskProc
        running: false
        property string taskId
        command: ["gtasks-cli", "delete", "--task", taskId]
        onExited: refreshTasks.running = true;
    }

    Process {
        id: setTitle
        running: false
        property string taskId
        property string newTitle
        property string newDesc
        command: ["gtasks-cli", "update", "--field", "title", "--value", newTitle, "--task", taskId]
        onExited: (exitCode, _) => {
            if (exitCode !== 0) console.error("Error while updating title")
            setDesc.taskId = taskId;
            setDesc.newDesc = newDesc;
            setDesc.running = true;
        }
    }

    Process {
        id: setDesc
        running: false
        property string taskId
        property string newDesc
        command: ["gtasks-cli", "update", "--field", "notes", "--value", newDesc, "--task", taskId]
        onExited: (exitCode, _) => {
            if (exitCode !== 0) console.error("Error while updating title")
            refreshTasks.running = true;
        }
    }

    Process {
        id: setDue
        property string taskId
        property string date
        command: ["gtasks-cli", "update", "--field", "due", "--value", setDue.date, "--task", taskId]
        onExited: refreshTasks.running = true;
    }

    Process {
        id: toggleComplete
        running: false
        property string taskId
        command: ["gtasks-cli", "toggleCompleted", "--task", taskId]
        onExited: refreshTasks.running = true;
    }

    Process {
        id: createTaskProc
        running: false
        property string title
        property string notes
        property string dueDateString
        command: {
            var commandList = ["gtasks-cli", "insert", "--title", title]
            if (notes !== "") {
                commandList.push("--notes")
                commandList.push(notes)
            }
            if (dueDateString !== "") {
                commandList.push("--due")
                commandList.push(dueDateString)
            }
            return commandList;
        }
        onExited: refreshTasks.running = true;

    }

    Process {
        id: refreshTasks
        running: true
        command: ["gtasks-cli", "list", "--showCompleted", "--sortDue", "--asc"]
        onExited: (ec, _) => {
            if (ec !== 0) console.log("ERROR")
        }
        stdout: StdioCollector {
            onStreamFinished: {
                const rTasks = root.tasks;
                const taskStrings = text.trim().split('\n');
                rTasks.forEach(n => n.destroy())
                rTasks.length = 0
                for (var i = 0; i < taskStrings.length; ++i) {
                    const taskString = taskStrings[i]
                    const fields = taskString.split('|');
                    const tcompleted = fields[3] === " "
                    const dueDatePresent = fields[4] !== ""
                    const date = (dueDatePresent) ? fields[4].split('T')[0].split('-') : null;
                    const tday = (dueDatePresent) ? parseInt(date[2]): 0
                    const tmonth = (dueDatePresent) ? parseInt(date[1]): 0
                    const tyear = (dueDatePresent) ? parseInt(date[0]): 0
                    rTasks.push(taskComp.createObject(root, {
                        id: fields[0],
                        title: fields[1],
                        notes: fields[2],
                        hasDueDate: dueDatePresent,
                        day: tday,
                        month: tmonth,
                        year: tyear,
                        completed: tcompleted,
                        position: fields[5]
                    }))
                }
            }
        }
    }

    component Task: QtObject {
        required property string id
        required property string title
        property string parent: ""
        property string notes: ""
        property bool hasDueDate: false
        property int day: 0
        property int month: 0
        property int year: 0
        property bool completed: false
        property int position: 0
    }

    Component {
        id: taskComp
        Task {}
    }
}
