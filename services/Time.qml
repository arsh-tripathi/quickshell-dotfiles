pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.utils

Singleton {
    id: root
    property alias enabled: clock.enabled
    readonly property list<string> timeZones: [
        "America/Toronto",
        "Asia/Kolkata",
        "UTC"
    ]
    property int localOffset: 0
    property list<int> offsets: new Array(root.timeZones.length)
    readonly property date date: clock.date
    readonly property int hours: clock.hours
    readonly property int minutes: clock.minutes
    readonly property int seconds: clock.seconds
    property bool locked: false
    property int coolDown: 10000

    Component.onCompleted: root.updateOffsets()

    function format(fmt: string): string {
        return Qt.formatDateTime(clock.date, fmt);
    }

    function updateOffsets() {
        if (root.locked) return false;
        update_offsets.running = true;
        local_offset.running = true;
        root.locked = true;
        cooldown.running = true;
    }

    function offsetAndFormat(timeZone: string, fmt: string): string {
        const index = root.timeZones.findIndex(x => x === timeZone);
        if (index === -1) return;
        const date = Utils.offsetDate(root.date, root.localOffset, offsets[index]);
        return Qt.formatDateTime(date, fmt);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: root.tick()
    }

    Timer {
        id: cooldown
        running: false
        interval: root.coolDown
        onTriggered: root.locked = false
    }

    Process {
        id: update_offsets
        running: false
        property int timeZoneIndex: 0
        environment: ({
            TZ: root.timeZones[update_offsets.timeZoneIndex]
        })
        command: ["date", "+%z"]
        stdout: StdioCollector {
            onStreamFinished: {
                let gmt_offset = parseInt(text.trim());
                let hours =  Math.floor(gmt_offset / 100);
                let minutes =  gmt_offset % 100;
                root.offsets[update_offsets.timeZoneIndex] = (hours * 60 + minutes) * 60;
                update_offsets.timeZoneIndex += 1
                if (update_offsets.timeZoneIndex < root.timeZones.length) 
                    update_offsets.running = true;
            }
        }
    }

    Process {
        id: local_offset
        running: true
        command: ["date", "+%z"]
        stdout: StdioCollector {
            onStreamFinished: {
                let gmt_offset = parseInt(text.trim());
                let hours =  Math.floor(gmt_offset / 100);
                let minutes =  gmt_offset % 100;
                root.localOffset = (hours * 60 + minutes) * 60;
            }
        }
    }

    signal tick()
}
