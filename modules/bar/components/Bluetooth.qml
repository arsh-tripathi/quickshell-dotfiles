import QtQuick.Controls
import Quickshell.Bluetooth
import qs.utils

Button {
    id: bluetooth
    text: {
        const defAdapter = Bluetooth.defaultAdapter
        if (!defAdapter?.enabled) {
            return "󰂲"
        }
        const devices = defAdapter.devices.values
        if (
            Bluetooth.devices.values.length > 0 &&
            devices.length > 0 &&
            devices[0].connected
        ) {
            return Icons.getBluetoothIcon(devices[0].icon);
        } else {
            return "󰂱 "
        }

    }
    implicitHeight: 30
    implicitWidth: 30

}
