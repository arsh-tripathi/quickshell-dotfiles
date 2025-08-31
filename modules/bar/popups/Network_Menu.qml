import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.widgets
import qs.utils
import qs.services

PopupMenu {
    id: network_popup
    implicitWidth: 300
    implicitHeight: 300
    ScrollView {
        width: 300
        height: 300
        ColumnLayout {
            Switch {
                text: "Enabled"
                checked: {
                    Network.getWifiStatus();
                    return Network.wifiEnabled;
                }
                onToggled: {
                    Network.enableWifi(checked)
                }
            }
            Button {
                text: "Scan"
                enabled: !Network.scanning
                onClicked: Network.rescanWifi()
            }
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
                                font: "FiraCodeNerdFont"
                            }
                            Text {
                                text: Utils.getNetFreqStr(connection.modelData.frequency, 5)
                                font: "FiraCodeNerdFont"
                            }
                            HoverText {
                                text: Icons.getNetworkIcon(connection.modelData.strength)
                                ToolTip.text: connection.modelData.strength
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
    }
}
