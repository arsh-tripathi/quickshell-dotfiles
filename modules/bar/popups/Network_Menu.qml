import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets
import qs.utils
import qs.services

PopupMenu {
    id: network_popup
    implicitWidth: 400
    implicitHeight: 300
    backgroundColor: "#1E1E1E"
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
        onClicked: connectionEditor.startDetached()
    }
    Process {
        id: connectionEditor
        running: false
        command: ["nm-connection-editor"]
    }
    ColumnLayout {
        anchors.fill: parent
        StyledToggle {
            text: checked ? "󰤨" : "󰤮"
            checked: {
                Network.getWifiStatus();
                return Network.wifiEnabled;
            }
            onToggled: {
                Network.enableWifi(checked)
            }
        }
        StyledToggle {
            text: ""
            enabled: !Network.scanning
            checked: Network.scanning
            onToggled: Network.rescanWifi()
        }
        ScrollView {
            Layout.fillWidth: true
            Layout.maximumHeight: 200
            GridLayout {
                id: list
                columns: 1
                Instantiator {
                    model: {
                        [...Network.networks].sort((a, b) =>
                            (b.active - a.active) ||
                            (b.connection_attempts - a.connection_attempts) ||
                            (Math.round(b.strength / 10) - Math.round(a.strength / 10)) ||
                            (b.frequency - a.frequency)
                        )
                    }
                    Item {
                        id: connection
                        required property Network.AccessPoint modelData
                        property var connectionInfo: RowLayout {
                            id: networkInfo
                            HoverText {
                                text: Utils.fitString(connection.modelData.ssid, 15)
                                ToolTip.text: connection.modelData.ssid
                                color: "white"
                                font {
                                    pointSize: 10
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            Text {
                                text: Utils.getNetFreqStr(connection.modelData.frequency, 5)
                                color: "white"
                                font {
                                    pointSize: 10
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            HoverText {
                                text: Icons.getNetworkIcon(connection.modelData.strength)
                                ToolTip.text: connection.modelData.strength
                                color: "white"
                                font {
                                    pointSize: 10
                                    family: "FiraCodeNerdFont"
                                }
                            }
                            Button {
                                text: (connection.modelData.active) ? "Disconnect" : "Connect"
                                enabled: !Network.connecting && !Network.disconnecting
                                onClicked: {
                                    if (password.text.length != 0)
                                        Network.connectToNetwork(connection.modelData.ssid, password.text);
                                    else
                                        Network.connectToNetwork(connection.modelData.ssid, "")
                                }
                            }
                        }
                        property var passwordPrompt: RowLayout {
                            id: passPrompt
                            visible: (connection.modelData.isSecure && 
                                      !connection.modelData.active && 
                                      !Network.connecting && 
                                      connection.modelData.connection_attempts > 0) ||
                                     password.text.length != 0
                            Text {
                                text: "Password:"
                            }
                            TextField {
                                id: password
                                placeholderText: "Enter password"
                                echoMode: (show_pass.show) ? TextInput.Normal : TextInput.Password
                                Keys.onReturnPressed: Network.connectToNetwork(connection.modelData.ssid, password.text);
                            }
                            Button {
                                id: show_pass
                                implicitWidth: 30
                                property bool show: false
                                text: (show) ? "󰈉 ": "󰈈 "
                                onClicked: show = !show
                            }
                        }
                    }
                    onObjectAdded: (index, object) => {
                        object.connectionInfo.parent = list
                        object.passwordPrompt.parent = list
                    }
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }
}
