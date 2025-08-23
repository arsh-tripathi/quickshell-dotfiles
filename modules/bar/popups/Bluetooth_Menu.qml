import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../../../widgets"

PopupMenu {
    id: blutetooth_popup
    Rectangle {
        ColumnLayout {
            Switch {
                text: "Enabled"
                checked: Bluetooth.defaultAdapter?.enabled ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) adapter.enabled = checked;
                }
            }
            Switch {
                text: "Disovering"
                checked: Bluetooth.defaultAdapter?.discovering ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) adapter.discovering = checked;
                }
            }
        }
    }
}
