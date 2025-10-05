import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Tumbler {
    id: tumbler
    implicitHeight: 60
    implicitWidth: 60
    property color unhighlighted: "#C44658"
    property color highlighted: "white"
    delegate: Text {
        required property int index
        required property int modelData
        text: padWithZeros(modelData)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
        font {
            pointSize: 12
            family: "FiraCodeNerdFont"
        }
        function padWithZeros(num: int): string {
            return (num < 10) ? "0" + num : num;
        }
    }
}
