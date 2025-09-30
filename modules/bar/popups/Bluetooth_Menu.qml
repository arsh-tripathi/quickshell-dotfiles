import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.widgets
import qs.utils

PopupMenu {
    id: blutetooth_popup
    implicitHeight: 300
    implicitWidth: 400
    Rectangle {
        anchors.fill: parent
        color: "#1E1E1E"
        Button {
            id: settings
            text: ""
            implicitHeight: 30
            implicitWidth: 30
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 5
            z: 1  // make sure it draws on top
            background: Rectangle {
                color: "transparent"
                anchors.fill: parent
                radius: 15
            }
            contentItem: Text {
                text: settings.text
                color: "white"
                font {
                    pointSize: 14
                    family: "FiraCodeNerdFont"
                }
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenterOffset: -1.5
                // anchors.verticalCenterOffset: -1
            }
            onClicked: blueman.startDetached()
        }
        Process {
            id: blueman
            running: false
            command: ["blueman-manager"]
        }
        ColumnLayout {
            anchors.fill: parent
            StyledToggle {
                Layout.fillHeight: false
                text: "󰂯"
                checked: Bluetooth.defaultAdapter?.enabled ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) { 
                        adapter.enabled = checked;
                        adapter.discoverable = checked;
                    }
                }
            }
            StyledToggle {
                Layout.fillHeight: false
                text: ""
                checked: Bluetooth.defaultAdapter?.discovering ?? false
                onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter) adapter.discovering = checked;
                }
            }
            Label {
                id: devicesText
                Layout.alignment: Qt.AlignHCenter
                text: "Devices"
                color: "#1E1E1E"
                leftPadding: 20
                rightPadding: 20
                font {
                    pointSize: 13
                    family: "FiraCodeNerdFont"
                }
                background: Rectangle {
                    color: "white"
                    radius: devicesText.height / 2
                }
            }
            ScrollView {
                Layout.preferredWidth: 400
                Layout.maximumHeight: 200
                Layout.leftMargin: 20
                GridLayout {
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter
                    id: devices
                    columns: 5
                    Instantiator {
                        model:
                            [...Bluetooth.devices.values]
                                .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired))
                                .slice(0,5)
                        Item {
                            id: device
                            required property BluetoothDevice modelData
                            property var name: Text {
                                Layout.preferredWidth: 120
                                text: device.modelData.name
                                color: "white"
                                font {
                                    pointSize: 10
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            property var battery: HoverText {
                                Layout.preferredWidth: 20
                                text: (device.modelData.batteryAvailable) ? Icons.getBatteryIcon(device.modelData.battery) : ""
                                ToolTip.text: Math.round(device.modelData.battery * 100) + "%"
                                Layout.alignment: Qt.AlignHCenter
                                color: "white"
                                font {
                                    pointSize: 10
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            property var connect: Button {
                                id: connect
                                implicitWidth: 30
                                implicitHeight: 30
                                text: (device.modelData.connected) ? Icons.getBluetoothIcon(device.modelData.icon) : "󰂲"
                                Layout.preferredWidth: 60
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: (device.modelData.connected) ? "Disconnect" : "Connect"
                                enabled: device.modelData.state != BluetoothDeviceState.Connecting && 
                                         device.modelData.state != BluetoothDeviceState.Disconnecting
                                onClicked: device.modelData.connected = !device.modelData.connected
                                background: Rectangle {
                                    color: (device.modelData.connected) ? "#C44658" : "white"
                                    anchors.fill: parent
                                    radius: 15
                                }
                                contentItem: Text {
                                    text: connect.text
                                    color: (device.modelData.connected) ? "white" : "#1E1E1E"
                                    font {
                                        pointSize: 10
                                        family: "FiraCodeNerdFont"
                                        bold: false
                                    }
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.horizontalCenterOffset: -1.5
                                    // anchors.verticalCenterOffset: -1
                                }
                                Layout.alignment: Qt.AlignHCenter
                            }
                            property var pair: Button {
                                id: pair
                                implicitWidth: 30
                                implicitHeight: 30
                                Layout.preferredWidth: 60
                                text: (device.modelData.paired) ? "󰌹" : "󰌺"
                                hoverEnabled: true
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: (device.modelData.paired) ? "Forget" : "Pair"
                                onClicked: (device.modelData.pairing) 
                                            ? device.modelData.cancelPair() 
                                            : (device.modelData.paired) 
                                                ? device.modelData.forget()
                                                : device.modelData.pair()
                                background: Rectangle {
                                    color: (device.modelData.paired) ? "#C44658" : "white"
                                    anchors.fill: parent
                                    radius: 15
                                }
                                contentItem: Text {
                                    text: pair.text
                                    color: (device.modelData.paired) ? "white" : "#1E1E1E"
                                    font {
                                        pointSize: 10
                                        family: "FiraCodeNerdFont"
                                    }
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.horizontalCenterOffset: -1.5
                                    // anchors.verticalCenterOffset: -1
                                }
                                Layout.alignment: Qt.AlignHCenter
                            }
                            property var trusted: StyledToggle {
                                Layout.preferredWidth: 60
                                ToolTip.text: "Trusted"
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
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
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
