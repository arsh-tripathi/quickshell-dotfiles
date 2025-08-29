import QtQuick
import QtQuick.Controls
import qs.services

Button {
    id: clock
    text: Time.format("hh\nmm")
    implicitHeight: 60
    implicitWidth: 30
}
