pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property string power_saving: "power-saver"
    readonly property string balanced: "balanced"
    readonly property string performance: "performance"
    property string current: performance
    readonly property int update_cooldown: 5000
    property bool cooldown: false


    function getProfile() {
        if (root.cooldown) return;
        queryProfile.running = true;
        root.cooldown = true;
        resetCooldown.running = true;
    }

    function setProfile() {
        setProfile.running = true;
    }

    Timer {
        id: resetCooldown
        running: false
        interval: root.update_cooldown
        repeat: false
        onTriggered: root.cooldown = false
    }

    Process {
        id: queryProfile
        running: true
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.current = text.trim()
            }
        }
    }
    Process {
        id: setProfile
        running: false
        command: ["powerprofilesctl", "set", root.current]
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Successfully set performance profile ", root.current)
            }
        }
    }
}
