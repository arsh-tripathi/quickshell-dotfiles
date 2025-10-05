pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Hyprland

Singleton {
    id: root
    function fitString(str: string, length: int): string {
        if (str.length > length) return str.slice(0, length - 3) + "...";
        else return str.padEnd(length, ' ');
    }

    function getVolString(volume: int): string {
        if (volume >= 50) return " ";
        else if (volume > 0) return " ";
        else return " "
    }

    function getNetFreqStr(freq: int): string {
        if (Math.abs(freq - 2400) <= 200)
            return "2.4GHz";
        else if (Math.abs(freq - 5000) <= 200)
            return "5.0GHz";
        else if (freq >= 5000)
            return "5.0GHz";
        else
            return "2.4GHz";
    }

    function getTimeStr(seconds: real): string {
        let hours = Math.floor(seconds / 3600);
        let minutes = Math.floor((seconds % 3600) / 60);
        if (hours === 0)
            return minutes + "min";
        else 
            return hours + "h " + minutes + "min";
    }

    function offsetDate(curr_date: date, local_offset: int, offset: int): date {
        curr_date.setSeconds(curr_date.getUTCSeconds() - local_offset + offset);
        return curr_date;
    }

    function removeElement(l: list<var>, index: int): list<var> {
        if (index < 0 || index >= l.length) return;
        for (var i = index; i < l.length; i++) {
            l[i] = l[i+1]
        }
        l.length -= 1;
        return l;
    }

    function getMonthNumDays(month: int, year: int): int {
        const isLeap = (year % 400 === 0) || (year % 100 !== 0 && year % 4 === 0)
        if (month === 1 || month === 3 || month === 5 || month === 7 || month === 8 || month === 10 || month === 12)
            return 31;
        else if (month === 2)
            return (isLeap) ? 29: 28;
        else
            return 30;
    }

    function getCalenderHeader(month: int, year: int): string {
        let monthString = 
            (month === 1) ? "January" :
            (month === 2) ? "February" :
            (month === 3) ? "March" :
            (month === 4) ? "April" :
            (month === 5) ? "May" :
            (month === 6) ? "June" :
            (month === 7) ? "July" :
            (month === 8) ? "August" :
            (month === 9) ? "September" :
            (month === 10) ? "October" :
            (month === 11) ? "November" :
            "December";
        return monthString + " - " + year;
    }

    property int laptopBrigtness: 100
    property int screenBrightness: 100

    function getBrightness(screenName: string): int {
        if (screenName === "eDP-1") return laptopBrigtness;
        else return screenBrightness;
    }

    function setBrightness(screenName: string, value: int) {
        if (screenName === "eDP-1") {
            setLaptopBrightness.brightness = value;
            setLaptopBrightness.running = true;
        }
        else {
            setMonitorBrightness.brightness = value;
            setMonitorBrightness.running = true;
        }
    }

    function increaseBrightness() {
        var monitorName = Hyprland.focusedMonitor.name;
        setBrightness(monitorName, getBrightness(monitorName) + 5);
    }

    function decreaseBrightness() {
        var monitorName = Hyprland.focusedMonitor.name;
        setBrightness(monitorName, getBrightness(monitorName) - 5);
    }

    Process {
        id: getLaptopBrightness
        running: true
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.laptopBrigtness = parseInt(text.split(',')[3].slice(0, -1))
            }
        }
        onRunningChanged: if (!running && root.refresh) running = true;
    }

    Process {
        id: setLaptopBrightness
        property int brightness
        command: ["brightnessctl", "set", brightness + "%"]
        onExited: (exitCode, _) => {
            if (exitCode === 0) root.laptopBrigtness = setLaptopBrightness.brightness
        }
    }

    Process {
        id: getMonitorBrightness
        running: true
        command: ["ddcutil", "getvcp", "10"]
        stdout: StdioCollector {
            onStreamFinished: {
                const current = parseInt(text.split('=')[1].split(',')[0].trim())
                const max = parseInt(text.split('=')[2].trim())
                root.screenBrightness = (current / max) * 100;
            }
        }
        onRunningChanged: if (!running && root.refresh) running = true;
    }

    Process {
        id: setMonitorBrightness
        property int brightness
        command: ["ddcutil", "setvcp", "10", brightness]
        onExited: (exitCode, _) => {
            if (exitCode === 0) root.screenBrightness = setMonitorBrightness.brightness
        }
    }

    function setVolume(value: int) {
        setVolumeProc.value = value;
        setVolumeProc.running = true;
    }

    function getVolume(): int {
        getVolume.running = true;
        return volume;
    }

    function increaseVolume() {
        setVolume(volume + 5);
    }

    function decreaseVolume() {
        setVolume(volume - 5);
    }

    property int volume: 100
    property bool refresh: false
    property alias refreshLapBri: getLaptopBrightness.running
    property alias refreshScreenBri: getMonitorBrightness.running
    property alias refreshVolume: getVolumeProc.running

    Process {
        id: getVolumeProc
        running: true
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.volume = parseInt(text.split('/')[1].trim().slice(0, -1))
            }
        }
        onRunningChanged: if (!running && root.refresh) running = true;
    }

    Process {
        id: setVolumeProc
        property int value
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", value + "%"]
        onExited: (exitCode, _) => {
            if (exitCode === 0) root.volume = value;
        }
    }

    property bool muted: false

    function toggleMute() {
        setMute.running = true;
    }

    Process {
        id: getMute
        running: true
        command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.muted = text.split(':')[1].trim() === "yes"
            }
        }
        onRunningChanged: if (!running && root.refresh) running = true;
    }


    Process {
        id: setMute
        command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
        onExited: (exitCode, _) => {
            if (exitCode === 0) root.muted = !root.muted
        }
    }
}
