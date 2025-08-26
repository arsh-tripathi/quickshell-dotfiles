import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../../../widgets"
import "../../../utils"

PopupMenu {
    id: blutetooth_popup
    implicitHeight: 300
    implicitWidth: 300
    Rectangle {
        ColumnLayout {
            Switch {
                text: "Enabled"
                checked: Bluetooth.defaultAdapter?.enabled ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) { 
                        adapter.enabled = checked;
                        adapter.discoverable = checked;
                    }
                }
            }
            Switch {
                text: "Discovering"
                checked: Bluetooth.defaultAdapter?.discovering ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) adapter.discovering = checked;
                }
            }
            GridLayout {
                id: devices
                columns: 5
                Text {
                    text: "Device name"
                    Layout.preferredWidth: 120
                }
                Text {
                    text: ""
                }
                Text {
                    text: "Connection"
                }
                Text {
                    text: "Pairing"
                }
                Text {
                    text: "Trusted"
                    Layout.alignment: Qt.AlignHCenter
                }
                Instantiator {
                    model:
                        [...Bluetooth.devices.values]
                            .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired))
                            .slice(0,5)
                    Item {
                        id: device
                        required property BluetoothDevice modelData
                        property var name: Text {
                            text: device.modelData.name
                        }
                        property var battery: HoverText {
                            text: (device.modelData.batteryAvailable) ? Icons.getBatteryIcon(device.modelData.battery) : ""
                            ToolTip.text: Math.round(device.modelData.battery * 100) + "%"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        property var connect: Button {
                            implicitWidth: 20
                            text: (device.modelData.connected) ? Icons.getBluetoothIcon(device.modelData.icon) : "󰂲"
                            ToolTip.delay: 1000
                            ToolTip.visible: hovered
                            ToolTip.text: (device.modelData.connected) ? "Disconnect" : "Connect"
                            enabled: device.modelData.state != BluetoothDeviceState.Connecting && 
                                     device.modelData.state != BluetoothDeviceState.Disconnecting
                            onClicked: device.modelData.connected = !device.modelData.connected
                            Layout.alignment: Qt.AlignHCenter
                        }
                        property var pair: Button {
                            implicitWidth: 20
                            text: (device.modelData.paired) ? "󰌹 " : "󰌺 "
                            hoverEnabled: true
                            ToolTip.delay: 1000
                            ToolTip.visible: hovered
                            ToolTip.text: (device.modelData.connected) ? "Forget" : "Pair"
                            onClicked: (device.modelData.pairing) 
                                        ? device.modelData.cancelPair() 
                                        : (device.modelData.paired) 
                                            ? device.modelData.forget()
                                            : device.modelData.pair()
                            Layout.alignment: Qt.AlignHCenter
                        }
                        property var trusted: Switch {
                            checked: device.modelData.trusted
                            onToggled: device.modelData.trusted = checked
                        }
                    }
                    onObjectAdded: (index, object) => {
                        object.name.parent = devices;
                        object.battery.parent = devices;
                        object.connect.parent = devices;
                        object.pair.parent = devices;
                        object.trusted.parent = devices;
                    }
                }
            }
        }
    }
}
