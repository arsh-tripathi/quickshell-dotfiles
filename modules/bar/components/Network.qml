import QtQuick.Controls
import "../../../services"
import "../../../utils"

Button {
    id: network
    text: Network.active ? Icons.getNetworkIcon(Network.active.strength) : "󰤫 "
    implicitHeight: 30
    implicitWidth: 30
}
