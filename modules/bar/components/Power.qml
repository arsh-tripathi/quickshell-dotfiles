import QtQuick.Controls
import Quickshell.Services.UPower
import qs.utils

Button {
    id: power
    text: Icons.getBatteryIcon(UPower.displayDevice.percentage)
    implicitHeight: 30
    implicitWidth: 30
}
