import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../widgets"
import "../../../utils"
import "../../../services"

PopupMenu {
    id: network_popup
    implicitWidth: 300
    implicitHeight: 300
    Rectangle {
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
            GridLayout {
                id: list
                columns: 1
                Instantiator {
                    model: Network.networks
                            .sort((a, b) => (b.strength - a.strength))
                            .sort((a, b) => (b.active - a.active))
                            .slice(0, 6)
                    Item {
                        id: connection
                        required property Network.AccessPoint modelData
                        property var connectionInfo: RowLayout {
                            Text {
                                text: Utils.fitString(connection.modelData.ssid, 25)
                                font: "FiraCodeNerdFont"
                            }
                            Button {
                                text: (connection.active) ? "Disconnect" : "Connect"
                            }
                        }
                        property var passwordPrompt: RowLayout {
                            id: passPrompt
                            visible: false
                            Text {
                                text: "Password:"
                            }
                            TextField {
                                id: password
                                placeholderText: "Enter password"
                                echoMode: TextInput.NoEcho
                            }
                            Button {
                                id: show_pass
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
