import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services

Button {
    id: timeZone
    required property var modelData
    required property var currentTZ
    property bool isCurrent: modelData[0] === currentTZ
    Layout.alignment: Qt.AlignHCenter

    background: Rectangle {
        color: timeZone.isCurrent ? "white": "transparent"
        radius: 10
    }
    contentItem: RowLayout {
        id: row
        anchors.margins: 10
        Text {
            text: modelData[1]
            color: timeZone.isCurrent ? "#1E1E1E" : "white"
            font {
                pointSize: 14
                family: "FiraCodeNerdFont"
            }
        }
        ColumnLayout {
            Text {
                text: Time.offsetAndFormat(modelData[0], "hh:mm:ss")
                color: timeZone.isCurrent ? "#1E1E1E" : "white"
                font {
                    pointSize: timeZone.isCurrent ? 12: 8
                    family: "FiraCodeNerdFont"
                }
            }
            Text {
                text: Time.offsetAndFormat(modelData[0], "ddd MMM dd yyyy")
                color: timeZone.isCurrent ? "#1E1E1E" : "white"
                font {
                    pointSize: timeZone.isCurrent ? 12: 8
                    family: "FiraCodeNerdFont"
                }
            }
        }
    }
}
