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
}
