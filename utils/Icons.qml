pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    function getNetworkIcon(strength: int): string {
        if (strength >= 80)
            return "󰤨"
        if (strength >= 60)
            return "󰤥"
        if (strength >= 40)
            return "󰤢"
        if (strength >= 20)
            return "󰤟"
        return "󰤯"
    }

    function getBluetoothIcon(icon: string): string {
        if (icon.includes("headset") || icon.includes("headphones"))
            return "󰥰";
        if (icon.includes("audio"))
            return "󰂰";
        if (icon.includes("phone"))
            return "󰏳";
        if (icon.includes("mouse"))
            return "󰦋";
        if (icon.includes("keyboard"))
            return "󰌌";
        return "";
    }

    function getBatteryIcon(charge: real): string {
        if (charge > 1.0 || charge < 0.0) return "󰂃";
        if (charge >= 0.9) return "󰁹";
        if (charge >= 0.8) return "󰂂";
        if (charge >= 0.7) return "󰂁";
        if (charge >= 0.6) return "󰂀";
        if (charge >= 0.5) return "󰁿";
        if (charge >= 0.4) return "󰁾";
        if (charge >= 0.3) return "󰁽";
        if (charge >= 0.2) return "󰁼";
        if (charge >= 0.1) return "󰁻";
        return "󰁺";
    }

    function getBatteryPercentageIcon(charge: int): string {
        if (charge > 100 || charge < 0) return "󰂃";
        if (charge >= 90) return "󰁹";
        if (charge >= 80) return "󰂂";
        if (charge >= 70) return "󰂁";
        if (charge >= 60) return "󰂀";
        if (charge >= 50) return "󰁿";
        if (charge >= 40) return "󰁾";
        if (charge >= 30) return "󰁽";
        if (charge >= 20) return "󰁼";
        if (charge >= 10) return "󰁻";
        return "󰁺";
    }
}
